defmodule EmployeeManagementSystemWeb.TaskLive.Show do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Users

  alias EmployeeManagementSystem.Tasks
  alias EmployeeManagementSystem.Tasks.Task
  alias EmployeeManagementSystem.Messages
  alias EmployeeManagementSystem.Messages.Message
  alias EmployeeManagementSystem.Reviews
  alias EmployeeManagementSystem.Reviews.Review
  alias EmployeeManagementSystem.Reviews
  alias EmployeeManagementSystem.Reviews.Review
  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])
    search_changeset = Messages.change_message(%Message{})

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:search_changeset, search_changeset)}
  end

  @impl true
  def handle_params(params, _, socket) do
    IO.inspect(params)

    users_in_my_department =
      Users.list_users_in_my_department_except_me(
        socket.assigns.current_user.id,
        socket.assigns.current_user.department
      )

    tasks = Tasks.list_tasks_for_user(params["id"])

    task =
      if params["task_id"] do
        Tasks.get_task!(params["task_id"])
      else
        %Task{}
      end

    review =
      if params["review_id"] do
        Reviews.get_review!(params["review_id"])
      else
        %Review{}
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:task, task)
     |> assign(:tasks, tasks)
     |> assign(:review, review)
     |> assign(:task_changeset, Tasks.change_task(%Task{}))
     |> assign(:users, users_in_my_department)
     |> assign(:user, Users.get_user!(params["id"]))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    tasks = Tasks.list_tasks_for_user(socket.assigns.user.id)

    {:noreply, assign(socket, :tasks, tasks)}
  end

  def handle_event("markasdone", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.update_task(task, %{"status" => "complete"})
    tasks = Tasks.list_tasks_for_user(socket.assigns.user.id)

    IO.inspect(task)

    {:noreply, assign(socket, :tasks, tasks)}
  end

  def handle_event("markaspending", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.update_task(task, %{"status" => "pending"})
    tasks = Tasks.list_tasks_for_user(socket.assigns.user.id)

    IO.inspect(task)

    {:noreply, assign(socket, :tasks, tasks)}
  end

  def handle_event("deletereview", %{"id" => id}, socket) do
    review = Reviews.get_review!(id)
    {:ok, _} = Reviews.delete_review(review)
    tasks = Tasks.list_tasks_for_user(socket.assigns.user.id)

    {:noreply, assign(socket, :tasks, tasks)}
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

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
  defp page_title(:newtask), do: "New Task"
  defp page_title(:newreview), do: "New Review"
  defp page_title(:editreview), do: "Edit Review"
end
