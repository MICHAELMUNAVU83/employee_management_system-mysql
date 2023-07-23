defmodule EmployeeManagementSystemWeb.GroupLive.Show do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Groups
  alias EmployeeManagementSystem.Groups.Group
  alias EmployeeManagementSystem.GroupMembers
  alias EmployeeManagementSystem.GroupMembers.GroupMember
  alias EmployeeManagementSystem.Users

  alias EmployeeManagementSystem.GroupMessages
  alias EmployeeManagementSystem.GroupMessages.GroupMessage

  @impl true
  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])
    search_changeset = Groups.change_group(%Group{})

    {:ok,
     socket
     |> assign(:current_user, user)
     |> assign(:search_changeset, search_changeset)
     |> assign(:group_message_changeset, GroupMessages.change_group_message(%GroupMessage{}))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    all_department_users =
      Groups.list_department_users_not_in_a_group(
        socket.assigns.current_user.department,
        id,
        socket.assigns.current_user.id
      )
      |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)
      |> Enum.map(fn user -> {user.email, user.id} end)

    all_general_users =
      Groups.list_users_not_in_a_group(
        id,
        socket.assigns.current_user.id
      )
      |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)
      |> Enum.map(fn user -> {user.email, user.id} end)

    group_messages = GroupMessages.list_group_messages_for_a_group(id)
    groups_for_user = Groups.list_groups_for_a_member(socket.assigns.current_user.id)
    all_groups = Groups.list_groups()

    all_groups_in_my_department =
      Groups.list_groups()
      |> Enum.filter(fn group -> group.department == socket.assigns.current_user.department end)

    groups =
      case socket.assigns.current_user.role do
        "manager" ->
          all_groups_in_my_department

        _ ->
          groups_for_user
      end

    all_users =
      if socket.assigns.current_user.email == "admin@gmail.com" do
        all_general_users
      else
        all_department_users
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group_member, %GroupMember{})
     |> assign(:group_message, %GroupMessage{})
     |> assign(:group_messages, group_messages)
     |> assign(:all_users, all_users)
     |> assign(:groups, groups)
     |> assign(:group, Groups.get_group!(id))}
  end

  # def handle_event("validate_message", %{"group_member" => group_member_params}, socket) do
  #   changeset =
  #     socket.assigns.group_member
  #     |> GroupMembers.change_group_member(group_member_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :group_member_changeset, changeset)}
  # end

  def handle_event("save_message", %{"group_message" => %{"text" => text}}, socket) do
    group_message_changeet = GroupMessages.change_group_message(%GroupMessage{})

    if String.trim(text) == "" do
      {:noreply,
       socket
       |> put_flash(:error, "Text can't be blank")}
    else
      case GroupMessages.create_group_message(%{
             user_id: socket.assigns.current_user.id,
             group_id: socket.assigns.group.id,
             text: text
           }) do
        {:ok, _group_message} ->
          {:noreply,
           socket
           |> push_redirect(to: Routes.group_show_path(socket, :show, socket.assigns.group))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, group_member_changeset: changeset)}
      end
    end
  end

  def handle_event("search-group", %{"group" => group_params}, socket) do
    groups =
      Groups.get_group_search_results(group_params["search"], socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:groups, groups)}
  end

  defp page_title(:show), do: "Show Group"
  defp page_title(:edit), do: "Edit Group"
  defp page_title(:addgroupmember), do: "New Group"
end
