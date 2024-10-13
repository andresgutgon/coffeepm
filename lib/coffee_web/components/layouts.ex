defmodule CoffeeWeb.Layouts do
  use CoffeeWeb, :html
  alias CoffeeWeb.Headers.Public, as: PublicHeader
  alias CoffeeWeb.Headers.App, as: AppHeader

  embed_templates "layouts/*"
end
