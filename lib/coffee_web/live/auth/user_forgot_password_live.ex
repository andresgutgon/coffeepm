defmodule CoffeeWeb.Auth.UserForgotPasswordLive do
  use CoffeeWeb, :live_view

  alias CoffeeWeb.Live.Auth.Components.FormWrapper
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input
  alias Coffee.Accounts

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/forgot-password/#{&1}")
      )
    end

    {:noreply,
     socket
     |> put_flash(
       :info,
       "If your email is in our system, you will receive instructions to reset your password shortly."
     )
     |> redirect(to: ~p"/login")}
  end

  def render(assigns) do
    ~H"""
    <FormWrapper.c title="Forgot your password?">
      <:subtitle>
        We'll send a password reset link to your inbox or you can
      </:subtitle>
      <Form.c for={@form} id="reset_password_form" phx-submit="send_email">
        <Input.c
          field={@form[:email]}
          type="email"
          placeholder="Email"
          required
          autocomplete="email"
        />
        <:actions>
          <% # TODO: implement button links %>
          <.button phx-disable-with="Sending..." class="w-full">
            Reset password
          </.button>
        </:actions>
      </Form.c>
    </FormWrapper.c>
    """
  end
end
