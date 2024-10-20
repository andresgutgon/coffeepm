defmodule UI.Atoms.Helpers.TextMacro do
  use UI, :component
  import UI.Tokens.Font, only: [font: 2]
  import UI.Tokens.Display, only: [display: 1]
  import UI.Tokens.Color, only: [color: 2]

  defmacro generate_sizes_macro do
    sizes = [
      %{name: :h1, attributes: [{:size, :string, "h1"}]},
      %{
        name: :h1b,
        attributes: [{:size, :string, "h1"}, {:weight, :string, "bold"}]
      },
      %{name: :h2, attributes: [{:size, :string, "h2"}]},
      %{
        name: :h2b,
        attributes: [{:size, :string, "h2"}, {:weight, :string, "bold"}]
      },
      %{name: :h3, attributes: [{:size, :string, "h3"}]},
      %{
        name: :h3b,
        attributes: [{:size, :string, "h3"}, {:weight, :string, "bold"}]
      },
      %{name: :h4, attributes: [{:size, :string, "h4"}]},
      %{
        name: :h4m,
        attributes: [{:size, :string, "h4"}, {:weight, :string, "medium"}]
      },
      %{
        name: :h4b,
        attributes: [{:size, :string, "h4"}, {:weight, :string, "semibold"}]
      },
      %{name: :h5, attributes: [{:size, :string, "h5"}]},
      %{
        name: :h5m,
        attributes: [{:size, :string, "h5"}, {:weight, :string, "medium"}]
      },
      %{
        name: :h5b,
        attributes: [{:size, :string, "h5"}, {:weight, :string, "semibold"}]
      },
      %{name: :h6, attributes: [{:size, :string, "h6"}]},
      %{
        name: :h6m,
        attributes: [{:size, :string, "h6"}, {:weight, :string, "medium"}]
      },
      %{
        name: :h6b,
        attributes: [{:size, :string, "h6"}, {:weight, :string, "semibold"}]
      },
      %{
        name: :h6c,
        attributes: [
          {:size, :string, "h6"},
          {:weight, :string, "bold"},
          {:uppercase, :boolean, true}
        ]
      },
      %{
        name: :h7,
        attributes: [
          {:size, :string, "h7"},
          {:weight, :string, "bold"},
          {:spacing, :string, "wide"}
        ]
      },
      %{
        name: :h7c,
        attributes: [
          {:size, :string, "h7"},
          {:weight, :string, "bold"},
          {:uppercase, :boolean, true},
          {:spacing, :string, "wide"}
        ]
      },
      %{
        name: :h8,
        attributes: [
          {:size, :string, "h8"},
          {:weight, :string, "bold"},
          {:spacing, :string, "wide"}
        ]
      }
    ]

    common_attributes = [
      {:tag, :string, "span"},
      {:color, :string, "foreground"},
      {:family, :string, "sans", ~w(sans mono)},
      {:weight, :string, "normal"},
      {:align, :string, "left"},
      {:tracking, :string, "normal"},
      {:display, :string, "inline"},
      {:white_space, :string, "normal"},
      {:word_break, :string, "normal"},
      {:uppercase, :boolean, false},
      {:capitalize, :boolean, false},
      {:ellipsis, :boolean, false},
      {:user_select, :boolean, true},
      {:no_wrap, :boolean, false},
      {:underline, :boolean, false},
      {:line_through, :boolean, false},
      {:monospace, :boolean, false},
      {:centered, :boolean, false},
      {:animate, :boolean, false},
      {:class, :string, ""}
    ]

    for %{name: name, attributes: specific_attributes} <- sizes do
      common_attributes_to_apply =
        Enum.reject(common_attributes, fn common_attr ->
          attr_name = elem(common_attr, 0)

          Enum.any?(specific_attributes, fn
            {specific_attr_name, _, _} -> specific_attr_name == attr_name
            {specific_attr_name, _, _, _} -> specific_attr_name == attr_name
          end)
        end)

      combined_attributes =
        Enum.map(
          specific_attributes ++ common_attributes_to_apply,
          &Macro.escape/1
        )

      quote bind_quoted: [name: name, combined_attributes: combined_attributes] do
        doc_string = """
        Component for #{name} text.
        ## Examples
          alias UI.Text, as: Text

          <Text.#{name}>Text content</Text.#{name}>
        """

        @doc doc_string

        combined_attributes =
          Enum.map(combined_attributes, fn
            {:{}, [], inner} ->
              case inner do
                [attr_name, type, default] ->
                  [attr_name, type, default]

                [attr_name, type, default, values] ->
                  [attr_name, type, default, values]

                _ ->
                  inner
              end

            {attr_name, type, default} ->
              [attr_name, type, default]

            {attr_name, type, default, values} ->
              [attr_name, type, default, values]
          end)

        for combined_attr <- combined_attributes do
          case combined_attr do
            [attr_name, type, default] when type != :global ->
              attr attr_name, type, default: Macro.escape(default)

            [attr_name, type, default, values] ->
              attr attr_name, type,
                default: Macro.escape(default),
                values: Macro.escape(values)
          end
        end

        attr :rest, :global, default: %{}
        slot :inner_block, required: true

        def unquote(name)(assigns) do
          UI.Atoms.Helpers.TextMacro.text(assigns)
        end
      end
    end
  end

  # ## Examples
  #     alias UI.Text, as: Text
  #
  #     <Text.h1>Text content</Text.h1>
  # """
  #
  # attr :tag, :string, default: "span"
  # attr :size, :string, default: "h4", values: ~w(h1 h2 h3 h4 h5 h6)
  # attr :family, :string, default: "sans", values: ~w(sans mono)
  # attr :align, :string, default: "left"
  # attr :color, :string, default: "foreground"
  # attr :tracking, :string, default: "normal"
  # attr :weight, :string, default: "normal"
  # attr :display, :string, default: "inline"
  # attr :white_space, :string, default: "normal"
  # attr :word_break, :string, default: "normal"
  # attr :uppercase, :boolean, default: false
  # attr :capitalize, :boolean, default: false
  # attr :ellipsis, :boolean, default: false
  # attr :user_select, :boolean, default: true
  # attr :no_wrap, :boolean, default: false
  # attr :underline, :boolean, default: false
  # attr :line_through, :boolean, default: false
  # attr :monospace, :boolean, default: false
  # attr :centered, :boolean, default: false
  # attr :animate, :boolean, default: false
  # attr :class, :string, default: ""
  # attr :rest, :global, default: %{}
  #
  # slot :inner_block, required: true
  #
  # def h1(assigns), do: text(assign(assigns, :size, "h1"))
  #
  # def h1b(assigns),
  #   do: text(assign(assigns, :size, "h1") |> Map.put(:weight, "bold"))
  #
  # def h2(assigns), do: text(assign(assigns, :size, "h2"))
  #
  # def h2b(assigns),
  #   do: text(Map.put(assigns, :size, "h2") |> Map.put(:weight, "bold"))
  #
  # def h3(assigns), do: text(Map.put(assigns, :size, "h3"))
  #
  # def h3b(assigns),
  #   do: text(Map.put(assigns, :size, "h3") |> Map.put(:weight, "bold"))
  #
  # def h4(assigns), do: text(Map.put(assigns, :size, "h4"))
  #
  # def h4m(assigns),
  #   do: text(Map.put(assigns, :size, "h4") |> Map.put(:weight, "medium"))
  #
  # def h4b(assigns),
  #   do: text(Map.put(assigns, :size, "h4") |> Map.put(:weight, "semibold"))
  #
  # def h5(assigns), do: text(Map.put(assigns, :size, "h5"))
  #
  # def h5m(assigns),
  #   do: text(Map.put(assigns, :size, "h5") |> Map.put(:weight, "medium"))
  #
  # def h5b(assigns),
  #   do: text(Map.put(assigns, :size, "h5") |> Map.put(:weight, "semibold"))
  #
  # def h6(assigns), do: text(Map.put(assigns, :size, "h6"))
  #
  # def h6m(assigns),
  #   do: text(Map.put(assigns, :size, "h6") |> Map.put(:weight, "medium"))
  #
  # def h6b(assigns),
  #   do: text(Map.put(assigns, :size, "h6") |> Map.put(:weight, "semibold"))
  #
  # def h6c(assigns),
  #   do:
  #     text(
  #       Map.put(assigns, :size, "h6")
  #       |> Map.put(:weight, "bold")
  #       |> Map.put(:uppercase, true)
  #     )
  #
  # def h7(assigns),
  #   do:
  #     text(
  #       Map.put(assigns, :size, "h7")
  #       |> Map.put(:weight, "bold")
  #       |> Map.put(:spacing, "wide")
  #     )
  #
  # def h7c(assigns),
  #   do:
  #     text(
  #       Map.put(assigns, :size, "h7")
  #       |> Map.put(:weight, "bold")
  #       |> Map.put(:uppercase, true)
  #       |> Map.put(:spacing, "wide")
  #     )
  #
  # def h8(assigns),
  #   do:
  #     text(
  #       Map.put(assigns, :size, "h8")
  #       |> Map.put(:weight, "bold")
  #       |> Map.put(:spacing, "wide")
  #     )

  def text(assigns) do
    assigns =
      assigns
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
      |> Map.put(:rest, assigns[:rest] || %{})

    ~H"""
    <.dynamic_tag name={@tag} class={@css_classes} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end
end
