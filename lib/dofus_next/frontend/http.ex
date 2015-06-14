defmodule DofusNext.Frontend.HTTP do
  use Plug.Router

  alias DofusNext.Frontend.HTTP.Users

  plug :match
  plug Plug.Logger, log: :debug
  plug Plug.Static, at: "/static", from: :dofus_next
  plug :dispatch

  forward "/users", to: Users

  match _ do
    conn
    |> send_resp(404, "Not Found.")
  end
end
