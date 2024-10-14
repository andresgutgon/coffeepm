defmodule CoffeeWeb.PageController do
  use CoffeeWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: {CoffeeWeb.Layouts, :public})
  end
end
