defmodule CoffeeWeb.Auth.Helpers.AssignForm do
  import Phoenix.Component

  def assign_form(socket, source = %{}, opts) when is_map(source) do
    as = Keyword.fetch!(opts, :as)
    assign(socket, :form, to_form(source, as: as))
  end

  defmacro __using__(_opts) do
    quote do
      import CoffeeWeb.Auth.Helpers.AssignForm
    end
  end
end
