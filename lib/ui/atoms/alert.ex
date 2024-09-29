defmodule UI.Atoms.Alert do
  use UI, :component
  import UI.Atoms.Icon
  alias UI.Atoms.Text

  @doc """
  Render alert

  ## Examples

      <UI.Alert.alert variant="destructive">
        <UI.Alert.title>Alert title</UI.Alert.title>
        <UI.Alert.description>Alert description</UI.Alert.description>
      </UI.Alert>
  """

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

  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :variant, :string, default: "default", values: ~w(default destructive)
  attr :class, :string, default: nil
  attr :icon, :string, default: nil
  attr :rest, :global, default: %{}

  def c(assigns) do
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
      <div class="flex flex-col gap-y-2">
        <Text.h4 as="h4"><%= @title %></Text.h4>
        <Text.h5 as="p"><%= @description %></Text.h5>
      </div>
    </div>
    """
  end

  defp variant(variants) do
    variants = Map.merge(@default_variants, variants)

    Enum.map_join(variants, " ", fn {key, value} -> @variants[key][value] end)
  end
end
