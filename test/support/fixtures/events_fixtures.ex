defmodule EmployeeManagementSystem.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        date: "some date",
        description: "some description",
        image: "some image"
      })
      |> EmployeeManagementSystem.Events.create_event()

    event
  end
end
