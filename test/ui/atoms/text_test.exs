defmodule UI.Atoms.TextTest do
  use ExUnit.Case, async: true
  import Phoenix.Component
  import Phoenix.LiveViewTest
  alias UI.Atoms.Text

  describe "Text component" do
    test "renders h1" do
      assigns = %{}
      assert(
        rendered_to_string(~H"""
        <Text.h1>The text</Text.h1>
        """) =~
          ~s(<span class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-h1 text-4xl user-select\">\n  The text\n</span>)
      )
    end

    test "renders h1b" do
      assigns = %{}
      assert(
        rendered_to_string(~H"""
        <Text.h1b>The text</Text.h1b>
        """) =~
          ~s(<span class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-h1 text-4xl user-select\">\n  The text\n</span>)
      )
    end

    test "renders h2" do
      assigns = %{}
      assert(
        rendered_to_string(~H"""
        <Text.h2>The text</Text.h2>
        """) =~
          ~s(<span class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-10 text-h2 user-select\">\n  The text\n</span>)
      )
    end

    test "renders h2b" do
      assigns = %{}
      assert(
        rendered_to_string(~H"""
        <Text.h2b>The text</Text.h2b>
        """) =~
          ~s(<span class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-10 text-h2 user-select\">\n  The text\n</span>)
      )
    end

    test "renders h3" do
      assigns = %{}
      assert(
        rendered_to_string(~H"""
        <Text.h3>The text</Text.h3>
        """) =~
          ~s(<span class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-10 text-h2 user-select\">\n  The text\n</span>)
      )
    end
  end
end
