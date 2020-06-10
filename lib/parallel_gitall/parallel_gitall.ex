defmodule ParallelGitAll do
  @help __MODULE__.Help
  @git_finder __MODULE__.GitFinder
  @console_sup __MODULE__.ConsoleSupervisor
  @doc """
  Escript main function, this is what is call when executing via escript
  """
  def main(args) do
    {time, _result} = :timer.tc(ParallelGitAll, :start, [args])
    IO.puts("Finished in #{time / 1_000_000} seconds !!!")
  end

  @doc """
  start function
  """
  def start([path | command]) do
    case @help.is_help(path) or @help.is_help(command) do
      true ->
        @help.show()

      false ->
        @git_finder.find_git_in_subdirs(path)
        |> @console_sup.start_workers_wait_response(path, command)
    end
  end
end
