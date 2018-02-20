defmodule TransactionApi.Messages.EventDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias TransactionApi.Messages.EventDetail
  alias TransactionApi.Messages.Event


  schema "event_details" do
    field :ts, :utc_datetime
    field :url, :string
    field :ip, :string
    field :city, :string
    field :user_agent, :string
    field :event_type, :string

    belongs_to :event, Event, foreign_key: :event_id
    timestamps()
  end

  @doc false
  def changeset(%EventDetail{} = event_detail, attrs) do
    event_detail
    |> cast(attrs, [:url, :ts, :event_id, :ip, :city, :user_agent, :event_type])
    |> validate_required([:ts, :event_id])
  end
end
