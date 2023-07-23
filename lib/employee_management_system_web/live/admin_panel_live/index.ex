defmodule EmployeeManagementSystemWeb.AdminPanelLive.Index do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Users

  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    user = Users.get_user!(current_user.id)
    IO.inspect(user)

    managers =
      Users.list_users_except_current_user(current_user.id)
      |> Enum.filter(fn user -> user.role == "manager" end)

    employees =
      Users.list_users_except_current_user(current_user.id)
      |> Enum.filter(fn user -> user.role == "employee" end)

    {:ok,
     socket
     |> assign(:page_title, "Listing Events")
     |> assign(:managers, managers)
     |> assign(:employees, employees)
     |> assign(:current_user, user)}
  end
end
