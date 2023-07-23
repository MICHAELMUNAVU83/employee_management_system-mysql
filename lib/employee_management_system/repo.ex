defmodule EmployeeManagementSystem.Repo do
  use Ecto.Repo,
    otp_app: :employee_management_system,
    adapter: Ecto.Adapters.MyXQL
end
