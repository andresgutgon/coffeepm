defmodule CoffeeWeb.Auth.UserForgotPasswordLive do
  use CoffeeWeb, :live_view

      import Logger, only: [debug: 1, info: 1, warn: 1, error: 1]
  alias Coffee.Accounts
  alias Coffee.Accounts.User
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input
  alias CoffeeWeb.Live.Auth.Components.FormWrapper

  def mount(_params, _session, socket) do
    changeset = Accounts.change_reset_email(%User{})

    socket =
      socket
      |> assign(trigger_submit: false)
      |> assign_form(changeset)

    form = to_form(%{"email" => nil}, as: "user")

    {:ok, assign(socket, form: form, page_title: "Recover password"),
     temporary_assigns: [form: form]}
  end

  def handle_event("send_email", %{"user" => user_params}, socket) do
    result =
      Accounts.send_recover_password(
        user_params,
        &url(~p"/forgot-password/#{&1}")
      )

    case result do
      {:ok, _} ->
        # TODO: Do the fancy swap for a message
        # {:noreply,
        #  socket |> assign(trigger_submit: true) |> assign_form(changeset)}
        {:ok, _} =
          email = user_params["email"]

        {:noreply,
         socket
         |> put_flash(
           :info,
           "If you have an account with  #{email}, you will receive instructions to reset your password shortly."
         )
         |> redirect(to: ~p"/login")}

      {:error, %Ecto.Changeset{} = changeset} ->
        # WHY? here are the errors but not in the email field????
        debug("------CHANGESET: #{inspect(changeset)}")
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  def render(assigns) do
    debug("---------REnder ASSIGNS: #{inspect(assigns.form[:email])}")
    ~H"""
    <FormWrapper.c title="Recover password">
      <:subtitle>
        Send an email to reset your password.
      </:subtitle>
      <Form.c
        for={@form}
        id="reset_password_form"
        phx-trigger-action={@trigger_submit}
        phx-submit="send_email"
      >
        <Input.c
          field={@form[:email]}
          type="text"
          placeholder="Email"
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
