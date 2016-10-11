defmodule Stereo.Runner do
  alias Stereo.{FileUtils, Movie, Name}

  def run(_, []) do
    {:error, "No files"}
  end

  def run(options, [input_glob]) when is_bitstring(input_glob) do
    run(options, FileUtils.unglob(input_glob))
  end

  def run(options, input_files) do
    output_dir = Name.image_output_dir(Enum.at(input_files, 0))
    FileUtils.find_or_create_dir!(options, output_dir)
    copy_camera(options, output_dir, input_files) |> handle_result(options)
  end

  defp copy_camera(_, _, []), do: []
  defp copy_camera(options, output_dir, [input | tail]) do
    output = Name.image_output_path(output_dir, input)
    FileUtils.copy!(options, input, output)
    [output | copy_camera(options, output_dir, tail)]
  end

  defp handle_result({:error, reason}, _), do: {:error, reason}
  defp handle_result([path | _], options) do
    output = Name.movie_output_path(options, path)
    Movie.create(options, path, output)
  end
end
