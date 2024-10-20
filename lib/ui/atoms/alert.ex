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
        "border-destructive/50 text-destructive dark:border-destructive/50 [&>span]:text-destructive"
    }
  }
  @text_color_variants %{
    variant: %{
      "default" => "foreground",
      "destructive" => "destructive"
    }
  }

  @default_variants %{
    variant: "default"
  }

  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :variant, :string, default: "default", values: ~w(default destructive)
  attr :link, :map, default: %{href: nil, text: nil}
  attr :class, :string, default: nil
  attr :icon, :string, default: nil
  attr :rest, :global, default: %{}

  def c(assigns) do
    assigns =
      assigns
      |> assign_new(:variant, fn -> "default" end)
      |> assign(:variant_class, variant(assigns, @variants))
      |> assign(:text_color, variant(assigns, @text_color_variants))

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
        <Text.h4b tag="h4" color={@text_color}><%= @title %></Text.h4b>
        <Text.h5 tag="p" color="foreground_muted"><%= @description %></Text.h5>
        <Text.h5b
          :if={@link.href && @link.text}
          tag="a"
          underline
          href={@link.href}
          color={@text_color}
        >
          <%= @link.text %>
        </Text.h5b>
      </div>
    </div>
    """
  end

  defp variant(variants, variants_list) do
    variants = Map.merge(@default_variants, variants)

    Enum.map_join(variants, " ", fn {key, value} ->
      variants_list[key][value]
    end) |> String.trim()
  end
end
