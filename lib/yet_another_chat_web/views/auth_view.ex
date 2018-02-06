defmodule YetAnotherChatWeb.AuthView do
    use YetAnotherChatWeb, :view

    def errors_to_error_messages(errors) do
        messages = Enum.reduce(errors, [], fn(error, error_messages) -> 
           error_subject = error |> elem(0) |> Atom.to_string() |> String.capitalize()
           error_reason = error |> elem(1) |> elem(0)
           [Enum.join([error_subject, error_reason], " ") | error_messages]
        end)
        Enum.reverse(messages)
    end
  end
  