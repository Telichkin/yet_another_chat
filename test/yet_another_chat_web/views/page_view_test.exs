defmodule YetAnotherChatWeb.PageViewTest do
    use YetAnotherChatWeb.ConnCase, async: true
    alias YetAnotherChatWeb.PageView

    import Phoenix.View

    setup do
        {:ok, %{now: DateTime.utc_now()}}
    end

    test "render today message", %{now: now} do
        {:ok, fixed_time, _} = DateTime.from_iso8601("#{now.year}-0#{now.month}-#{now.day} 10:00:02Z")
        fixed_time = DateTime.to_iso8601(fixed_time)
        message = %{"text" => "Hello", "author" => "A", "time" => fixed_time}

        rendered_string = render_to_string(PageView, "message.html", %{message: message})

        assert rendered_string =~ "<span class=\"message-author\">A</span>"
        assert rendered_string =~ "<span class=\"message-date\">10:00</span>"
        assert rendered_string =~ "Hello"
    end
end