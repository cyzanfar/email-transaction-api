defmodule TransactionApi.Repo.Migrations.AddColumnsToEventDetails do
  use Ecto.Migration

  def change do
    alter table(:event_details) do
      add :ip, :string
      add :city, :string
      add :user_agent, :string
    end
  end
end
