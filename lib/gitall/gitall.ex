defmodule GitAll do
  def main(args)  when length(args) == 0 do
    start(".","git status")
  end

  def main(args) when length(args) == 1 do
    start(".",args)
  end

  def main(args) when length(args) == 2 do
    [head | tail] = args
    start(tail,head)
  end

  def main(_args) do
    IO.puts "I Don't know what you're doing"
    IO.puts "The usage is 'gitall' for run at your current local path the command git status"
    IO.puts "Or 'gitall \"git command-line\"' to run the command on yout local path"
    IO.puts "And last 'gitall \"path\", \"git command-line\"' to run on specific path the command"
  end

  #implementar o a escolha do comando disparado para os repositórios
  defp start(path, command) do
    sub_dirs = get_git_sub_dirs(path)
    #dispatch messages
    for dir <- sub_dirs do
      me = self()
      spawn(fn ->
        exec_on = Path.join(path, dir)
        result = :os.cmd(to_charlist("cd #{exec_on} && bash.exe && #{command}"))
        send me, {:git, dir, result}
      end)
    end
    #receive then back
    for _dir <- sub_dirs do
      receive do
        {:git, header,text} ->
          IO.puts "\n #{String.capitalize(header)} \n"
          IO.puts inspect text
      end
    end
  end

  defp get_git_sub_dirs(path) do
    File.ls!(path)
    |> Enum.filter(&File.dir?(Path.join(path,&1)))
    |> Enum.filter(fn sub_dir ->
                    File.ls!(Path.join(path,sub_dir))
                    |> Enum.any?(&(&1 == ".git")) end)

  end

  defp get_returns(n, res_to, msgs \\ []) do
    if n > 0 do
      msgs
    end

    receive do
      {:msg, value} ->
        get_returns(n-1, res_to,  [msgs | value])
    end
  end
end
