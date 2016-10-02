defmodule Stereo.Name do
  alias Stereo.Parser

  def output_path(dir, path) do
    output_frame = frame_name(path)
    basename = Parser.basename(path)
    extension = Path.extname(path)
    Path.join(dir, "#{basename}_#{output_frame}#{extension}")
  end

  def output_dir(glob) do
    glob
      |> Path.dirname
      |> Path.join("output")
  end

  defp frame_name(path) do
    output_num(path)
      |> Integer.to_string
      |> String.pad_leading(4, "0")
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
