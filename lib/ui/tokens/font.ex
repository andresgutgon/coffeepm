defmodule UI.Tokens.Font do
  @type font_size :: :h8 | :h7 | :h6 | :h5 | :h4 | :h3 | :h2 | :h1
  @type font_family :: :sans | :mono
  @type font_weight :: :normal | :medium | :semibold | :bold
  @type font_tracking :: :normal | :wide
  @type text_align :: :left | :center | :right
  @type white_space :: :normal | :nowrap | :pre | :pre_line | :pre_wrap
  @type word_break :: :normal | :words | :all

  @spec font_properties() :: map
  def font_properties do
    %{
      size: %{
        # 8px/10px
        h8: "text-[8px] leading-[10px]",
        # 10px/16px
        h7: "text-[10px] leading-4",
        # 12px/16px
        h6: "text-xs leading-4",
        # 14px/20px
        h5: "text-sm leading-5",
        # 16px/24px
        h4: "text-normal leading-6",
        # 20px/32px
        h3: "text-xl leading-8",
        # 26px/40px
        h2: "text-h2 leading-10",
        # 36px/48px
        h1: "text-4xl leading-h1"
      },
      family: %{
        sans: "font-sans",
        mono: "font-mono"
      },
      weight: %{
        normal: "font-normal",
        medium: "font-medium",
        semibold: "font-semibold",
        bold: "font-bold"
      },
      tracking: %{
        normal: "tracking-normal",
        wide: "tracking-wide"
      },
      align: %{
        left: "text-left",
        center: "text-center",
        right: "text-right"
      },
      white_space: %{
        normal: "whitespace-normal",
        nowrap: "whitespace-nowrap",
        pre: "whitespace-pre",
        pre_line: "whitespace-pre-line",
        pre_wrap: "whitespace-pre-wrap"
      },
      word_break: %{
        normal: "break-normal",
        words: "break-words",
        all: "break-all"
      }
    }
  end

  @spec font(:size | :family | :weight | :tracking | :align, String.t()) ::
          String.t()
  def font(category, key) when is_binary(key) do
    atom_key = String.to_existing_atom(key)
    font(category, atom_key)
  rescue
    ArgumentError -> raise "Invalid key: #{key}"
  end

  @spec font(:size, font_size) :: String.t()
  @spec font(:family, font_family) :: String.t()
  @spec font(:weight, font_weight) :: String.t()
  @spec font(:align, text_align) :: String.t()
  @spec font(:tracking, font_tracking) :: String.t()
  @spec font(:white_space, white_space) :: String.t()
  @spec font(:word_break, word_break) :: String.t()
  def font(:size, key), do: font_properties().size[key]
  def font(:family, key), do: font_properties().family[key]
  def font(:weight, key), do: font_properties().weight[key]
  def font(:align, key), do: font_properties().align[key]
  def font(:tracking, key), do: font_properties().tracking[key]
  def font(:white_space, key), do: font_properties().white_space[key]
  def font(:word_break, key), do: font_properties().word_break[key]
end
