defmodule Engaged.Fixtures do
  @moduledoc false

  def load_fixture(path, opts \\ []) do
    binary = Keyword.get(opts, :binary, false)
    complete_path = Path.join(["test", "support", "fixtures", path])

    fixture_content = File.read!(complete_path)

    if binary, do: encode_binary(fixture_content), else: fixture_content
  end

  defp encode_binary(content) do
    <<0xFF, 0xFE>> <> :unicode.characters_to_binary(content, :utf8, {:utf16, :little})
  end
end
