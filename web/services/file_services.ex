defmodule GarescoServer.FileServices do
  alias GarescoServer.File, as: FileDB
  alias Plug.Upload

  def all(%{repo: repo}) do
    repo.all(FileDB)
  end

  def new_changeset() do
    FileDB.changeset(%FileDB{})
  end

  def add(%{"photo" => photo, "version" => version} = file_params, 
    %{repo: repo}) 
    when not is_nil(version) do

    params = photo
      |> Map.take([:filename, :content_type])
      |> Map.put(:version, version)

    result = %FileDB{}
      |> FileDB.changeset(params)
      |> repo.insert

    case result do
      {:ok, file} ->
        save_file(photo, file.file_id)
        _ -> 0
    end

    result
  end

  
  def add(params, _) do

    changeset = %FileDB{}
      |> FileDB.changeset(params)

    {:error_msg, changeset, "Version of photo missing"}
  end

  def get!(id, %{repo: repo}) do
    file = repo.get!(FileDB, id)
    IO.inspect(file)
    file
  end

  def delete!(id, %{repo: repo} = context) do
    file = get!(id, context)
    repo.delete!(file)

    files_path = Application.get_env(:garesco_server, :files_path)
    File.rm!("#{files_path}/#{id}")
  end


  def update(id, %{"photo" => photo, "version" => version}, context) do

    params = photo
      |> Map.take([:filename, :content_type])
      |> Map.put(:version, version)

    result = _update(id, params, context)

    if match? {_, {:ok, _}}, result do
        save_file(photo, id)
    end

    result
  end

  def update(id, %{"version" => version}, context) do
    params = %{version: version}
    _update(id, params, context)
  end

  defp _update(id, params, %{repo: repo} = context) do
    files_path = Application.get_env(:garesco_server, :files_path)
    file = get!(id, context)

    changeset = FileDB.changeset(file, params)
    result = repo.update(changeset)

    {file, result}
  end

  def save_file(photo, id) do
    files_path = Application.get_env(:garesco_server, :files_path)
    File.copy!(photo.path, "#{files_path}/#{id}")
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