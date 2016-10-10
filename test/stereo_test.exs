defmodule StereoTest do
  use ExUnit.Case
  doctest Stereo

  import Stereo
  alias Stereo.{Runner, Options}

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
      assert {:ok, _} = Runner.run(%Options{dry_run: true}, paths)
      refute File.exists?(@output_file)
    end

    test "dry run with a glob string" do
      assert {:ok, _} = Runner.run(%Options{dry_run: true}, @fixtures)
      refute File.exists?(@output_file)
    end

    test "dry run with no files" do
      assert {:error, "No files"} = Runner.run(%Options{dry_run: true}, [])
      refute File.exists?(@output_file)
    end

    test "run with an array of paths" do
      paths = Path.expand(@fixtures)
      assert {:ok, _} = Runner.run(%Options{}, paths)
      assert File.exists?(@output_file)
    end

    test "run with a glob string" do
      assert {:ok, _} = Runner.run(%Options{}, @fixtures)
      assert File.exists?(@output_file)
    end

    test "run with no files" do
      assert {:error, "No files"} = Runner.run(%Options{}, [])
      refute File.exists?(@output_file)
    end

    test "run with custom output name" do
      assert {:ok, _} = Runner.run(%Options{name: "george"}, @fixtures)
      assert Path.join(@output_dir, "george_1.mov") |> File.exists?
    end
  end
end
