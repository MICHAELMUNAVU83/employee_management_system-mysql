defmodule EmployeeManagementSystem.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :date, :string
    field :description, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :date, :image])
    |> validate_required([:name, :description, :date, :image])
  end
end
