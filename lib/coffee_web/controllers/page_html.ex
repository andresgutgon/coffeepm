defmodule CoffeeWeb.PageHTML do
  use CoffeeWeb, :html
  alias UI.Atoms.Text

  embed_templates "page_html/*"
end
