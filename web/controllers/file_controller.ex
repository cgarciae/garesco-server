defmodule GarescoServer.FileController do
  use GarescoServer.Web, :controller


  alias GarescoServer.File
  alias GarescoServer.FileServices

  plug :scrub_params, "file" when action in [:create, :update]

  def action(conn, _opts) do
    context = Application.get_env(:garesco_server, :di)
    apply(__MODULE__, action_name(conn), [conn, conn.params, context])
  end

  def index(conn, _params, %{file_services: file_services} = context) do
    files = file_services.all(context)
    render(conn, "index.html", files: files)
  end

  def new(conn, _params, %{file_services: file_services} = context) do
    changeset = file_services.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"file" => file}, %{file_services: file_services} = context) do

    case file_services.add(file, context) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "File created successfully.")
        |> redirect(to: file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, %{file_services: file_services} = context) do
    file = file_services.get!(id, context)
    render(conn, "show.html", file: file)
  end

  def edit(conn, %{"id" => id}, %{file_services: file_services} = context) do
    file = file_services.get!(id, context)
    changeset = File.changeset(file)
    render(conn, "edit.html", file: file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "file" => file_params}, %{file_services: file_services} = context) do

    case file_services.update(id, file_params, context) do
      {_, {:ok, file}} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: file_path(conn, :show, file))
      {file, {:error, changeset}} ->
        render(conn, "edit.html", file: file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, %{file_services: file_services} = context) do

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    file_services.delete!(id, context)

    conn
    |> put_flash(:info, "File deleted successfully.")
    |> redirect(to: file_path(conn, :index))
  end

  def raw(conn, %{"id" => id}, %{file_services: file_services} = context) do
    file_services.raw(conn, id, context)
  end
  
end
