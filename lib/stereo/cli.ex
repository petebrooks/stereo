# Covert with ffmpeg -i particle1_%04d.tif output.mov
defmodule Stereo.CLI do
  alias Stereo.Runner

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(:help) do
    IO.puts "help"
  end

  defp process({command, input_glob}) do
    case Runner.run(command, input_glob) do
      { :error, reason } -> IO.puts reason
      _ -> IO.puts "ok"
    end
  end

  defp parse_args(argv) do
    args = OptionParser.parse(argv, switches: [help: :boolean,
                                               dry_run: :boolean],
                                    aliases:  [h: :help,
                                               d: :dry_run])
    case args do
      { [help: true], _, _ }             -> :help
      { _, [""], _ }                     -> :help
      { [dry_run: true], input_glob, _ } -> { :dry_run, input_glob }
      { _, input_glob, _ }               -> { :run,     input_glob }
    end
  end
end
