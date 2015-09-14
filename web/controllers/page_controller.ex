defmodule GarescoServer.PageController do
  use GarescoServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
