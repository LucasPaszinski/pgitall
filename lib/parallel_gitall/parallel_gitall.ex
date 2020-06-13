defmodule ParallelGitAll do
  @help __MODULE__.Help
  @git_finder __MODULE__.GitFinder
  @console_sup __MODULE__.ConsoleSupervisor
  @doc """
  Escript main function, this is what is call when executing via escript
  """
  def main(args) do
    {time, _result} = :timer.tc(ParallelGitAll, :start, parse_args(args))
    IO.puts("Finished in #{time / 1_000_000} seconds !!!")
  end

  @doc """
  parse the args and format then correctly
  """
  def parse_args(args) do
    case args do
      [] ->
        [".", "git status"]

      [arg1] ->
        case File.dir?(arg1) do
          true ->
            [arg1, "git status"]

          false ->
            [".", arg1]
        end

      [arg1, arg2] ->
        case [File.dir?(arg1), File.dir?(arg2)] do
          [true, false] ->
            [arg1, arg2]

          [false, true] ->
            [arg2, arg1]

          [_, _] ->
            @help.show()
        end
    end
  end

  @doc """
  start function
  """
  def start(path, command) do
    IO.puts("-> path: #{path}\n-> command: #{command}")

    case @help.is_help(path) or @help.is_help(command) do
      true ->
        @help.show()

      false ->
        @git_finder.find_git_subdirs(path)
        |> @console_sup.start_workers_wait_response(path, command)
    end
  end
end
