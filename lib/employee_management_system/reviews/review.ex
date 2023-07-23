defmodule EmployeeManagementSystem.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field(:comments, :string)
    field(:score, :integer)
    belongs_to(:task, EmployeeManagementSystem.Tasks.Task)

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:comments, :score, :task_id])
    |> validate_required([:comments, :score, :task_id])
    |> validate_number(:score, greater_than: 0, less_than_or_equal_to: 5)
  end
end
