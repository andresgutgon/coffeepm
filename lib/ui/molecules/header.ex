defmodule UI.Molecules.Header do
  use UI, :component
  alias UI.Atoms.Text, as: Text

  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def c(assigns) do
    ~H"""
    <header class={[
      @actions != [] && "flex items-center justify-between gap-6",
      @class
    ]}>
      <div class="flex flex-col gap-y-2">
        <Text.h2 tag="h1" display="block">
          <%= render_slot(@inner_block) %>
        </Text.h2>
        <Text.h5 :if={@subtitle != []} size="h5" tag="p">
          <%= render_slot(@subtitle) %>
        </Text.h5>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end
end
