defmodule YetAnotherChatWeb.AuthView do
    use YetAnotherChatWeb, :view

    def help_tag(errors, field) when is_list(errors) and is_atom(field) do
        case Keyword.fetch(errors, field) do
            {:ok, message} -> 
                content_tag(:span, humanize(field) <> " " <> translate_error(message), [class: "help-block"])
            :error -> html_escape("")    
        end
    end
  end
  