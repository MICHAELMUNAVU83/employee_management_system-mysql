defmodule EmployeeManagementSystem.GroupMessages.GroupMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_messages" do
    field :text, :string
    belongs_to :user, EmployeeManagementSystem.Users.User
    belongs_to :group, EmployeeManagementSystem.Groups.Group

    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:text, :user_id, :group_id])
    |> validate_required([:text, :user_id, :group_id])
  end
end
