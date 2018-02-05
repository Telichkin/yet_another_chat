defmodule YetAnotherChatWeb.UsersView do
    use YetAnotherChatWeb, :view
    @error_messages %{
        "name" => "Name can't be blank",
        "email" => "Email can't be blank",
        "password" => "Password can't be blank"
    }

    def empty_fields_to_error_messages(empty_fields) do
        Enum.map(empty_fields, fn(field) -> @error_messages[field] end)
    end
  end
  