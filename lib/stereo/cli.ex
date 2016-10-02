# Covert with ffmpeg -i particle1_%04d.tif output.mov

defmodule Stereo.CLI do
  alias Stereo.Parser

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(:help) do
    IO.puts "help"
  end

  defp process({:run, input_glob}) do
    output_dir = output_dirname(input_glob)
    File.exists?(output_dir) || File.mkdir!(output_dir)
    copy_camera(:run, output_dir, unglob(input_glob))
  end

  defp process({:dry_run, input_glob}) do
    output_dir = output_dirname(input_glob)
    copy_camera(:dry_run, output_dir, unglob(input_glob))
  end

  defp unglob(input_glob) do
    input_glob
      |> Path.expand
      |> Path.wildcard
  end

  def output_dirname(input_glob) do
    input_glob
      |> Path.dirname
      |> Path.join("output")
  end

  defp copy_camera(_, _, []) do
    # noop
  end

  defp copy_camera(command, output_dir, [input | tail]) do
    output = output_path(output_dir, input)
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

  defp output_path(output_dir, filepath) do
    output_frame = frame_name(filepath)
    basename = Parser.basename(filepath)
    extension = Path.extname(filepath)
    Path.join(output_dir, "#{basename}_#{output_frame}#{extension}")
  end

  defp frame_name(filepath) do
    output_num(filepath)
      |> Integer.to_string
      |> String.pad_leading(4, "0")
  end

  defp output_num(filepath) do
    eye = Parser.eye(filepath)
    input_num = Parser.frame_number(filepath)
    case eye do
       "Left" -> input_num * 2 - 1
       "Right" -> input_num * 2
    end
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
