defmodule Stereo.CLI do
  alias Stereo.{Parser, Runner}

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  defp process(:help) do
    IO.puts """
    Usage: stereo [-h | --help] [-d | --dry-run] [-n | --name] <input>
    """
  end

  defp process({options, input_glob}) do
    Runner.run(options, input_glob)
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
                                               d: :dry_run,
                                               n: :name])
    case args do
      { [help: true], _, _ }     -> :help
      { _, [""], _ }             -> :help
      { options, input_glob, _ } -> { struct(Stereo.Options, options), input_glob }
    end
  end
end
