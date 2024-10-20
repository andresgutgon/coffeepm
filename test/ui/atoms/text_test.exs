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

    test "renders h5 as link" do
      assigns = %{}

      assert(
        rendered_to_string(~H"""
        <Text.h5 href="/this-link" tag="a">The text</Text.h5>
        """) =~
          ~s(<a class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-5 text-sm user-select\" href=\"/this-link\">\n  The text\n</a>)
      )
    end

    test "renders h5 as label" do
      assigns = %{}

      assert(
        rendered_to_string(~H"""
        <Text.h5 for="my-input" tag="label">The text</Text.h5>
        """) =~
          ~s(<label class=\"inline text-foreground break-normal whitespace-normal text-left tracking-normal font-sans font-normal leading-5 text-sm user-select\" for=\"my-input\">\n  The text\n</label>)
      )
    end
  end
end
