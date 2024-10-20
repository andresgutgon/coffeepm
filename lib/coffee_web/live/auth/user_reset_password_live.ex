defmodule CoffeeWeb.Auth.UserResetPasswordLive do
  use CoffeeWeb, :live_view

  @entity_name "user"

  alias Coffee.Accounts
  alias UI.Atoms.Alert
  alias UI.Atoms.Form, as: Form
  alias UI.Atoms.Input, as: Input
  alias CoffeeWeb.Live.Auth.Components.FormWrapper
  use CoffeeWeb.Auth.Helpers.AssignForm, only: [assign_form: 3]

  def mount(params, _session, socket) do
    socket = verify_token_and_assign(socket, params)

    form =
      with %{user: user} when not is_nil(user) <- socket.assigns do
        Accounts.change_user_password(user)
      else
        _ -> %{}
      end

    socket = socket |> assign_form(form, as: @entity_name)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/login")}

      {:error, changeset} ->
        {:noreply,
         assign_form(socket, Map.put(changeset, :action, :insert),
           as: @entity_name
         )}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      Accounts.change_user_password(
        socket.assigns.user,
        user_params
      )

    {:noreply,
     assign_form(socket, Map.put(changeset, :action, :validate),
       as: @entity_name
     )}
  end

  def render(assigns) do
    ~H"""
    <FormWrapper.c title="Reset your password">
      <:subtitle :if={!@invalid_token}>
        Choose a new password.
      </:subtitle>
      <%= if @invalid_token do %>
        <Alert.c
          icon="hero-exclamation-circle"
          variant="destructive"
          title="Invalid recover link"
          description="The recover link is invalid. Please request a new one."
          link={%{href: ~p"/forgot-password", text: "Request a new one"}}
        />
      <% else %>
        <Form.c
          for={@form}
          id="reset_password_form"
          phx-submit="reset_password"
          phx-change="validate"
        >
          <Input.c
            field={@form[:password]}
            type="password"
            label="New password"
            autocomplete="new-password"
          />
          <Input.c
            field={@form[:password_confirmation]}
            type="password"
            label="Confirm new password"
            autocomplete="confirm-password"
          />
          <:actions>
            <% # TODO: implement button links %>
            <.button phx-disable-with="Resetting...">
              Reset password
            </.button>
          </:actions>
        </Form.c>
      <% end %>
    </FormWrapper.c>
    """
  end

  defp verify_token_and_assign(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token, invalid_token: false)
    else
      assign(socket, user: nil, token: nil, invalid_token: true)
    end
  end
end
