defmodule InstagramWeb.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :instagram,
    error_handler: InstagramWeb.Guardian.ErrorHandler,
    module: InstagramWeb.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end