# iex(10)> Task.start(fn ->
# ...(10)>  Process.sleep(5000)
# ...(10)>  IO.puts('hi there')
# ...(10)> 47
# ...(10)> end)
# {:ok, #PID<0.134.0>}
# hi there

defmodule ProcessTut.Playground do

  @spec heavy_lifting(atom) :: pid
  def heavy_lifting(arg) do
    {:ok, pid} = Task.start_link(fn -> do_heavy_lifting(arg) end)
    pid
  end

  @spec small_lifting(atom) :: :ok
  def small_lifting(arg) do
    return_address = self() # binds to the console process itself
    return_ref = make_ref()
    _  = Task.start(fn -> do_small_lifting(return_address, return_ref, arg) end)
    receive do {:hi, ^return_ref, result} -> result end
  end

  # result
  # iex(1)> ProcessTut.Playground.small_lifting(:foo)
  # heavy lifted foo
  # "done with foo"
  # iex(2)> send(self(),:trollface)
  # :trollface
  # iex(3)> ProcessTut.Playground.small_lifting(:foo)
  # :trollface
  # heavy lifted foo
  # iex(4)>

  # make_ref
  # iex(10)> send(self(), {:hi, make_ref(), "trollface"})
  # {:hi, #Reference<0.3633846744.849346562.117115>, "trollface"}
  # iex(11)> ProcessTut.Playground.small_lifting(:foo)
  # heavy lifted foo
  # "done with foo"
  # iex(12)> flush()
  # {:hi, #Reference<0.3633846744.849346562.117115>, "trollface"}
  # :ok
  # iex(13)>

  def large_lifting(arg) do
    future  = Task.async(fn -> do_large_lifting(arg) end)
    Task.await(future, :infinity)
  end

  # iex(13)> Task.async(fn ->
  # ...(13)>  Process.sleep(5000)
  # ...(13)>  IO.puts("hi mom")
  # ...(13)>  47
  # ...(13)> end)
  # %Task{
  #   mfa: {:erlang, :apply, 2},
  #   owner: #PID<0.159.0>,
  #   pid: #PID<0.223.0>,
  #   ref: #Reference<0.3633846744.849412097.118387>
  # }
  # hi mom
  # iex(14)> Task.await(v)
  # 47

  # iex(16)> Task.async(fn ->
  # ...(16)> Process.sleep(5000)
  # ...(16)> IO.puts("hi mom")
  # ...(16)> 47
  # ...(16)> end)
  # %Task{
  #   mfa: {:erlang, :apply, 2},
  #   owner: #PID<0.159.0>,
  #   pid: #PID<0.231.0>,
  #   ref: #Reference<0.3633846744.849412097.118438>
  # }
  # hi mom
  # iex(17)> flush()
  # {#Reference<0.3633846744.849412097.118438>, 47}
  # {:DOWN, #Reference<0.3633846744.849412097.118438>, :process, #PID<0.231.0>,
  # :normal}
  # :ok

  defp do_large_lifting(arg) do
    Process.sleep(5000)
    IO.puts("heavy lifted #{arg}")
    "done with #{arg}"
  end

  defp do_small_lifting(return_address, return_ref, arg) do
    # binds to the created process
    Process.sleep(5000)
    IO.puts("heavy lifted #{arg}")
    send(return_address, {:hi, return_ref, "done with #{arg}"})
  end

  # defp do_heavy_lifting(arg) do
  #   Process.sleep(5000)
  #   IO.puts("heavy lifted #{arg}")
  #   47
  # end

  defp do_heavy_lifting(arg) do
    parent = self()
    Task.start_link(fn ->
      Process.sleep(5000)
      IO.puts("downloaded the whole internet")
      send(parent, :done)
    end)
    Task.start_link(fn ->
      IO.puts("reported that we started downloading the internet")
    end)
    receive do :done -> IO.puts("done with task #{arg}") end
  end
end

# iex(8)> ProcessTut.Playground.heavy_lifting(:foo)
# #PID<0.282.0>
# iex(9)> Process.alive?(v)
# true
# heavy lifted foo
# iex(10)> Process.alive?(v(8))
# false
