defmodule YetAnotherChatWeb.PageView do
  use YetAnotherChatWeb, :view

  def humanize_time(iso_time_string) do
    {:ok, date, _} = DateTime.from_iso8601(iso_time_string)
    "#{add_zero_to_front(date.hour)}:#{add_zero_to_front(date.minute)}"
  end

  defp add_zero_to_front(number) when number < 10, do: "0#{number}"
  defp add_zero_to_front(number) when number >= 10, do: "#{number}"
end
