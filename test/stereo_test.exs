defmodule StereoTest do
  use ExUnit.Case
  doctest Stereo

  import Stereo

  @fixtures Path.join(__DIR__, "fixtures/*.tif")
  @output_dir Path.join(__DIR__, "fixtures/output")
  @output_file Path.join(@output_dir, "output_1.mov")

  setup do
    on_exit fn ->
      File.rm_rf @output_dir
    end
  end

  describe "Stereo.Runner.run/2" do
    test "dry run with an array of paths" do
      paths = Path.expand(@fixtures)
      assert {:ok, _} = Stereo.Runner.run(:dry_run, paths)
      refute File.exists?(@output_file)
    end

    test "dry run with a glob string" do
      assert {:ok, _} = Stereo.Runner.run(:dry_run, @fixtures)
      refute File.exists?(@output_file)
    end

    test "dry run with no files" do
      assert {:error, "No files"} = Stereo.Runner.run(:dry_run, [])
      refute File.exists?(@output_file)
    end

    test "run with an array of paths" do
      paths = Path.expand(@fixtures)
      assert {:ok, _} = Stereo.Runner.run(:run, paths)
      assert File.exists?(@output_file)
    end

    test "run with a glob string" do
      assert {:ok, _} = Stereo.Runner.run(:run, @fixtures)
      assert File.exists?(@output_file)
    end

    test "run with no files" do
      assert {:error, "No files"} = Stereo.Runner.run(:run, [])
      refute File.exists?(@output_file)
    end
  end
end
