defmodule Stereo.File do
  def find_or_create_dir!(%{dry_run: true}, _), do: :ok
  def find_or_create_dir!(%{dry_run: false}, dir) do
    File.exists?(dir) || File.mkdir!(dir)
  end

  def copy!(%{dry_run: true}, _, _), do: :ok
  def copy!(%{dry_run: false}, source, destination) do
    File.cp!(source, destination, fn _, _ -> false end)
  end

  def safe_ls(dir) do
    files = case File.ls(dir) do
      {:error, _} -> []
      {:ok, other} -> other
    end
    Enum.filter(files, &File.regular?/1)
  end

  def unglob(input_glob) do
    input_glob
      |> Path.expand
      |> Path.wildcard
  end
end
