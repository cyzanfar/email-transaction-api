defmodule TransactionApi.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias TransactionApi.Repo

  alias TransactionApi.Messages.Event
  alias TransactionApi.Messages.EventDetail

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  def add_event_details(%Event{} = event, details) do
    Enum.map(details, fn(event_detail) ->
      event_detail
      |> Map.put("event_id", event.id)
      |> create_event_detail
    end)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_or_update(%{event: event_params} \\ %{}) do
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
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
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
