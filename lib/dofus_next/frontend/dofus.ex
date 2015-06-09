defmodule DofusNext.Frontend.Dofus do
  require Logger
  @behaviour :ranch_protocol

  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Main

  def start_link(ref, socket, transport, proto_opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, proto_opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _proto_opts) do
    :random.seed(:erlang.now())

    :ok = :ranch.accept_ack(ref)
    
    %Session{transport: transport, socket: socket}
      |> Main.connect
      |> loop
  end

  defp loop(%Session{closed?: true}) do
    nil
  end

  defp loop(sess) do
    case Session.recv(sess) do
      {:ok, packet} ->
        String.split(packet, <<10, 0>>, trim: true)
          |> handle_all(sess)
          |> loop

      {:error, :closed} ->
        Session.close(sess) |> loop

      {:error, err} ->
        Logger.warn "unknown transport error #{err}"
    end
  end

  defp handle_all([], sess) do
    sess
  end

  defp handle_all([msg | rest], sess) do
    if Session.closed?(sess) do
      sess
    else
      handle_all(rest, handle(sess, msg))
    end
  end

  defp handle(sess, msg) do
    log_msg = String.replace(msg, <<10>>, "<CR>")
    Logger.debug "RCV #{log_msg}"
    Main.handle(sess, msg)
  end
end
