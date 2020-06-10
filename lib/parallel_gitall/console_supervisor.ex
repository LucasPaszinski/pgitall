defmodule ParallelGitAll.ConsoleSupervisor do
  def start_workers_wait_response([], _, _) do
    ParallelGitAll.Help.show()
  end

  def start_workers_wait_response(sub_dirs, root_dir, command) do
    msg_joiner = self()
    spawn_workers(sub_dirs, root_dir, command, msg_joiner)
    wait_workers_response(length(sub_dirs))
  end

  defp spawn_workers(sub_dirs, root_dir, command, msg_joiner) do
    for dir <- sub_dirs do
      spawn(ParallelGitAll.ConsoleWorker, :console_worker, [dir, root_dir, command, msg_joiner])
      :timer.sleep(80)
    end
  end

  defp wait_workers_response(msgs_remaining) when msgs_remaining > 0 do
    receive do
      {:git, header, text} ->
        IO.puts(msg_formatter(header, text))
    end

    wait_workers_response(msgs_remaining - 1)
  end

  defp wait_workers_response(0) do
    0
  end

  defp msg_formatter(header, text) do
    # Do not fix the spacings and lines they are correct
    String.replace(
      " +-----------------------------------------------------------------------------------+
\t#{String.upcase(header)}:
+-----------------------------------------------------------------------------------+

#{to_string(text)}",
      ~r/\n/,
      "\n\r "
    )
  end
end
