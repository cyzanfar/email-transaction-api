defmodule TransactionApi.Repo.Migrations.CreateEventDetails do
  use Ecto.Migration

  def change do
    create table(:event_details) do
      add :url, :string
      add :ts, :utc_datetime
      add :event_id, :integer

      timestamps()
    end

  end
end
