defmodule ConsoleLogger do
  def print(header,text) do
    IO.puts format(header, text)
  end
  defp format(header,text) do
    # Do not fix the spacings and lines they are correct
    String.replace(
      " -------------------------------------------------------------------------------
\t#{String.upcase(header)}:
-------------------------------------------------------------------------------

#{to_string(text)}",
      ~r/\n/,
      "\n\r "
    )
  end
end
