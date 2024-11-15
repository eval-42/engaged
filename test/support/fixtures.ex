defmodule Engaged.Fixtures do
  @moduledoc false

  def load_fixture(path) do
    complete_path = Path.join(["test", "support", "fixtures", path])
    File.read!(complete_path)
  end
end
