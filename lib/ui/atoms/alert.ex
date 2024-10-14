defmodule UI.Atoms.Alert do
  use UI, :component
  import UI.Atoms.Icon

  @doc """
  Render alert

  ## Examples

      <UI.Alert.alert variant="destructive">
        <UI.Alert.title>Alert title</UI.Alert.title>
        <UI.Alert.description>Alert description</UI.Alert.description>
      </UI.Alert>
  """

  attr :variant, :string, default: "default", values: ~w(default destructive)
  attr :class, :string, default: nil
  attr :icon, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global, default: %{}

  def alert(assigns) do
    assigns =
      assigns
      |> assign_new(:variant, fn -> "default" end)
      |> assign(:variant_class, variant(assigns))

    ~H"""
    <div
      class={
        classes([
          "relative w-full rounded-lg border p-4 [&>span~*]:pl-7 [&>span+div]:translate-y-[-3px]",
          "flex flex-row align-top gap-x-2",
          @variant_class,
          @class
        ])
      }
      {@rest}
    >
      <%= if @icon do %>
        <div class="flex-none flex">
          <.icon name={@icon} class="w-6 h-6 text-current" />
        </div>
      <% end %>
      <div>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Render alert title
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def alert_title(assigns) do
    ~H"""
    <h5
      class={
        classes([
          "mb-1 font-medium leading-none tracking-tight",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </h5>
    """
  end

  @doc """
  Render alert description
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def alert_description(assigns) do
    ~H"""
    <div
      class={
        classes([
          "text-sm [&_p]:leading-relaxed",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @variants %{
    variant: %{
      "default" => "bg-background text-foreground",
      "destructive" =>
        "border-destructive/50 text-destructive dark:border-destructive [&>span]:text-destructive"
    }
  }

  @default_variants %{
    variant: "default"
  }

  defp variant(variants) do
    variants = Map.merge(@default_variants, variants)

    Enum.map_join(variants, " ", fn {key, value} -> @variants[key][value] end)
  end
end
