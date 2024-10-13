defmodule CoffeeWeb.Auth.UserRegistrationLive do
  use CoffeeWeb, :live_view

  alias CoffeeWeb.Live.Auth.Components.FormWrapper
  alias Coffee.Accounts
  alias Coffee.Accounts.User
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/account/confirm-email/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)

        {:noreply,
         socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end

  def render(assigns) do
    ~H"""
    <FormWrapper.c title="Registration">
      <:subtitle>
        Have an account?
        <.link
          navigate={~p"/login"}
          class="font-semibold text-brand hover:underline"
        >
          Log in
        </.link>
        now.
      </:subtitle>
      <Form.c
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-trigger-action={@trigger_submit}
        action={~p"/login?_action=registered"}
        method="post"
      >
        <Input.c
          field={@form[:email]}
          type="text"
          label="Email"
          placeholder="Enter your email"
        />
        <Input.c
          field={@form[:password]}
          type="password"
          label="Password"
          placeholder="**********"
        />

        <:actions>
          <.button phx-disable-with="Creating account...">
            Create your account
          </.button>
        </:actions>
      </Form.c>
    </FormWrapper.c>
    """
  end
end
