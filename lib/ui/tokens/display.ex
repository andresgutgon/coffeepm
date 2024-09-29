defmodule UI.Tokens.Display do
  @type display :: :block | :inline | :inline_block

  @spec properties() :: map
  def properties do
    %{
      block: "block",
      inline: "inline",
      inline_block: "inline-block"
    }
  end

  @spec display(String.t()) :: String.t()
  def display(key) when is_binary(key) do
    atom_key = String.to_existing_atom(key)
    display(atom_key)
  rescue
    ArgumentError -> raise "Invalid display key: #{key}"
  end

  @spec display(Atom.t()) :: String.t()
  def display(key) do
    properties()[key]
  end
end
