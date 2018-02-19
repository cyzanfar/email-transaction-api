defmodule TransactionApi.Repo.Migrations.AddEventTypeToEventDetails do
  use Ecto.Migration

  def change do
    alter table(:event_details) do
      add :event_type, :string
    end
  end
end
