defmodule GarescoServer.File do
  use GarescoServer.Web, :model

  schema "files" do
    field :filename, :string
    field :content_type, :string
    field :version, :integer

    timestamps
  end

  @required_fields ~w(version)
  @optional_fields ~w(filename content_type)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
