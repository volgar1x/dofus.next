import Kernel, except: [send: 2]

defmodule DofusNext.Frontend.Session do
  require Logger

  defstruct transport: nil, socket: nil, attrs: %{}, closed?: false

  alias __MODULE__, as: T

  def send(s, data) do
    Logger.debug "SND #{data}"
    s.transport.send(s.socket, << data :: binary, 0 :: utf8 >>)
    s
  end

  def close(s) do
    :ok = s.transport.close(s.socket)
    %T{s | closed?: true}
  end

  def send_close(s, data) do
    close(send(s, data))
  end

  def recv(s, timeout \\ 7200000) do
    s.transport.recv(s.socket, 0, timeout)
  end

  def get_attr(s, key) do
    s.attrs[key]
  end

  def put_attr(s, kw) do
    new_attrs = Enum.reduce(kw, s.attrs, fn {k, v}, acc -> Map.put(acc, k, v) end)
    %T{s | attrs: new_attrs}
  end

  def put_attr(s, key, val) do
    new_attrs = Map.put(s.attrs, key, val)
    %T{s | attrs: new_attrs}
  end

  def closed?(sess) do
    sess.closed?
  end
end
