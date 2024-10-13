defmodule UI.Atoms.Input do
  import Phoenix.HTML.Form, only: [options_for_select: 2, normalize_value: 2]
  use Gettext, backend: CoffeeWeb.Gettext

  use UI, :component
  alias UI.Atoms.FormField, as: FormField
  alias UI.Atoms.Label, as: Label

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :form_field_class, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values:
      ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc:
      "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []

  attr :description, :string,
    default: nil,
    doc: "the description for the form field"

  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"

  attr :options, :list,
    doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"

  attr :multiple, :boolean,
    default: false,
    doc: "the multiple flag for select inputs"

  attr :rest, :global, include: ~w(required autocomplete), default: %{}

  def c(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil, id: assigns.id || field.id)
      |> assign(:errors, Enum.map(errors, &translate_error(&1)))
      |> assign_new(:name, fn ->
        if assigns.multiple, do: field.name <> "[]", else: field.name
      end)
      |> assign_new(:value, fn -> field.value end)

    c(assigns)
  end

  def c(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <FormField.c
      id={@id}
      errors={@errors}
      description={@description}
      class={@form_field_class}
    >
      <Label.c for={@id} color="foreground_muted" class="flex items-center gap-x-2">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          checked={@checked}
          value="true"
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </Label.c>
    </FormField.c>
    """
  end

  def c(%{type: "select"} = assigns) do
    ~H"""
    <FormField.c
      id={@id}
      label={@label}
      errors={@errors}
      description={@description}
      class={@form_field_class}
    >
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </FormField.c>
    """
  end

  def c(%{type: "textarea"} = assigns) do
    ~H"""
    <FormField.c
      id={@id}
      label={@label}
      errors={@errors}
      description={@description}
      class={@form_field_class}
    >
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 min-h-[6rem]",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= normalize_value("textarea", @value) %></textarea>
    </FormField.c>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def c(assigns) do
    ~H"""
    <FormField.c
      id={assigns.id}
      label={assigns.label}
      errors={assigns.errors}
      description={assigns.description}
      class={assigns[:form_field_class]}
    >
      <input
        type={@type}
        name={@name}
        id={@id}
        value={normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
    </FormField.c>
    """
  end

  defp translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(CoffeeWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(CoffeeWeb.Gettext, "errors", msg, opts)
    end
  end
end
