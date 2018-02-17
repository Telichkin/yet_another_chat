defmodule Web.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "public_channel:*", Web.PublicChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    two_weeks_in_seconds = 1209600
    salt = Application.get_env(:yet_another_chat, Web.Endpoint)[:secret_key_base]
    case Phoenix.Token.verify(socket, salt, token, max_age: two_weeks_in_seconds) do
      {:ok, user_name} ->
        {:ok, assign(socket, :user, user_name)}
      {:error, _reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
