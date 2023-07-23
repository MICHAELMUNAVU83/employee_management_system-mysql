defmodule EmployeeManagementSystem.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :description, :string
      add :department, :string

      timestamps()
    end
  end
end
