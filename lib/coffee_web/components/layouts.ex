defmodule CoffeeWeb.Layouts do
  use CoffeeWeb, :html
  alias CoffeeWeb.Headers.Public, as: PublicHeader

  embed_templates "layouts/*"
end
