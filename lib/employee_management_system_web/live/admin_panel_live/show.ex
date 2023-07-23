defmodule EmployeeManagementSystemWeb.AdminPanelLive.Show do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Users

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    managers =
      Users.list_users_except_current_user(current_user.id)
      |> Enum.filter(fn user -> user.role == "manager" end)

    employees =
      Users.list_users_except_current_user(current_user.id)
      |> Enum.filter(fn user -> user.role == "employee" end)

    {:ok,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:current_user, current_user)
     |> assign(:managers, managers)
     |> assign(:employees, employees)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Users.get_user!(id))}
  end

  def handle_event("promote_to_manager", %{"id" => id}, socket) do
    IO.inspect("promote_to_manager")
    user = Users.get_user!(id)

    {:ok, user} = Users.update_user(user, %{role: "manager"})
    IO.inspect(user)

    managers =
      Users.list_users_except_current_user(socket.assigns.current_user.id)
      |> Enum.filter(fn user -> user.role == "manager" end)

    employees =
      Users.list_users_except_current_user(socket.assigns.current_user.id)
      |> Enum.filter(fn user -> user.role == "employee" end)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:managers, managers)
     |> assign(:employees, employees)
     |> put_flash(:info, "User promoted to manager successfully")}
  end

  def handle_event("demote_to_employee", %{"id" => id}, socket) do
    user = Users.get_user!(id)

    {:ok, user} = Users.update_user(user, %{role: "employee"})
    IO.inspect(user)

    managers =
      Users.list_users_except_current_user(socket.assigns.current_user.id)
      |> Enum.filter(fn user -> user.role == "manager" end)

    employees =
      Users.list_users_except_current_user(socket.assigns.current_user.id)
      |> Enum.filter(fn user -> user.role == "employee" end)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:managers, managers)
     |> assign(:employees, employees)
     |> put_flash(:info, "User promoted to manager successfully")}
  end

  defp page_title(:show), do: "Show User"
end
