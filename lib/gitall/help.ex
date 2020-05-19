defmodule GitAll.Help do
  def is_help(arg) do
    help_flags = ["--help", "-help", "--h", "-h"]

    Enum.any?(
      help_flags,
      fn help_flag ->
        help_flag == to_string(arg)
      end
    )
  end

  def show do
    IO.puts("
pgitall - parallel gitall:

Given a folder and an git command, execute the command in all sub-folder that are a git repository.

The usage is:

$ pgitall path(optional) command(optional)

  Examples of use are:

  $ pgitall \".\" \"git pull --rebase\"

  $ pgitall \"git reset --hard\" ..

  $ pgitall ..

  $ pgitall \"git log\"")
  end
end
