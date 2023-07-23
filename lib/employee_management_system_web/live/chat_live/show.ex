defmodule EmployeeManagementSystemWeb.ChatLive.Show do
  alias Mix.Tasks.Hex.User
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.Users
  alias EmployeeManagementSystem.Messages
  alias EmployeeManagementSystem.Messages.Message

  alias EmployeeManagementSystem.Groups
  alias EmployeeManagementSystem.Groups.Group

  @impl true
  def mount(params, session, socket) do
    changeset = Messages.change_message(%Message{})
    user = Users.get_user_by_session_token(session["user_token"])
    search_changeset = Messages.change_message(%Message{})

    image_changeset = Messages.change_message(%Message{})

    first_4_users =
      Users.list_users_except_current_user(user.id)
      |> Enum.take(4)
      |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)

    users =
      Users.list_users_except_current_user(user.id)
      |> Enum.filter(fn user -> user.email != "admin@gmail.com" end)

    receiver_id = String.to_integer(params["id"])

    messages = Messages.list_messages_for_a_receiver_and_sender(user.id, receiver_id)

    if connected?(socket) do
      Messages.subcribe()

      {:ok,
       socket
       |> assign(:message, %Message{})
       |> assign(:image_message, %Message{})
       |> assign(:image_changeset, image_changeset)
       |> assign(:sender_id, user.id)
       |> assign(:current_user, user)
       |> assign(:search_changeset, search_changeset)
       |> assign(:users, users)
       |> assign(:first_4_users, first_4_users)
       |> assign(:messages, messages)
       |> assign(:changeset, changeset)}
    else
      {:ok,
       socket
       |> assign(:message, %Message{})
       |> assign(:image_message, %Message{})
       |> assign(:image_changeset, image_changeset)
       |> assign(:sender_id, user.id)
       |> assign(:current_user, user)
       |> assign(:search_changeset, search_changeset)
       |> assign(:users, users)
       |> assign(:first_4_users, first_4_users)
       |> assign(:messages, messages)
       |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_params(params, _, socket) do
    sender_id = socket.assigns.sender_id

    receiver_id = String.to_integer(params["id"])

    messages = Messages.list_messages_for_a_receiver_and_sender(sender_id, receiver_id)

    all_messages = Messages.list_messages()

    if connected?(socket) do
      Messages.subcribe()

      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:receiver_id, params["id"])
       |> assign(:user, Users.get_user!(params["id"]))}
    else
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:receiver_id, params["id"])
       |> assign(:user, Users.get_user!(params["id"]))}
    end
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    changeset = Messages.change_message(%Message{})

    receiver_id = socket.assigns.receiver_id

    sender_id = socket.assigns.sender_id

    new_message_params =
      Map.put(message_params, "receiver_id", receiver_id)
      |> Map.put("sender_id", sender_id)

    IO.inspect(new_message_params)

    if new_message_params["text"] != "" do
      case Messages.create_message(new_message_params) do
        {:ok, _message} ->
          {:noreply,
           socket
           |> assign(
             :messages,
             Messages.list_messages_for_a_receiver_and_sender(sender_id, receiver_id)
           )
           |> assign(:changeset, changeset)
           |> push_redirect(to: Routes.chat_show_path(socket, :show, receiver_id))}
      end
    else
      {:noreply,
       socket
       |> put_flash(:info, "Message cannot be empty")}
    end
  end

  def handle_info(message, socket) do
    IO.inspect(message, label: "message")
    {:noreply, socket}
  end

  def handle_event("save_text", params, socket) do
    IO.inspect("lalal")
    IO.inspect(params)

    {:noreply,
     socket
     |> put_flash(:info, "Message updated successfully")}
  end

  def handle_event("search", %{"message" => message_params}, socket) do
    {:noreply,
     socket
     |> assign(
       :users,
       Users.get_user_search_results(socket.assigns.current_user, message_params["search"])
     )}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:addimage), do: "Add Image"
end
