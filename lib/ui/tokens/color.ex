defmodule UI.Tokens.Color do
  @type background :: :transparent | :foreground | :foreground_muted
  @type text_color ::
          :white
          | :primary
          | :foreground
          | :background
          | :foreground_muted
          | :accent
          | :destructive
          | :destructive_foreground
          | :destructive_muted_foreground
          | :accent_foreground
          | :secondary_foreground
          | :warning_muted_foreground
  @type border_color :: :transparent | :white | :border

  @spec colors() :: map
  def colors do
    %{
      background: %{
        transparent: "bg-transparent",
        white: "bg-white",
        foreground: "bg-foreground",
        foreground_muted: "bg-muted-foreground"
      },
      text_color: %{
        white: "text-white",
        primary: "text-primary",
        foreground: "text-foreground",
        background: "text-background",
        foreground_muted: "text-muted-foreground",
        accent: "text-accent",
        destructive: "text-destructive",
        destructive_foreground: "text-destructive-foreground",
        destructive_muted_foreground: "text-destructive-muted-foreground",
        accent_foreground: "text-accent-foreground",
        secondary_foreground: "text-secondary-foreground",
        warning_muted_foreground: "text-warning-muted-foreground"
      },
      border_color: %{
        transparent: "border-transparent",
        white: "border-white",
        border: "border-border"
      }
    }
  end

  @spec color(:background | :text_color | :border_color, String.t()) ::
          String.t()
  def color(category, key) when is_binary(key) do
    atom_key = String.to_existing_atom(key)
    color(category, atom_key)
  rescue
    ArgumentError -> raise "Invalid color key: #{key}"
  end

  @spec color(:background | :text_color | :border_color, atom) :: String.t()
  def color(category, key) do
    properties = colors()
    Map.get(properties[category], key)
  end
end
