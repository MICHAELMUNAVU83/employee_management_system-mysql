defmodule EmployeeManagementSystemWeb.PageController do
  use EmployeeManagementSystemWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
