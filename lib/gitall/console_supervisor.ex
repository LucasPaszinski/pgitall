defmodule GitAll.ConsoleSupervisor do
  def start_workers_wait_response(sub_dirs, root_dir, command) do
    msg_joiner = self()
    spawn_workers(sub_dirs, root_dir, command, msg_joiner)
    console_joiner(length(sub_dirs))
  end

  defp spawn_workers(sub_dirs, root_dir, command, msg_joiner) do
    for dir <- sub_dirs do
      spawn(GitAll.ConsoleWorker, :console_worker, [dir, root_dir, command, msg_joiner])
    end
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
end
