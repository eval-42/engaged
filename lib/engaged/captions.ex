defmodule Engaged.Captions do
  @moduledoc """
  Main logic around storage and retrieval of captions.
  """

  alias Engaged.Repo

  alias Engaged.Captions.Caption

  @doc """
  Creates a caption.

  ## Examples

      iex> create_caption(%{field: value})
      {:ok, %Caption{}}

      iex> create_caption(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_caption(attrs \\ %{}) do
    %Caption{}
    |> Caption.changeset(attrs)
    |> Repo.insert()
  end
end
