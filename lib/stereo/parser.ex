defmodule Stereo.Parser do
  def eye(path) do
    Regex.run(~r/stereoCamera(Left|Right)/, path)
      |> Enum.at(1)
  end

  def frame_number(path) do
    Regex.run(~r/_(\d+)\./, Path.basename(path))
      |> Enum.at(1)
      |> String.to_integer
  end

  def basename(path) do
    Regex.run(~r/(.+)\Wstereo/, Path.basename(path))
      |> Enum.at(1)
  end
end
