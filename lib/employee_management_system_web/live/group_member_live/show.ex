defmodule EmployeeManagementSystemWeb.GroupMemberLive.Show do
  use EmployeeManagementSystemWeb, :live_view

  alias EmployeeManagementSystem.GroupMembers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group_member, GroupMembers.get_group_member!(id))}
  end

  defp page_title(:show), do: "Show Group member"
  defp page_title(:edit), do: "Edit Group member"
end
