defmodule EmployeeManagementSystem.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :image, :string
      add(:receiver_id, :integer)
      add(:sender_id, :integer)

      timestamps()
    end
  end
end
