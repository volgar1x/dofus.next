defmodule DofusNext.Frontend.HTTP.Users do
  require Logger
  use Plug.Router
  alias DofusNext.Repo
  alias DofusNext.User
  alias DofusNext.Frontend.HTTP.UserParser

  plug :match
  plug Plug.Parsers, parsers: [UserParser], pass: ["application/json"]
  plug :dispatch

  post "/" do
    user = conn.params["user"]
    |> User.encode_pass

    conn
    |> put_status(:ok)
    |> send_resp
  end

  match _ do
    conn
    |> send_resp(404, "Not Found.")
  end

end
