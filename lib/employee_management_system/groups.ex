defmodule EmployeeManagementSystem.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias EmployeeManagementSystem.Repo

  alias EmployeeManagementSystem.Groups.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  defp list_group_members(group_id) do
    Repo.all(
      from(gm in EmployeeManagementSystem.GroupMembers.GroupMember,
        where: gm.group_id == ^group_id,
        select: gm.user_id
      )
    )
  end

  def list_users_not_in_a_group(group_id, current_user_id) do
    Repo.all(
      from(u in EmployeeManagementSystem.Users.User,
        where: u.id != ^current_user_id
      )
    )
    |> Enum.filter(fn user -> user.id not in list_group_members(group_id) end)
  end

  def get_group_search_results(search, current_user_id) do
    query =
      Repo.all(Group)
      |> Enum.filter(fn group ->
        current_user_id in list_group_members(group.id)
      end)
      |> Enum.filter(fn group ->
        String.contains?(String.downcase(group.name), String.downcase(search))
      end)

    # Repo.all(from(g in query, where: fragment("name ILIKE ?", ^"%#{search}%")))
  end

  def list_department_users_not_in_a_group(department, group_id, current_user_id) do
    Repo.all(
      from(u in EmployeeManagementSystem.Users.User,
        where: u.department == ^department and u.id != ^current_user_id
      )
    )
    |> Enum.filter(fn user -> user.id not in list_group_members(group_id) end)
  end

  def list_groups_for_a_member(user_id) do
    Repo.all(Group)
    |> Enum.filter(fn group -> user_id in list_group_members(group.id) end)
  end

  def list_groups_for_a_department(department) do
    Repo.all(
      from(g in Group,
        where: g.department == ^department
      )
    )
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end
end
