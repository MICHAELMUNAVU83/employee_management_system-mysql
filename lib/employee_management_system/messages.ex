defmodule EmployeeManagementSystem.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias EmployeeManagementSystem.Repo

  alias EmployeeManagementSystem.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  def list_messages_for_a_receiver_and_sender(receiver_id, sender_id) do
    Repo.all(
      from m in Message,
        where:
          (m.receiver_id == ^receiver_id and m.sender_id == ^sender_id) or
            (m.receiver_id == ^sender_id and m.sender_id == ^receiver_id)
    )
  end

  def subcribe do
    Phoenix.PubSub.subscribe(EmployeeManagementSystem.PubSub, "messages")
  end

  def broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(EmployeeManagementSystem.PubSub, "messages", {event, message})
    |> IO.inspect()

    {:ok, message}
  end

  def broadcast({:error, changeset}, event) do
    {:error, changeset}
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:create)
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
