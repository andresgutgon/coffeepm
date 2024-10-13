defmodule UI.Atoms.Form do
  use UI, :component

  @doc """
  Renders a form wrapped with a class for vertical spacing.
  form inputs

  ## Examples
      alias UI.Atoms.Form, as: Form

      <Form.c for={@form} phx-change="validate" phx-submit="save">
        <Input.c field={@form[:email]} label="Email"/>
        <Input.c field={@form[:username]} label="Username" />
      </Form.c>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"

  attr :as, :any,
    default: nil,
    doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include:
      ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions

  def c(assigns) do
    ~H"""
    <.form :let={form} for={@for} as={@as} {@rest} class="flex flex-col gap-y-4">
      <%= render_slot(@inner_block, form) %>
      <div class="mt-2 flex items-center justify-between gap-6">
        <%= render_slot(@actions, form) %>
      </div>
    </.form>
    """
  end
end
