defmodule CoffeeWeb.Auth.UserForgotPasswordLive do
  use CoffeeWeb, :live_view

  alias Coffee.Accounts
  alias Coffee.Accounts.User
  alias UI.Atoms.Alert
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input
  alias CoffeeWeb.Live.Auth.Components.FormWrapper

  def mount(_params, _session, socket) do
    changeset = Accounts.change_reset_email(%User{})

    socket =
      socket
      |> assign(trigger_submit: false)
      |> assign_form(changeset)
      |> assign(page_title: "Recover password", sent_email: nil)

    form = to_form(%{"email" => nil}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def handle_event("send_email", %{"user" => user_params}, socket) do
    case Accounts.send_recover_password(
           user_params,
           &url(~p"/forgot-password/#{&1}")
         ) do
      {:ok, _} ->
        email = user_params["email"]

        changeset = Accounts.change_reset_email(%User{}, %{"email" => email})

        Process.send_after(self(), :reset_form, 3000)

        {:noreply,
         socket
         |> assign(sent_email: email)
         |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = %{changeset | action: :insert}
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_info(:reset_form, socket) do
    changeset = Accounts.change_reset_email(%User{})

    {:noreply,
     socket
     |> assign(sent_email: nil)
     |> assign_form(changeset)}
  end

  def render(assigns) do
    ~H"""
    <FormWrapper.c title="Recover password">
      <:subtitle>
        Send an email to reset your password.
      </:subtitle>
      <%= if @sent_email do %>
        <Alert.c
          title="All good, check your inbox"
          description={"An email has been sent to #{@sent_email}."}
        />
      <% else %>
        <Form.c
          for={@form}
          id="reset_password_form"
          phx-submit="send_email"
          phx-trigger-action={@trigger_submit}
          method="post"
        >
          <Input.c
            field={@form[:email]}
            type="text"
            label="Email"
            placeholder="Email"
            autocomplete="email"
          />
          <:actions>
            <% # TODO: implement button links %>
            <.button phx-disable-with="Sending...">
              Reset password
            </.button>
          </:actions>
        </Form.c>
      <% end %>
    </FormWrapper.c>
    """
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
