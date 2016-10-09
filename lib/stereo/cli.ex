defmodule Stereo.CLI do
  alias Stereo.Runner
  alias Stereo.Parser

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(:help) do
    IO.puts """
    Usage: stereo [-h | --help] [-d | --dry-run] <input>
    """
  end

  defp process({command, input_glob}) do
    Runner.run(command, input_glob)
      |> print_result
  end

  defp print_result({:error, reason}) do
    IO.puts "Error: #{reason}"
  end

  defp print_result(output_path) do
    IO.puts """
      Created #{Path.basename(output_path)}
      in #{Parser.pretty_dirname(output_path)}
    """
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
