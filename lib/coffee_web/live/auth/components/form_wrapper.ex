defmodule CoffeeWeb.Live.Auth.Components.FormWrapper do
  use Gettext, backend: CoffeeWeb.Gettext
  use Phoenix.Component
  alias UI.Molecules.Header, as: Header

  attr :title, :string, required: true
  slot :inner_block, required: true
  slot :subtitle

  def c(assigns) do
    ~H"""
    <div class="w-96 flex flex-col gap-y-6 px-6">
      <Header.c>
        <%= @title %>
        <:subtitle :if={@subtitle != []}>
          <%= render_slot(@subtitle) %>
        </:subtitle>
      </Header.c>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
