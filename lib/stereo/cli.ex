# Covert with ffmpeg -i particle1_%04d.tif output.mov

defmodule Stereo.CLI do
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
    unless File.exists?(output_dir) do
      File.mkdir!(output_dir)
    end
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

  defp copy_camera(:run, output_dir, [input | tail]) do
    output = output_path(output_dir, input)
    IO.puts "#{Path.basename(input)} -> #{Path.basename(output)}"
    File.cp(input, output)
    copy_camera(:run, output_dir, tail)
  end

  defp copy_camera(:dry_run, output_dir, [input | tail]) do
    output = output_path(output_dir, input)
    IO.puts "#{Path.basename(input)} -> #{Path.basename(output)}"
    copy_camera(:dry_run, output_dir, tail)
  end

  defp output_path(output_dir, filepath) do
    [_, eye] = Regex.run(~r/stereoCamera(Left|Right)/, filepath)
    input_number = Regex.run(~r/_(\d+)\./, Path.basename(filepath))
      |> fn [_, n] -> String.to_integer(n) end.()
    output_number = case eye do
       "Left" -> input_number * 2 - 1
       "Right" -> input_number * 2
    end
    output_frame = frame_name(output_number)
    [_, basename] = Regex.run(~r/(.+)\Wstereo/, Path.basename(filepath))
    extension = Path.extname(filepath)
    Path.join(output_dir, "#{basename}_#{output_frame}#{extension}")
  end

  defp frame_name(n) do
    n
    |> Integer.to_string
    |> String.pad_leading(4, "0")
  end

  defp parse_args(argv) do
    args = OptionParser.parse(argv, switches: [help: :boolean,
                                               dry_run: :boolean],
                                    aliases:  [h: :help,
                                               d: :dry_run])
    case args do
      { [help: true], _, _ }                -> :help
      { _, [""], _ }                        -> :help
      { [dry_run: true], [input_glob], _ } -> { :dry_run, input_glob }
      { _, [input_glob], _ }               -> { :run, input_glob }
    end
  end
end
