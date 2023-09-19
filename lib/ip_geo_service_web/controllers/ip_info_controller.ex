defmodule IpGeoServiceWeb.IpInfoController do
  use IpGeoServiceWeb, :controller

  alias IpGeoService.IPGeo

  action_fallback IpGeoServiceWeb.FallbackController

  def get_by_ip(conn, %{"ip" => ip}) do
    case IPGeo.get_ip_info_by_ip(ip) do
      nil ->
        {:error, :not_found}

      ip_info ->
        render(conn, :show, ip_info: ip_info)
    end
  end
end
