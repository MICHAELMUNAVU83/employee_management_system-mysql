defmodule EmployeeManagementSystemWeb.TaskLive.Index do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Tasks
  alias EmployeeManagementSystem.Tasks.Task
  alias EmployeeManagementSystem.Users
  alias EmployeeManagementSystem.Messages
  alias EmployeeManagementSystem.Messages.Message

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    users_in_my_department =
      Users.list_users_in_my_department_except_me(current_user.id, current_user.department)
     
    search_changeset = Messages.change_message(%Message{})

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:search_changeset, search_changeset)
     |> assign(:users, users_in_my_department)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  def handle_event("search", %{"message" => message_params}, socket) do
    IO.inspect(message_params["search"])

    {:noreply,
     socket
     |> assign(
       :users,
       Users.get_user_search_results_for_users_in_my_department_except_me(
         socket.assigns.current_user,
         message_params["search"]
       )
     )}
  end

  defp list_tasks do
    Tasks.list_tasks()
  end
end
