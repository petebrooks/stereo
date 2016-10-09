defmodule StereoTest do
  use ExUnit.Case
  doctest Stereo

  import Stereo

  @fixtures Path.join(__DIR__, "fixtures/*.tif")
  @output_path Path.join(__DIR__, "fixtures/output")

  setup do
    on_exit fn ->
      File.rm_rf @output_path
    end
  end

  test "dry run with an array of paths" do
    paths = Path.expand(@fixtures)
    assert {:ok, _} = Stereo.Runner.run(:dry_run, paths)
  end

  test "dry run with a glob string" do
    assert {:ok, _} = Stereo.Runner.run(:dry_run, @fixtures)
  end

  test "run with an array of paths" do
    paths = Path.expand(@fixtures)
    assert {:ok, _} = Stereo.Runner.run(:run, paths)
  end

  test "run with a glob string" do
    assert {:ok, _} = Stereo.Runner.run(:run, @fixtures)
  end
end
