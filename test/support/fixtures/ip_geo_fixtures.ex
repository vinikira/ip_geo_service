defmodule IpGeoService.IPGeoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IpGeoService.IPGeo` context.
  """

  alias IpGeoParser.IpInfo
  alias IpGeoService.Repo

  @doc """
  Generate a ip_info.
  """
  def ip_info_fixture(attrs \\ %{}) do
    {:ok, ip_info} =
      attrs
      |> Enum.into(%{
        ip: "192.168.0.1",
        country_code: "BR",
        country: "Brazil",
        city: "Santo Andre",
        latitude: -23.674223,
        longitude: -46.543598,
        mystery_value: 1_231_312
      })
      |> IpInfo.changeset()
      |> Repo.insert()

    ip_info
  end
end
