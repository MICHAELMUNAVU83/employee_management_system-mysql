defmodule EmployeeManagementSystem.GroupMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.GroupMessages` context.
  """

  @doc """
  Generate a group_message.
  """
  def group_message_fixture(attrs \\ %{}) do
    {:ok, group_message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> EmployeeManagementSystem.GroupMessages.create_group_message()

    group_message
  end
end
