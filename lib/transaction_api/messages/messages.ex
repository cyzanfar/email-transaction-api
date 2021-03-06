defmodule TransactionApi.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias TransactionApi.Repo

  alias TransactionApi.Messages.Event
  alias TransactionApi.Messages.EventDetail

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def add_event_details(%Event{} = event, details) do
    Enum.map(details, fn(event_detail) ->
      event_detail
      |> Map.put("event_id", event.id)
      |> create_event_detail
    end)
    {:ok, event}
  end

  def process_events(event_params \\ %{}) do
    event_detail = extract_event_details(event_params[:event_details])

    if length(event_detail[:clicks]) > 0
        and event_params[:event][:event_type] != "click" do
          Map.put(event_params[:event], :event_type, "click")
          |> create_or_update_event(event_detail[:clicks])
    else
      event_params[:event]
      |> create_or_update_event(event_detail[:clicks])
    end

    if length(event_detail[:opens]) > 0
        and event_params[:event][:event_type] != "open" do
          Map.put(event_params[:event], :event_type, "open")
          |> create_or_update_event(event_detail[:opens])
    else
      event_params[:event]
      |> create_or_update_event(event_detail[:opens])
    end
  end

  defp create_or_update_event(event_params, details_params) do
    fetch_event = Repo.get_by(
      Event, [uniq_id: event_params[:uniq_id],
        event_type: event_params[:event_type]]
    )
    case fetch_event do
      nil ->  struct(%Event{}, event_params)
      event -> event
    end
    |> Event.changeset(event_params)
    |> Repo.insert_or_update
    |> case do
      {:ok, %Event{} = event} ->
          event
          |> add_event_details(details_params)
    end
  end

  defp extract_event_details(event_details) do
    cond do
      length(event_details) > 0 ->
        %{
          clicks: Enum.filter(event_details, fn detail ->
            if detail["event_type"] == "click", do: detail
          end),
          opens: Enum.filter(event_details, fn detail ->
            if detail["event_type"] == "open", do: detail
          end)
        }
      true ->
        %{clicks: [], opens: []}
    end
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias TransactionApi.Messages.EventDetail

  @doc """
  Returns the list of event_details.

  ## Examples

      iex> list_event_details()
      [%EventDetail{}, ...]

  """
  def list_event_details do
    Repo.all(EventDetail)
  end

  @doc """
  Gets a single event_detail.

  Raises `Ecto.NoResultsError` if the Event detail does not exist.

  ## Examples

      iex> get_event_detail!(123)
      %EventDetail{}

      iex> get_event_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_detail!(id), do: Repo.get!(EventDetail, id)

  @doc """
  Creates a event_detail.

  ## Examples

      iex> create_event_detail(%{field: value})
      {:ok, %EventDetail{}}

      iex> create_event_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_detail(attrs \\ %{}) do
    %EventDetail{}
    |> EventDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_detail.

  ## Examples

      iex> update_event_detail(event_detail, %{field: new_value})
      {:ok, %EventDetail{}}

      iex> update_event_detail(event_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_detail(%EventDetail{} = event_detail, attrs) do
    event_detail
    |> EventDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EventDetail.

  ## Examples

      iex> delete_event_detail(event_detail)
      {:ok, %EventDetail{}}

      iex> delete_event_detail(event_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_detail(%EventDetail{} = event_detail) do
    Repo.delete(event_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_detail changes.

  ## Examples

      iex> change_event_detail(event_detail)
      %Ecto.Changeset{source: %EventDetail{}}

  """
  def change_event_detail(%EventDetail{} = event_detail) do
    EventDetail.changeset(event_detail, %{})
  end
end
