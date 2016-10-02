# Covert with ffmpeg -i particle1_%04d.tif output.mov

defmodule Stereo.CLI do
  alias Stereo.Name

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(:help) do
    IO.puts "help"
  end

  defp process({command, input_glob}) do
    output_dir = Name.output_dir(input_glob)
    find_or_create_dir!(command, output_dir)
    case copy_camera(command, output_dir, input_glob) do
      { :error, reason } -> IO.puts reason
      [path | _] -> IO.puts Name.ffmpeg(path)
    end
  end

  defp unglob(input_glob) do
    input_glob
      |> Path.expand
      |> Path.wildcard
  end

  defp copy_camera(_, _, []), do: []

  defp copy_camera(command, output_dir, input_glob) when is_bitstring(input_glob) do
    copy_camera(command, output_dir, unglob(input_glob))
  end

  defp copy_camera(command, output_dir, [input | tail]) do
    output = Name.output_path(output_dir, input)
    copy!(command, input, output)
    [output | copy_camera(command, output_dir, tail)]
  end

  defp find_or_create_dir!(:dry_run, _), do: :ok
  defp find_or_create_dir!(:run, dir) do
    File.exists?(dir) || File.mkdir!(dir)
  end

  defp copy!(:dry_run, _, _), do: :ok
  defp copy!(:run, source, destination) do
    File.cp!(source, destination)
  end

  defp parse_args(argv) do
    args = OptionParser.parse(argv, switches: [help: :boolean,
                                               dry_run: :boolean],
                                    aliases:  [h: :help,
                                               d: :dry_run])
    case args do
      { [help: true], _, _ }                -> :help
      { _, [""], _ }                        -> :help
      { [dry_run: true], [input_glob], _ }  -> { :dry_run, input_glob }
      { _, [input_glob], _ }                -> { :run,     input_glob }
    end
  end
end
