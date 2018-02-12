defmodule TransactionApi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :sender, :string
      add :uniq_id, :string
      add :ts, :utc_datetime
      add :template, :string
      add :subject, :string
      add :email, :string
      add :status, :string
      add :ip, :string
      add :city, :string
      add :user_agent, :string

      timestamps()
    end

  end
end
