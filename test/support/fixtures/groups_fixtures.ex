defmodule EmployeeManagementSystem.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        department: "some department",
        description: "some description",
        name: "some name"
      })
      |> EmployeeManagementSystem.Groups.create_group()

    group
  end
end
