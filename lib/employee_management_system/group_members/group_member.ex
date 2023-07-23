defmodule EmployeeManagementSystem.GroupMembers.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_members" do
    belongs_to :user, EmployeeManagementSystem.Users.User
    belongs_to :group, EmployeeManagementSystem.Groups.Group

    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:user_id, :group_id])
    |> validate_required([:user_id, :group_id])
  end
end
