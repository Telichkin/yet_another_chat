defmodule YetAnotherChat.Helpers do
    defmacro template_path_for(namespace: namespace) do
        quote do
            Path.join(Phoenix.Template.module_to_template_root(__MODULE__, unquote(namespace), "View"), "templates")
        end
    end
end