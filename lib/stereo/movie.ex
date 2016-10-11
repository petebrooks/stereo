defmodule Stereo.Movie do
  alias Stereo.Name

  def create(%{dry_run: true}, _, output_path), do: {:ok, output_path}
  def create(%{dry_run: false}, input_path, output_path) do
    args = ["-i", Name.ffmpeg_pattern(input_path), output_path]
    case System.cmd("ffmpeg", args, stderr_to_stdout: true) do
      {_, 0} -> {:ok, output_path}
      error  -> {:error, error}
    end
  end
end
