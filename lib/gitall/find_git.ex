defmodule GitAll.GitFinder do
  def find_git_in_subdirs(path) do
    File.ls!(path)
    |> Enum.filter(&File.dir?(Path.join(path, &1)))
    |> Enum.filter(&(is_subdir_git?(path,&1)))
  end

  defp is_subdir_git?(path,sub_dir) do
    File.ls!(Path.join(path, sub_dir))
    |> Enum.any?(&(&1 == ".git"))
  end
end
