defmodule UI do
  @moduledoc false
  def component do
    quote do
      use Phoenix.Component

      import Tails, only: [classes: 1]
      import Logger, only: [debug: 1, info: 1, warn: 1, error: 1]

      alias Phoenix.LiveView.JS
    end
  end

  @doc """
  When used, dispatch to the appropriate macro.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      import UI.Atoms.Alert
      import UI.Atoms.Icon
      import UI.Atoms.Text
      import UI.Atoms.Form
      import UI.Atoms.Label
      import UI.Atoms.FormField
      import UI.Atoms.Input
    end
  end
end
