defmodule GitAll do
  @doc """
  Escript main function, this is what is call when executing via escript
  """
  def main(args) do
    {time, _result} = :timer.tc(GitAll, :start, [args])
    IO.puts("Finished in #{time / 1_000_000} seconds !!!")
  end

  @doc """
  start function
  """
  def start([head | tail]) do
    case GitAll.Help.is_help(head) or GitAll.Help.is_help(tail) do
      true ->
        GitAll.Help.show()

      false ->
        GitAll.start(head, tail)
    end
  end

  def start(path, command) do
    sub_dirs = GitAll.GitFinder.find_git_in_subdirs(path)
    GitAll.ConsoleSupervisor.start_workers_wait_response(sub_dirs, path, command)
  end

end
