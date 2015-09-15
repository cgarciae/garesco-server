defmodule GarescoServer.FileServices do
  alias GarescoServer.File, as: FileDB
  alias Plug.Upload

  def all(%{repo: repo}) do
    repo.all(FileDB)
  end

  def new_changeset() do
    FileDB.changeset(%FileDB{})
  end

  def add(%{"photo" => photo, "version" => version} = file_params, %{repo: repo}) do
    
    files_path = Application.get_env(:garesco_server, :files_path)
    
    params = photo
      |> Map.take(["filename", "content_type"])
      |> Map.put("version", version)

    result = %FileDB{}
      |> FileDB.changeset(params)
      |> repo.insert

    case result do
      {:ok, file} ->
        File.copy!(photo.path, "#{files_path}/#{file.id}")
    end

    result
  end

  def get!(id, %{repo: repo}) do
    repo.get!(FileDB, id)
  end

  def delete!(id, %{repo: repo} = context) do
    file = get!(id, context)
    repo.delete!(file)

    files_path = Application.get_env(:garesco_server, :files_path)
    File.rm!("#{files_path}/#{id}")
  end
  

  def update(id, file_params, %{repo: repo} = context) do
    file = get!(id, context)

    params = case file_params do
      %{"photo" => photo, "version" => version} ->
        photo
          |> Map.take(["filename", "content_type"])
          |> Map.put("version", version)
      %{"version" => version} ->
        {"version" => version}
    end

    changeset = FileDB.changeset(file, params))
    result = repo.update(changeset)

    {file, result}
  end
  
  def raw(conn, id, %{plug_conn: plug_conn} = context) do
    files_path = Application.get_env(:garesco_server, :files_path)
    file = get!(id, context)
    conn
     |> plug_conn.put_resp_content_type(file.content_type)
     |> plug_conn.put_resp_header("filename", file.filename)
     |> plug_conn.send_file(200, "#{files_path}/#{id}")
  end
  
end