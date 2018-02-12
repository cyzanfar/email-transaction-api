defmodule TransactionApi.Messages.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias TransactionApi.Messages.Event
  alias TransactionApi.Messages.EventDetail

  schema "events" do
    field :city, :string
    field :email, :string
    field :ip, :string
    field :sender, :string
    field :status, :string
    field :subject, :string
    field :template, :string
    field :ts, :utc_datetime
    field :uniq_id, :string
    field :user_agent, :string

    has_many :event_details, EventDetail

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:sender, :uniq_id, :ts, :template, :subject, :email, :status, :ip, :city, :user_agent])
    |> cast_assoc(:event_details)
    |> validate_required([:sender, :uniq_id, :ts, :subject, :email, :status])
  end
end
