defmodule Stereo.Runner do
  alias Stereo.{File, Movie, Name}

  def run(_, []) do
    {:error, "No files"}
  end

  def run(options, [input_glob]) when is_bitstring(input_glob) do
    run(options, File.unglob(input_glob))
  end

  def run(options, input_files) do
    output_dir = Name.image_output_dir(Enum.at(input_files, 0))
    copy_camera(options, output_dir, input_files) |> handle_result(options)
  end

  defp copy_camera(_, _, []), do: []
  defp copy_camera(options, output_dir, [input | tail]) do
    output = Name.image_output_path(output_dir, input)
    File.copy!(options, input, output)
    [output | copy_camera(options, output_dir, tail)]
  end

  defp handle_result({:error, reason}, _), do: {:error, reason}
  defp handle_result([path | _], options), do: Movie.create(options, path)
end
