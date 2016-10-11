defmodule Stereo.Name do
  alias Stereo.Parser
  alias Stereo.FileUtils

  def image_output_path(dir, path) do
    basename = Parser.basename(path)
    output_frame = frame_name(path)
    extension = Path.extname(path)
    Path.join(dir, "#{basename}_#{output_frame}#{extension}")
  end

  def ffmpeg_pattern(path) do
    count = Parser.padding_length(path)
    String.replace(path, ~r/\d+(\..)/, "%0#{count}d\\1")
  end

  def image_output_dir(glob) do
    glob
      |> Path.expand
      |> Path.dirname
      |> Path.join("output")
  end

  def movie_output_path(options, path) do
    dir = Path.dirname(path)
    index = FileUtils.safe_ls(dir)
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

  defp frame_name(path) do
    count = Parser.padding_length(path)
    output_num(path)
      |> Integer.to_string
      |> String.pad_leading(count, "0")
  end

  defp output_num(path) do
    eye = Parser.eye(path)
    input_num = Parser.frame_number(path)
    case eye do
       "Left" -> input_num * 2 - 1
       "Right" -> input_num * 2
    end
  end
end
