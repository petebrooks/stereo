defmodule Stereo.Parser do
  def eye(path) do
    Regex.run(~r/stereoCamera\d?(Left|Right)/, path)
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
    basename_from_file(path) || basename_from_dir(path)
  end

  def basename_from_file(path) do
    with [_, name] <-
      Regex.run(~r/(.+)\Wstereo/, Path.basename(path)), do: name
  end

  def basename_from_dir(path) do
    path
      |> Path.split
      |> Enum.at(-2)
  end

  def padding_length(path) do
    Regex.run(~r/(\d+)\./, path)
      |> Enum.at(1)
      |> String.length
  end
end
