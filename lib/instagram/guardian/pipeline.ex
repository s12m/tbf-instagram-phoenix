defmodule Instagram.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :auth_me,
    error_handler: Instagram.Guardian.ErrorHandler,
    module: Instagram.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end