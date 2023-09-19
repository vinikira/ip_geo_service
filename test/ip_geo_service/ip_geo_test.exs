defmodule IpGeoService.IPGeoTest do
  use IpGeoService.DataCase

  alias IpGeoService.IPGeo

  describe "ip_geo_data" do
    import IpGeoService.IPGeoFixtures

    test "get_ip_info_by_ip return a ip when found" do
      ip_info = ip_info_fixture()
      found_ip_info = IPGeo.get_ip_info_by_ip(ip_info.ip)

      assert ip_info == found_ip_info
    end

    test "get_ip_info_by_ip return nil when not found" do
      refute IPGeo.get_ip_info_by_ip("192.123.234.43")
    end
  end
end
