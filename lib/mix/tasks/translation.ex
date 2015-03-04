defmodule Mix.Tasks.ChineseTranslation do
  use Mix.Task

  @shortdoc "get the latest version of the translation table and recompile myself"

  @moduledoc """
  
  """

  @url "http://svn.wikimedia.org/svnroot/mediawiki/trunk/phase3/includes/ZhConversion.php"
  @path1 "conversion.txt"
  @path2 "deps/chinese_translation/conversion.txt"
  @beam_path "_build/dev/lib/chinese_translation"

  def run(_args) do
    HTTPoison.start
    %HTTPoison.Response{body: body} = HTTPoison.get! @url
    File.rm_rf(@beam_path)
    write_file(body)
    System.cmd("mix", ["compile"])
  end

  def write_file(body) do
    case File.exists? @path2 do
      true -> @path2
      _    -> @path1
    end
    |> File.write(body)
  end
end
