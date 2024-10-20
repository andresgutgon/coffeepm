defmodule CoffeeWeb.Auth.UserLoginLive do
  use CoffeeWeb, :live_view

  alias CoffeeWeb.Live.Auth.Components.FormWrapper
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input
  alias UI.Atoms.Text

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, page_title: "Login"),
     temporary_assigns: [form: form]}
  end

  def render(assigns) do
    ~H"""
    <FormWrapper.c title="Login">
      <:subtitle>
        Don't have an account?
        <.link
          navigate={~p"/signup"}
          class="font-semibold text-brand hover:underline"
        >
          create one
        </.link>
        now
      </:subtitle>
      <Form.c id="login_form" action={~p"/login"} for={@form} phx-update="ignore">
        <Input.c
          field={@form[:email]}
          type="email"
          label="Email"
          placeholder="Your email"
          required
          autocomplete="email"
        />
        <Input.c
          field={@form[:password]}
          type="password"
          label="Password"
          placeholder="*********"
          description="At least 8 characters long."
          required
          autocomplete="current-password"
        />

        <div class="flex flex-col sm:flex-row sm:items-center gap-4">
          <Input.c field={@form[:remember_me]} type="checkbox" label="Remember me" />
          <.link href={~p"/forgot-password"} class="flex-shrink-0">
            <Text.h5b>Forgot your password?</Text.h5b>
          </.link>
        </div>

        <:actions>
          <.button phx-disable-with="Logging in...">
            Enter your account
          </.button>
        </:actions>
      </Form.c>
    </FormWrapper.c>
    """
  end
end
