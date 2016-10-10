defmodule Stereo.Movie do
  alias Stereo.Name
  alias Stereo.Parser
  alias Stereo.File

  def create(options, path) do
    pattern = Name.ffmpeg_pattern(path)
    output = output_path(options, path)
    run(options, pattern, output)
  end

  defp run(%{dry_run: true}, _, output), do: {:ok, output}
  defp run(%{dry_run: false}, pattern, output) do
    case System.cmd("ffmpeg", ["-i", pattern, output], stderr_to_stdout: true) do
      {_, 0} -> {:ok, output}
      error  -> {:error, error}
    end
  end

  defp output_path(options, path) do
    dir = Path.dirname(path)
    index = File.safe_ls(dir)
      |> Parser.frame_numbers(options.name)
      |> next_index
    Path.join(dir, "#{options.name}_#{index}.mov")
  end

  defp next_index([]), do: 1
  defp next_index(indices) do
    indices
      |> Enum.max
      |> Kernel.+(1)
  end
end
