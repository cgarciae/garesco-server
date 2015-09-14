defmodule GarescoServer.FileServices do

  alias GarescoServer.File

  def all(%{repo: repo}) do
    repo.all(File)
  end
  
end