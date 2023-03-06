defmodule ProcessTutTest do
  use ExUnit.Case
  doctest ProcessTut

  test "greets the world" do
    assert ProcessTut.hello() == :world
  end
  test "test" do
    Process.sleep(Enum.random(1..1000))
    MyModuleMock.expect(fn -> "test" end)
    Process.sleep(Enum.random(1..1000))
    ProcessTut.Concurrency.action("test got: ")
  end
end
