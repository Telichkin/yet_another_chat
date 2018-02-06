defmodule YetAnotherChat.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias YetAnotherChat.Repo
  alias YetAnotherChat.User

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  def create(user_data) do
    %User{}
    |> User.changeset(user_data)
    |> Repo.insert()
  end

  def find_name_by_login(login) when is_bitstring(login) do
    query = (from u in User, 
             where: u.name == ^login or
                    fragment("lower(?)", u.email) == fragment("lower(?)", ^login),
             select: u.name)

    case Repo.one(query) do
      nil -> :error
      name -> {:ok, name}
    end
  end

  def changeset(%User{} = user, user_data) do
    user
    |> cast(user_data, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
  end
end
