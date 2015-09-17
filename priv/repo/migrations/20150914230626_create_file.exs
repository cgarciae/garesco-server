defmodule GarescoServer.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :file_id, :uuid, primary_key: true
      add :filename, :string
      add :content_type, :string
      add :version, :integer
      

      timestamps
    end

  end
end
