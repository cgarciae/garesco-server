defmodule GarescoServer.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :filename, :string
      add :content_type, :string
      add :version, :integer

      timestamps
    end

  end
end
