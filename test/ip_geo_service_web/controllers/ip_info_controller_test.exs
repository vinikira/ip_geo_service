defmodule IpGeoServiceWeb.IpInfoControllerTest do
  use IpGeoServiceWeb.ConnCase

  import IpGeoService.IPGeoFixtures

  alias IpGeoParser.IpInfo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get_by_ip" do
    setup [:create_ip_info]

    test "should return properly when found an IP info", %{
      conn: conn,
      ip_info: %IpInfo{} = ip_info
    } do
      response =
        conn
        |> get(~p"/api/ip_info/#{ip_info.ip}")
        |> json_response(200)

      assert response["data"]["ip"] == ip_info.ip
      assert response["data"]["country_code"] == ip_info.country_code
      assert response["data"]["country"] == ip_info.country
      assert response["data"]["city"] == ip_info.city
      assert response["data"]["latitude"] == ip_info.latitude
      assert response["data"]["longitude"] == ip_info.longitude
      assert response["data"]["mystery_value"] == ip_info.mystery_value
    end

    test "should return not found", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/ip_info/192.023.423.12")
        |> json_response(404)

      assert response["errors"] == %{"detail" => "Not Found"}
    end
  end

  defp create_ip_info(_) do
    ip_info = ip_info_fixture()
    %{ip_info: ip_info}
  end
end
