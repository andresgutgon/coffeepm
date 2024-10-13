defmodule CoffeeWeb.Headers.Base do
  use Gettext, backend: CoffeeWeb.Gettext
  use CoffeeWeb, :verified_routes
  use UI, :component

  import UI.Tokens.Color, only: [color: 2]
  alias UI.Atoms.Text
  # TODO: Move to UI as Toast
  import CoffeeWeb.CoreComponents, only: [flash_group: 1]

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :right_menu_items, :list,
    default: [],
    doc: """
    A list of items where each item is a map with the following keys:
      - `:label` (string) - the label for the link.
      - `:href` (optional, string) - the URL.
      - `:method` (optional, string) - the method of the URL. Default `get`
      - `:title` (optional, string) - the tooltip for the link.
      - `:font_weight` (optional, string) - normal or bold.
    """

  attr :bg_color, :string, required: false

  def base_header(assigns) do
    bg_color = assigns[:bg_color] || "transparent"
    debug(bg_color)

    assigns =
      assign(
        assigns,
        :css_classes,
        classes([
          color(:background, bg_color),
          "px-4",
          "sm:px-6",
          "lg:px-8",
          "isolate",
          "z-50",
          "sticky",
          "top-0",
          "border-b border-zinc-100": bg_color != "transparent"
        ])
      )

    ~H"""
    <.flash_group flash={@flash} />
    <header class={@css_classes}>
      <div class="flex items-center justify-between py-3 text-sm">
        <div class="flex items-center gap-4">
          <a href="/">
            <img src={~p"/images/logo.svg"} width="36" />
          </a>
        </div>

        <ul class="relative z-10 flex items-center gap-4 justify-end">
          <%= for item <- @right_menu_items do %>
            <li>
              <%= if item[:href] do %>
                <.link
                  href={item[:href]}
                  method={item[:method]}
                  title={item[:title]}
                >
                  <.text font_weight={item[:font_weight]}>
                    <%= item[:label] %>
                  </.text>
                </.link>
              <% else %>
                <.text font_weight={item[:font_weight]}>
                  <%= item[:label] %>
                </.text>
              <% end %>
            </li>
          <% end %>
        </ul>
      </div>
    </header>
    """
  end

  attr :font_weight, :string, default: "normal"
  slot :inner_block, required: true

  defp text(assigns) do
    is_bold = assigns[:font_weight] == "bold"

    cond do
      is_bold ->
        ~H"""
        <Text.h5b>
          <%= render_slot(@inner_block) %>
        </Text.h5b>
        """

      true ->
        ~H"""
        <Text.h5>
          <%= render_slot(@inner_block) %>
        </Text.h5>
        """
    end
  end
end
