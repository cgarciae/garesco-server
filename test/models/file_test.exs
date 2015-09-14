defmodule GarescoServer.FileTest do
  use GarescoServer.ModelCase

  alias GarescoServer.File

  @valid_attrs %{content_type: "some content", filename: "some content", version: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
