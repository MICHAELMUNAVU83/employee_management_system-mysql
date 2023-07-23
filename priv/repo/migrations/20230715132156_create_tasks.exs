defmodule EmployeeManagementSystem.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :due_date, :string
      add :status, :string, default: "pending"
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
