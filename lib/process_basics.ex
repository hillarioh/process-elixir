# result = receive do
#   {:message_type, value} ->
#     # code
# end

# after
# iex(1)> send(self(), :bar)
# :bar
# iex(2)> send(self(), :foo)
# :foo
# iex(3)> receive do
# ...(3)>  :foo -> "got foo"
# ...(3)>  after 5000 -> "timed out"
# ...(3)> end
# "got foo"
# iex(4)> receive do
# ...(4)>  :foo -> "got foo"
# ...(4)>  after 5000 -> "timed out"
# ...(4)> end
# "timed out"

# Process Dictionary
# iex(6)> Process.put(:foo, :bar)
# nil
# iex(7)> Process.get(:foo)
# :bar
# iex(8)> Process.put("hello", "world")
# nil
# iex(9)> Process.get("hello")
# "world"

# iex(2)> spawn(fn ->
# ...(2)> Process.sleep(5000)
# ...(2)> IO.puts("hello")
# ...(2)> send(console, 47)
# ...(2)> end)
#PID<0.114.0>
# hello
# iex(3)>
# nil
# iex(4)> receive do
# ...(4)>  result -> result
# ...(4)> end
# 47
# iex(5)>
# nil
# iex(6)>

# iex(6)> spawn(fn ->
# ...(6)>  receive do
# ...(6)>   message -> IO.inspect(message)
# ...(6)> end
# ...(6)> end)
# #PID<0.125.0>
# iex(7)> Process.alive? v
# true
# iex(8)> send(v(6),:foo)
# :foo
# :foo
# iex(9)> Process.alive? v(6)
# false
# iex(10)>
