defmodule IpGeoServiceWeb.IpInfoJSON do
  alias IpGeoParser.IpInfo

  @doc """
  Renders a single ip_info.
  """
  def show(%{ip_info: ip_info}) do
    %{data: data(ip_info)}
  end

  defp data(%IpInfo{} = ip_info) do
    %{
      ip: ip_info.ip,
      country: ip_info.country,
      country_code: ip_info.country_code,
      city: ip_info.city,
      latitude: ip_info.latitude,
      longitude: ip_info.longitude,
      mystery_value: ip_info.mystery_value,
    }
  end
end
