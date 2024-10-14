defmodule UI.Atoms.FormField do
  require IEx

  use UI, :component
  alias UI.Atoms.Label, as: Label
  alias UI.Atoms.Text, as: Text

  @doc """
  Render form control

  ## Examples
      <UI.Atoms.FormControl.form_field label="Email">
        <.input type="text" />
      </UI.Atoms.FormControl.form_field>
  """

  attr :id, :string, required: true
  attr :label, :string, default: ""
  attr :errors, :list, default: []
  attr :class, :string, default: ""
  attr :description, :string, default: ""
  attr :rest, :global, default: %{}

  slot :inner_block, required: true

  attr :error, :string, default: nil

  def c(assigns) do
    assigns = assign_aria_attributes(assigns)

    ~H"""
    <div
      class={classes(["space-y-2 w-full", assigns[:class]])}
      aria-describedby={assigns[:aria_describedby]}
      aria-invalid={assigns[:aria_invalid]}
      {@rest}
    >
      <Label.c :if={@label != ""} for={@id}><%= @label %></Label.c>

      <.form_control
        id={@id}
        error={@error}
        aria_invalid={@aria_invalid}
        aria_describedby={@aria_describedby}
      >
        <%= render_slot(@inner_block) %>
      </.form_control>

      <Text.h5
        :if={String.trim(to_string(@description)) != ""}
        tag="p"
        id={assigns[:form_description_id]}
        color="foreground_muted"
      >
        <%= @description %>
      </Text.h5>

      <Text.h5
        :if={@error}
        tag="p"
        id={assigns[:form_message_id]}
        color="destructive"
      >
        <%= @error %>
      </Text.h5>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :aria_describedby, :string, default: ""
  attr :aria_invalid, :string, default: "false"
  attr :error, :string, default: nil
  slot :inner_block, required: true

  defp form_control(assigns) do
    ~H"""
    <div aria-describedby={@aria_describedby} aria-invalid={@aria_invalid}>
      <%= render_slot(@inner_block, %{aria_invalid: @aria_invalid}) %>
    </div>
    """
  end

  attr :error, :string, default: nil

  defp assign_aria_attributes(assigns) do
    id = assigns[:id]
    form_description_id = "#{id}-form-item-description"
    form_message_id = "#{id}-form-item-message"

    assigns
    |> assign(:form_message_id, form_message_id)
    |> assign(:form_description_id, form_description_id)
    |> assign(:aria_invalid, if(assigns[:error], do: "true", else: "false"))
    |> assign(
      :aria_describedby,
      if(assigns[:error],
        do: form_message_id,
        else: "#{form_description_id} #{form_message_id}"
      )
    )
    |> assign(
      :error,
      case assigns[:errors] do
        nil -> nil
        [] -> nil
        _ -> List.first(assigns[:errors])
      end
    )
  end
end
