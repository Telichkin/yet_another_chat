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
    put_change(changeset, :password, encrypt_password(password))
  end
  defp hash_password(changeset), do: changeset

  def find_name_by_login_and_password(login, password) when is_bitstring(login) and is_bitstring(password) do
    encrypted_password = encrypt_password(password)
    Repo.one(
      from u in User, 
      where: (u.name == ^login or
              fragment("lower(?)", u.email) == fragment("lower(?)", ^login)) and
              u.password == ^encrypted_password,
      select: u.name
    )
  end

  defp encrypt_password(raw_password) when is_bitstring(raw_password) do
    <<x::256-big-unsigned-integer>> = :crypto.hash(:sha256, @password_salt <> raw_password)
    to_string(:erlang.integer_to_list(x, 16))
  end
end
