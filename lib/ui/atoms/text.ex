defmodule UI.Atoms.Text do
  use UI, :component
  import UI.Tokens.Font, only: [font: 2]
  import UI.Tokens.Display, only: [display: 1]
  import UI.Tokens.Color, only: [color: 2]

  @doc """
  Render text component in different sizes and styles

  ## Examples
      alias UI.Text, as: Text

      <Text.h1>Text content</Text.h1>
  """

  attr :tag, :string, default: "span"
  attr :size, :string, default: "h4", values: ~w(h1 h2 h3 h4 h5 h6)
  attr :family, :string, default: "sans", values: ~w(sans mono)
  attr :align, :string, default: "left"
  attr :color, :string, default: "foreground"
  attr :tracking, :string, default: "normal"
  attr :weight, :string, default: "normal"
  attr :display, :string, default: "inline"
  attr :white_space, :string, default: "normal"
  attr :word_break, :string, default: "normal"
  attr :uppercase, :boolean, default: false
  attr :capitalize, :boolean, default: false
  attr :ellipsis, :boolean, default: false
  attr :user_select, :boolean, default: true
  attr :no_wrap, :boolean, default: false
  attr :underline, :boolean, default: false
  attr :line_through, :boolean, default: false
  attr :monospace, :boolean, default: false
  attr :centered, :boolean, default: false
  attr :animate, :boolean, default: false
  attr :class, :string, default: ""
  attr :rest, :global, default: %{}

  slot :inner_block, required: true

  def h1(assigns), do: text(assign(assigns, :size, "h1"))

  def h1b(assigns),
    do: text(assign(assigns, :size, "h1") |> Map.put(:weight, "bold"))

  def h2(assigns), do: text(assign(assigns, :size, "h2"))

  def h2b(assigns),
    do: text(Map.put(assigns, :size, "h2") |> Map.put(:weight, "bold"))

  def h3(assigns), do: text(Map.put(assigns, :size, "h3"))

  def h3b(assigns),
    do: text(Map.put(assigns, :size, "h3") |> Map.put(:weight, "bold"))

  def h4(assigns), do: text(Map.put(assigns, :size, "h4"))

  def h4m(assigns),
    do: text(Map.put(assigns, :size, "h4") |> Map.put(:weight, "medium"))

  def h4b(assigns),
    do: text(Map.put(assigns, :size, "h4") |> Map.put(:weight, "semibold"))

  def h5(assigns), do: text(Map.put(assigns, :size, "h5"))

  def h5m(assigns),
    do: text(Map.put(assigns, :size, "h5") |> Map.put(:weight, "medium"))

  def h5b(assigns),
    do: text(Map.put(assigns, :size, "h5") |> Map.put(:weight, "semibold"))

  def h6(assigns), do: text(Map.put(assigns, :size, "h6"))

  def h6m(assigns),
    do: text(Map.put(assigns, :size, "h6") |> Map.put(:weight, "medium"))

  def h6b(assigns),
    do: text(Map.put(assigns, :size, "h6") |> Map.put(:weight, "semibold"))

  def h6c(assigns),
    do:
      text(
        Map.put(assigns, :size, "h6")
        |> Map.put(:weight, "bold")
        |> Map.put(:uppercase, true)
      )

  def h7(assigns),
    do:
      text(
        Map.put(assigns, :size, "h7")
        |> Map.put(:weight, "bold")
        |> Map.put(:spacing, "wide")
      )

  def h7c(assigns),
    do:
      text(
        Map.put(assigns, :size, "h7")
        |> Map.put(:weight, "bold")
        |> Map.put(:uppercase, true)
        |> Map.put(:spacing, "wide")
      )

  def h8(assigns),
    do:
      text(
        Map.put(assigns, :size, "h8")
        |> Map.put(:weight, "bold")
        |> Map.put(:spacing, "wide")
      )

  def mono(assigns),
    do:
      text(
        Map.put(assigns, :family, "mono")
        |> Map.put(:size, assigns.size || "h6")
        |> Map.put(:weight, assigns.weight || "normal")
      )

  defp text(assigns) do
    assigns = extract_rest(assigns)
    assigns =
      assigns
      |> extract_rest()
      |> assign(
        :css_classes,
        classes([
          color(:text_color, assigns[:color]),
          font(:size, assigns[:size]),
          font(:family, assigns[:family]),
          font(:weight, assigns[:weight]),
          font(:align, assigns[:align]),
          font(:tracking, assigns[:tracking]),
          font(:white_space, assigns[:white_space]),
          font(:word_break, assigns[:word_break]),
          display(assigns[:display]),
          assigns[:class],
          "animate-text-gradient": assigns[:animate],
          capitalize: assigns[:capitalize],
          uppercase: assigns[:uppercase],
          ellipsis: assigns[:ellipsis],
          "user-select": assigns[:user_select],
          "whitespace-nowrap": assigns[:no_wrap],
          underline: assigns[:underline],
          "line-through": assigns[:line_through],
          "font-mono": assigns[:monospace],
          "text-center": assigns[:centered]
        ])
      )
      |> Map.put(:tag, assigns[:tag] || "span")

    ~H"""
    <.dynamic_tag name={@tag} class={@css_classes} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  defp extract_rest(assigns) do
    explicit_attrs = [
      :tag,
      :underline,
      :size,
      :family,
      :align,
      :color,
      :tracking,
      :weight,
      :display,
      :white_space,
      :word_break,
      :uppercase,
      :capitalize,
      :ellipsis,
      :user_select,
      :no_wrap,
      :line_through,
      :monospace,
      :centered,
      :animate,
      :class
    ]

    extracted_attrs = Map.take(assigns[:rest] || %{}, explicit_attrs)
    rest = Map.drop(assigns[:rest] || %{}, explicit_attrs)

    Map.merge(assigns, extracted_attrs) |> Map.put(:rest, rest)
  end
end
