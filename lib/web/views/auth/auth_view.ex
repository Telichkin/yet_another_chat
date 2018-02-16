defmodule Web.AuthView do
    use Web, :view

    def help_tag(errors, field) when is_list(errors) and is_atom(field) do
        case Keyword.fetch(errors, field) do
            {:ok, message} -> 
                error_message = humanize(field) <> " " <> translate_error(message)
                content_tag(:span, error_message, [class: "alert alert-error"])
            :error -> 
                html_escape("")    
        end
    end
  end
  