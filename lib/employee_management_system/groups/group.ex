defmodule EmployeeManagementSystem.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :department, :string
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :description, :department])
    |> validate_required([:name, :description, :department])
  end
end
