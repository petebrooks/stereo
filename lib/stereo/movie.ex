defmodule Stereo.Movie do
  alias Stereo.Name
  alias Stereo.Parser
  alias Stereo.File

  def create(command, path) do
    pattern = Name.ffmpeg_pattern(path)
    output = output_path(path)
    log_output_path(output)
    run(command, pattern, output)
  end

  defp run(:dry_run, _, output) do
    IO.puts "DRY RUN"
    :ok
  end

  defp run(:run, pattern, output) do
    case System.cmd("ffmpeg", ["-i", pattern, output], stderr_to_stdout: true) do
      {_, 0} -> :ok
      error -> {:error, error}
    end
  end

  defp log_output_path(path) do
    IO.puts "Creating #{Path.basename(path)}"
    IO.puts "in #{Parser.pretty_dirname(path)}"
  end

  defp output_path(path) do
    dir = Path.dirname(path)
    basename = "output"
    existing_files = File.safe_ls(dir)
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
