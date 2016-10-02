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
    case copy_camera(command, output_dir, unglob(input_glob)) do
      { :ok, output_dir } -> IO.puts output_dir
      { :error, error } -> IO.puts error
    end
  end

  defp find_or_create_dir!(:run, dir) do
    File.exists?(dir) || File.mkdir!(dir)
  end

  defp find_or_create_dir!(:dry_run, _), do: :ok

  defp unglob(input_glob) do
    input_glob
      |> Path.expand
      |> Path.wildcard
  end

  defp copy_camera(_, output_dir, []), do: { :ok, output_dir }

  defp copy_camera(command, output_dir, input_glob) do
    copy_camera(command, output_dir, unglob(input_glob))
  end

  defp copy_camera(command, output_dir, [input | tail]) do
    output = Name.output_path(output_dir, input)
    copy!(command, input, output)
    copy_camera(command, output_dir, tail)
  end

  defp copy!(:dry_run, source, destination) do
    IO.puts "#{Path.basename(source)} -> #{Path.basename(destination)}"
  end

  defp copy!(:run, source, destination) do
    IO.puts "#{Path.basename(source)} -> #{Path.basename(destination)}"
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
