defmodule EmployeeManagementSystem.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field(:description, :string)
    field(:due_date, :string)
    field(:status, :string, default: "pending")
    field(:title, :string)
    belongs_to(:user, EmployeeManagementSystem.Users.User)
    has_many(:reviews, EmployeeManagementSystem.Reviews.Review)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date, :status, :user_id])
    |> validate_required([:title, :description, :due_date, :status, :user_id])
  end
end
