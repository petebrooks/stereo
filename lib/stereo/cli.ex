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
    Runner.run(command, input_glob)
      |> log_result
  end

  defp log_result({:error, reason}) do
    IO.puts "Error: #{reason}"
  end

  defp log_result(output_path) do
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
