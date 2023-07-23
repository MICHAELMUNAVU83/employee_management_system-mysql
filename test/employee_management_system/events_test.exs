defmodule EmployeeManagementSystem.EventsTest do
  use EmployeeManagementSystem.DataCase

  alias EmployeeManagementSystem.Events

  describe "events" do
    alias EmployeeManagementSystem.Events.Event

    import EmployeeManagementSystem.EventsFixtures

    @invalid_attrs %{name: nil, date: nil, description: nil, image: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        name: "some name",
        date: "some date",
        description: "some description",
        image: "some image"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.date == "some date"
      assert event.description == "some description"
      assert event.image == "some image"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        name: "some updated name",
        date: "some updated date",
        description: "some updated description",
        image: "some updated image"
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.date == "some updated date"
      assert event.description == "some updated description"
      assert event.image == "some updated image"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
