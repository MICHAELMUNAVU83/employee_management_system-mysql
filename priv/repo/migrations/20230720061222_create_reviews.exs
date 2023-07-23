defmodule EmployeeManagementSystem.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :comments, :string
      add :score, :integer
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end
  end
end
