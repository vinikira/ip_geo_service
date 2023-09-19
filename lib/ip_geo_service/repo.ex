defmodule IpGeoService.Repo do
  use Ecto.Repo,
    otp_app: :ip_geo_service,
    adapter: Ecto.Adapters.Postgres
end
