defmodule EmployeeManagementSystem.GroupMembersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.GroupMembers` context.
  """

  @doc """
  Generate a group_member.
  """
  def group_member_fixture(attrs \\ %{}) do
    {:ok, group_member} =
      attrs
      |> Enum.into(%{
        member: "some member"
      })
      |> EmployeeManagementSystem.GroupMembers.create_group_member()

    group_member
  end
end
