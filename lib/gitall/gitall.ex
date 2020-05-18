defmodule GitAll do
  def main(args) do
    IO.puts("passing in main")
    {time, _result} = :timer.tc(GitAll, :start, [args])
    IO.puts "Finished in #{time/1_000_000}seconds!!"
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
    sub_dirs = get_git_sub_dirs(path)
    me = self()
    spawn_console_worker(sub_dirs, path, command, me)
    console_joiner(length(sub_dirs))
  end

  defp get_git_sub_dirs(path) do
    File.ls!(path)
    |> Enum.filter(&File.dir?(Path.join(path, &1)))
    |> Enum.filter(fn sub_dir ->
      File.ls!(Path.join(path, sub_dir))
      |> Enum.any?(&(&1 == ".git"))
    end)
  end

  defp console_joiner(msgs_remaining) when msgs_remaining > 0 do
    receive do
      {:git, header, text} ->
        IO.puts(msg_formatter(header, text))
    end

    console_joiner(msgs_remaining - 1)
  end

  defp console_joiner(0) do
    0
  end

  defp msg_formatter(header, text) do
    # Do not fix the spacings and lines they are correct
    String.replace(
      " -----------------------------------------------------------------------------------
\t#{String.upcase(header)}:
-----------------------------------------------------------------------------------

#{to_string(text)}",
      ~r/\n/,
      "\n\r "
    )
  end

  defp spawn_console_worker(sub_dirs, root_dir, command, msg_joiner) do
    for dir <- sub_dirs do
      spawn(fn -> console_worker(dir, root_dir, command, msg_joiner) end)
    end
  end

  defp console_worker(dir, root_dir, command, msg_joiner) do
    exec_on = Path.join(root_dir, dir)
    result = :os.cmd(to_charlist("cd #{exec_on} && #{command}"))
    send(msg_joiner, {:git, dir, result})
  end
end
