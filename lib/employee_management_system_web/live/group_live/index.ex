defmodule EmployeeManagementSystemWeb.GroupLive.Index do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Groups
  alias EmployeeManagementSystem.Groups.Group
  alias EmployeeManagementSystem.Users

  @impl true
  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])
    groups_for_user = Groups.list_groups_for_a_member(user.id)

    all_groups =
      Groups.list_groups()
      |> Enum.filter(fn group -> group.department == user.department end)

    IO.inspect(all_groups)
    search_changeset = Groups.change_group(%Group{})

    groups =
      if user.role == "manager" do
        all_groups
      else
        groups_for_user
      end

    {:ok,
     socket
     |> assign(:groups, groups)
     |> assign(:search_changeset, search_changeset)
     |> assign(:current_user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group")
    |> assign(:group, Groups.get_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:group, %Group{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groups")
    |> assign(:group, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group = Groups.get_group!(id)
    {:ok, _} = Groups.delete_group(group)

    {:noreply, assign(socket, :groups, list_groups())}
  end

  def handle_event("search-group", %{"group" => group_params}, socket) do
    groups =
      Groups.get_group_search_results(group_params["search"], socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:groups, groups)}
  end

  defp list_groups do
    Groups.list_groups()
  end
end
