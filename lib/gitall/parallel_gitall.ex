defmodule ParallelGitAll do
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
  def start([head | tail]) do
    case ParallelGitAll.Help.is_help(head) or ParallelGitAll.Help.is_help(tail) do
      true ->
        ParallelGitAll.Help.show()

      false ->
        ParallelGitAll.start(head, tail)
    end
  end

  def start(_) do
    ParallelGitAll.Help.show()
  end

  def start(path, command) do
    sub_dirs = ParallelGitAll.GitFinder.find_git_in_subdirs(path)
    ParallelGitAll.ConsoleSupervisor.start_workers_wait_response(sub_dirs, path, command)
  end
end
