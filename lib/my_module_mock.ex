defmodule MyModuleMock do
  use Agent

  def start_link() do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def expect(fun) do
    Agent.update(__MODULE__, fn _ -> fun end)
  end

  def content do
    Agent.get(__MODULE__, fn fun -> fun.() end)
  end
end
