defmodule EmployeeManagementSystem.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string
    field :image, :string
    field :receiver_id, :integer
    field :sender_id, :integer

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :receiver_id, :sender_id, :image])
    |> validate_required([:receiver_id, :sender_id])
  end
end
