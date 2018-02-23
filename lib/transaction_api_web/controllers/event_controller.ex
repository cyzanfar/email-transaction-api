defmodule TransactionApiWeb.EventController do
  use TransactionApiWeb, :controller

  alias TransactionApi.Messages
  alias TransactionApi.Messages.Event
  import TransactionApiWeb.ControllerHelper, only: [parse_incoming: 1]

  action_fallback TransactionApiWeb.FallbackController

  def index(conn, _params) do
    events = Messages.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"mandrill_events" => event_params}) do
    params = parse_incoming event_params
    with {:ok, %Event{} = event} <- Messages.process_events(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Messages.get_event!(id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Messages.get_event!(id)

    with {:ok, %Event{} = event} <- Messages.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Messages.get_event!(id)
    with {:ok, %Event{}} <- Messages.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
