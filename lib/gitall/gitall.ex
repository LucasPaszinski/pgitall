defmodule GitAll do
  #implementar o a escolha do comando disparado para os repositórios
  def start(path, command) do
    sub_dirs = get_git_sub_dirs(path)
    #dispatch messages
    for dir <- sub_dirs do
      me = self()
      spawn(fn ->
        exec_on = Path.join(path, dir)
        result = :os.cmd(to_charlist("cd #{exec_on} && #{command}"))
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

  def get_git_sub_dirs(path) do
    File.ls!(path)
    |> Enum.filter(&File.dir?(Path.join(path,&1)))
    |> Enum.filter(fn sub_dir ->
                    File.ls!(Path.join(path,sub_dir))
                    |> Enum.any?(&(&1 == ".git")) end)

  end

  def get_returns(n, res_to, msgs \\ []) do
    if n > 0 do
      msgs
    end

    receive do
      {:msg, value} ->
        get_returns(n-1, res_to,  [msgs | value])
    end
  end
end
