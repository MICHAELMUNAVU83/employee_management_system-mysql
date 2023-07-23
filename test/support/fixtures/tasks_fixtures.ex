defmodule EmployeeManagementSystem.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: "some due_date",
        status: "some status",
        title: "some title"
      })
      |> EmployeeManagementSystem.Tasks.create_task()

    task
  end
end
