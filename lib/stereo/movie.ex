defmodule Stereo.Movie do
  alias Stereo.Name
  alias Stereo.Parser

  def create(command, path) do
    pattern = Name.ffmpeg(path)
    output = output_path(path)
    run(command, pattern, output)
  end

  defp run(:dry_run, pattern, output) do
    IO.puts pattern
    IO.puts output
  end

  defp run(:run, pattern, output) do
    IO.puts "Creating #{output}"
    System.cmd("ffmpeg", ["-i", pattern, output], stderr_to_stdout: true)
  end

  defp output_path(path) do
    dir = Path.dirname(path)
    basename = "output"
    {_, existing_files} = File.ls(dir)
    existing_indices = existing_files
      |> Enum.filter(&String.contains?(&1, basename))
      |> Enum.map(&Parser.frame_number(&1))
    index = next_index(existing_indices)
    Path.join(dir, "#{basename}_#{index}.mov")
  end

  defp next_index([]), do: 1
  defp next_index(indices) do
    indices
      |> Enum.max
      |> Kernel.+(1)
  end
end
