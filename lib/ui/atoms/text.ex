defmodule UI.Atoms.Text do
  use UI, :component

  require UI.Atoms.Helpers.TextMacro

  UI.Atoms.Helpers.TextMacro.generate_sizes_macro()
end
