defmodule GitAll do
  def main(args) do
    IO.puts("passing in main")
    {time, _result} = :timer.tc(GitAll, :start, [args])
    IO.puts "Finished in #{time/1_000_000}seconds 🎉🎉🎉"
  end

  def start(args) when length(args) == 0 do
    IO.puts("passing in start list 0")
    GitAll.start(".", "git status")
  end

  def start(args) when length(args) == 1 do
    IO.puts("passing in start list 1")

    case File.dir?(args) do
      true ->
        GitAll.start(args, "git status")

      false ->
        GitAll.start(".", args)
    end
  end

  def start([head | tail]) when not is_list(tail) do
    IO.puts("passing in start list 2")

    case File.dir?(head) do
      true ->
        GitAll.start(head, tail)

      false ->
        case File.dir?(tail) do
          true ->
            GitAll.start(tail, head)

          _ ->
            GitAll.start([head | tail])
        end
    end
  end

  def start(args) do
    IO.puts("passing in start list none")

    IO.puts(
      IO.ANSI.red() <>
        " I didn't understand '#{inspect(args)}'" <> IO.ANSI.green() <> "
  The correct usage is:
    pgitall path(optional) command(optional)

  Examples:
    pgitall \".\" \"git pull --rebase\"

    pgitall \"git reset --hard\" ..

    pgitall ..

    pgitall \"git log\""
    )
  end

  def start(path, command) do
    IO.puts("passing in start 2 params")
    sub_dirs = GitAll.GitFinder.find_git_in_subdirs(path)
    GitAll.ConsoleSupervisor.start_workers_wait_response(sub_dirs, path, command)
  end
end
