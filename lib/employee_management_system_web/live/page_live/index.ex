defmodule EmployeeManagementSystemWeb.PageLive.Index do
  use EmployeeManagementSystemWeb, :live_view
  alias EmployeeManagementSystem.Messages
  alias EmployeeManagementSystem.Users

  def mount(_params, session, socket) do
    current_user =
      if is_nil(session["user_token"]) do
        ""
      else
        Users.get_user_by_session_token(session["user_token"])
      end

    {:ok,
     socket
     |> assign(:messages, Messages.list_messages())
     |> assign(:current_user, current_user)
     |> assign(:users, Users.list_users())}
  end
end
