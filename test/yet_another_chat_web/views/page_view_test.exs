defmodule YetAnotherChatWeb.PageViewTest do
    use YetAnotherChatWeb.ConnCase, async: true
    alias YetAnotherChatWeb.PageView

    import Phoenix.View

    setup do
        {:ok, %{now: DateTime.utc_now()}}
    end

    test "render today message if self is author", %{now: now} do
        {:ok, fixed_time, _} = DateTime.from_iso8601("#{now.year}-0#{now.month}-#{now.day} 10:00:02Z")
        fixed_time = DateTime.to_iso8601(fixed_time)
        message = %{"text" => "Hello", "author" => "A", "time" => fixed_time, "recipient" => "A"}

        rendered_string = render_to_string(PageView, "messages.html", %{messages: [message]})

        assert rendered_string =~ "<span class=\"message-author\">A</span>"
        assert rendered_string =~ "<span class=\"message-date\">#{fixed_time}</span>"
        assert rendered_string =~ "Hello"
        assert rendered_string =~ "my-message"
    end

    test "render message if self is not author", %{now: now} do
        message = %{"text" => "Hello", "author" => "A", "time" => now, "recipient" => "B"}

        rendered_string = render_to_string(PageView, "messages.html", %{messages: [message]})

        refute rendered_string =~ "my-message"
    end
end