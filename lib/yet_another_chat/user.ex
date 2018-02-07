defmodule YetAnotherChat.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias YetAnotherChat.Repo
  alias YetAnotherChat.User

  @password_salt Application.get_env(:yet_another_chat, :password_salt)

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  def create(user_data) do
    %User{}
    |> cast(user_data, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
    |> hash_password()
    |> Repo.insert()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end
  defp hash_password(changeset), do: changeset

  def find_name_by_login_and_password(login, password) when is_bitstring(login) and is_bitstring(password) do
    user =  Repo.one(from u in User, 
                     where: u.name == ^login or
                            fragment("lower(?)", u.email) == fragment("lower(?)", ^login))
    cond do
      user === nil -> nil
      Bcrypt.verify_pass(password, user.password) === true -> user.name
      true -> nil
    end
  end
end
