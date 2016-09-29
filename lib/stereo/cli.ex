defmodule Stereo.CLI do
  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(input_dir) do
    output_dir = Path.join(input_dir, "output")
    unless File.exists?(output_dir) do
      File.mkdir!(output_dir)
    end
    copy_left_camera(input_dir, output_dir, "particle1")
    copy_right_camera(input_dir, output_dir, "particle1")
  end

  defp copy_left_camera(input_dir, output_dir, base_name, i \\ 1) do
    input_frame = frame_name(i)
    output_frame = frame_name(i * 2 - 1)
    input_file = "#{input_dir}/#{base_name}stereoCameraLeft_#{input_frame}.tif"
    output_file = "#{output_dir}/#{base_name}_#{output_frame}.tif"
    if File.exists?(input_file) do
      IO.puts "#{Path.basename(input_file)} -> #{Path.basename(output_file)}"
      File.cp!(input_file, output_file)
      copy_left_camera(input_dir, output_dir, base_name, i + 1)
    end
  end

  defp copy_right_camera(input_dir, output_dir, base_name, i \\ 1) do
    input_frame = frame_name(i)
    output_frame = frame_name(i * 2)
    input_file = "#{input_dir}/#{base_name}stereoCameraRight_#{input_frame}.tif"
    output_file = "#{output_dir}/#{base_name}_#{output_frame}.tif"
    if File.exists?(input_file) do
      IO.puts "#{Path.basename(input_file)} -> #{Path.basename(output_file)}"
      File.cp!(input_file, output_file)
      copy_right_camera(input_dir, output_dir, base_name, i + 1)
    end
  end

  defp frame_name(n) do
    n
    |> Integer.to_string
    |> String.pad_leading(4, "0")
  end

  defp parse_args(argv) do
    args = OptionParser.parse(argv, switches: [help: :boolean],
                                    aliases:  [h: :help])
    case args do
      { [help: true], _, _ } -> :help
      { _, [""], _ }         -> :help
      { _, [input_dir], _ }   -> Path.expand(input_dir)
    end
  end
end
