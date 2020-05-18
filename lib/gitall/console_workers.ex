defmodule GitAll.ConsoleWorker do
  def console_worker(dir, root_dir, command, msg_joiner) do
    exec_on = Path.join(root_dir, dir)
    result = :os.cmd(to_charlist("cd #{exec_on} && #{command}"))
    send(msg_joiner, {:git, dir, result})
  end
end
