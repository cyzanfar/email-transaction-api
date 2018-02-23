defmodule TransactionApiWeb.ControllerHelper do
  import Helpers.AccessHelper, only: [get_in_attempt: 2]

  def parse_incoming payloads do
    IO.inspect payloads
    payloads
    |> Poison.decode!
    |> Enum.at(0)
    |> get_msg
  end

  defp get_msg payload do
    merge_maps = merge_details payload

    main_map = %{
      "ip" => get_in(payload, ["ip"]),
      "city" => get_in(payload, ["location", "city"]),
      "user_agent" => get_in(payload, ["user_agent"]),
    }
    new_maps = Enum.map(merge_maps, fn elem ->
      elem
      |> Map.update!("ts", &DateTime.from_unix!/1)
      |> Map.merge(main_map)
    end)

    %{
      event: %{
        uniq_id: get_in(payload, ["_id"]),
        ts: get_in(payload, ["ts"]) |> DateTime.from_unix!,
        ip: get_in(payload, ["ip"]),
        sender: get_in(payload, ["msg", "sender"]),
        template: get_in(payload, ["msg", "template"]),
        subject: get_in(payload, ["msg", "subject"]),
        email: get_in(payload, ["msg", "email"]),
        tags: get_in(payload, ["msg", "tags"]),
        status: get_in(payload, ["msg", "state"]),
        city: get_in(payload, ["location", "city"]),
        user_agent: get_in(payload, ["user_agent"]),
        event_type: get_in(payload, ["event"]),
      },
      event_details: new_maps
    }
  end

  defp merge_details(payload) do
    clicks = get_in_attempt(
      payload, ["msg", "clicks"])
      |> Enum.map(fn elem ->
        elem
        |> Map.put("event_type", "click")
      end)
    opens = get_in_attempt(
      payload, ["msg", "opens"])
      |> Enum.map(fn elem ->
        elem
        |> Map.put("event_type", "open")
      end)
    clicks ++ opens
  end
end
