defmodule IpGeoService.IPGeo do
  @moduledoc """
  The IPGeo context.
  """

  import Ecto.Query, warn: false

  alias IpGeoParser.IpInfo
  alias IpGeoService.Repo

  @spec get_ip_info_by_ip(String.t()) :: IpInfo.t() | nil
  def get_ip_info_by_ip(ip) do
    IpGeoParser.get_by_ip(Repo, ip)
  end
end
