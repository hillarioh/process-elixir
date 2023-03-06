defmodule ProcessTut.Concurrency do

  if Mix.env == :test do
    @module MyModuleMock
  else
    @module MyModule
  end

  def action(str) do
    IO.puts(str <> @module.content())
  end
end

defmodule MyModule do
  def content, do: "unmocked"

end
