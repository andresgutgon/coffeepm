defmodule CoffeeWeb.Headers.App do
  use Gettext, backend: CoffeeWeb.Gettext
  use Phoenix.Component
  use CoffeeWeb, :verified_routes

  import CoffeeWeb.Headers.Base

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :bg_color, :string
  attr :current_user, :map, default: nil

  def render(assigns) do
    ~H"""
    <.base_header
      right_menu_items={build_menu_items(assigns)}
      flash={@flash}
      bg_color={assigns[:bg_color]}
    />
    """
  end

  defp build_menu_items(assigns) do
    [
      %{label: assigns[:current_user].email, font_weight: "bold"},
      %{label: "Settings", href: ~p"/account"},
      %{label: "Logout", href: ~p"/auth/users/log_out", method: "delete"}
    ]
  end
end
