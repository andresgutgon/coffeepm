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

        attr :rest, :global, include: ~w(href for title id)
        slot :inner_block, required: true

        def unquote(name)(assigns) do
          UI.Atoms.Helpers.TextMacro.text(assigns)
        end
      end
    end
  end

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
      |> Map.put(
        :rest,
        assigns.rest
        |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
        |> Enum.into(%{})
      )

    ~H"""
    <.dynamic_tag name={@tag} class={@css_classes} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end
end
