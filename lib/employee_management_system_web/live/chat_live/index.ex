defmodule EmployeeManagementSystemWeb.ChatLive.Index do
  use EmployeeManagementSystemWeb, :live_view
  alias EmployeeManagementSystem.Messages
  alias EmployeeManagementSystem.Messages.Message

  alias EmployeeManagementSystem.Users
  alias EmployeeManagementSystem.Groups
  alias EmployeeManagementSystem.Groups.Group

  def mount(_params, session, socket) do
    if session["user_token"] != nil do
      user = Users.get_user_by_session_token(session["user_token"])

      first_4_users =
        Users.list_users_except_current_user(user.id)
        |> Enum.take(4)
        |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)

      groups = Groups.list_groups_for_a_member(user.id)
      all_groups_for_a_department = Groups.list_groups_for_a_department(user.department)
      search_changeset = Messages.change_message(%Message{})

      {:ok,
       socket
       |> assign(:messages, Messages.list_messages())
       |> assign(:changeset, Groups.change_group(%Group{}))
       |> assign(:group, %Group{})
       |> assign(:groups, groups)
       |> assign(:current_user, user)
       |> assign(:page_title, "Listing Chats")
       |> assign(:first_4_users, first_4_users)
       |> assign(:search_changeset, search_changeset)
       |> assign(
         :users,
         Users.list_users_except_current_user(user.id)
         |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)
       )}
    else
      {:ok, socket}
    end
  end

  def handle_event("search", %{"message" => message_params}, socket) do
    IO.inspect(message_params["search"])

    {:noreply,
     socket
     |> assign(
       :users,
       Users.get_user_search_results(socket.assigns.current_user, message_params["search"])
     )}
  end
end
