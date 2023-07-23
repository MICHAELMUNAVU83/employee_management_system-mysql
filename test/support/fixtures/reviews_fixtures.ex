defmodule EmployeeManagementSystem.ReviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeManagementSystem.Reviews` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(attrs \\ %{}) do
    {:ok, review} =
      attrs
      |> Enum.into(%{
        comments: "some comments",
        score: 42
      })
      |> EmployeeManagementSystem.Reviews.create_review()

    review
  end
end
