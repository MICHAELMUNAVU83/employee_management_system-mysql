defmodule EmployeeManagementSystem.GroupMessages do
  @moduledoc """
  The GroupMessages context.
  """

  import Ecto.Query, warn: false
  alias EmployeeManagementSystem.Repo

  alias EmployeeManagementSystem.GroupMessages.GroupMessage

  @doc """
  Returns the list of group_messages.

  ## Examples

      iex> list_group_messages()
      [%GroupMessage{}, ...]

  """
  def list_group_messages do
    Repo.all(GroupMessage)
  end

  def list_group_messages_for_a_group(group_id) do
    Repo.all(from(g in GroupMessage, where: g.group_id == ^group_id))
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single group_message.

  Raises `Ecto.NoResultsError` if the Group message does not exist.

  ## Examples

      iex> get_group_message!(123)
      %GroupMessage{}

      iex> get_group_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_message!(id), do: Repo.get!(GroupMessage, id)

  @doc """
  Creates a group_message.

  ## Examples

      iex> create_group_message(%{field: value})
      {:ok, %GroupMessage{}}

      iex> create_group_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_message(attrs \\ %{}) do
    %GroupMessage{}
    |> GroupMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_message.

  ## Examples

      iex> update_group_message(group_message, %{field: new_value})
      {:ok, %GroupMessage{}}

      iex> update_group_message(group_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_message(%GroupMessage{} = group_message, attrs) do
    group_message
    |> GroupMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_message.

  ## Examples

      iex> delete_group_message(group_message)
      {:ok, %GroupMessage{}}

      iex> delete_group_message(group_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_message(%GroupMessage{} = group_message) do
    Repo.delete(group_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_message changes.

  ## Examples

      iex> change_group_message(group_message)
      %Ecto.Changeset{data: %GroupMessage{}}

  """
  def change_group_message(%GroupMessage{} = group_message, attrs \\ %{}) do
    GroupMessage.changeset(group_message, attrs)
  end
end
