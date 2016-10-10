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

  def frame_numbers(paths) do
    Enum.map(paths, &frame_number/1)
  end

  def frame_numbers(paths, filter_name) do
    paths
      |> Enum.filter(&String.contains?(&1, filter_name))
      |> frame_numbers
  end

  def basename(path) do
    from_file = Regex.run(~r/(.+)\Wstereo/, Path.basename(path))
    if from_file do
      Enum.at(from_file, 1)
    else
      path
        |> Path.split
        |> Enum.at(-2)
    end
  end

  def pretty_dirname(path) do
    path
      |> Path.dirname
      |> String.replace(Path.expand("~"), "~")
  end

  def padding_length(path) do
    Regex.run(~r/(\d+)\./, path)
      |> Enum.at(1)
      |> String.length
  end
end
