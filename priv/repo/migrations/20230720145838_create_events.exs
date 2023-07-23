defmodule EmployeeManagementSystem.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string
      add :date, :string
      add :image, :string

      timestamps()
    end
  end
end
