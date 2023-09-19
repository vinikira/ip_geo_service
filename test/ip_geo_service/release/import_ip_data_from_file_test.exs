defmodule IpGeoService.Release.ImportIpDataFromFileTest do
  use IpGeoService.DataCase

  import ExUnit.CaptureIO, only: [capture_io: 1]

  alias IpGeoService.Release.ImportIpDataFromFile

  @tmp_file_name "data.csv"

  setup do
    tmp_file_path = Path.expand([System.tmp_dir!(), @tmp_file_name])

    csv = """
    ip_address,country_code,country,city,latitude,longitude,mystery_value
    200.106.141.15,SI,Nepal,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
    160.103.7.140,CZ,Nicaragua,New Neva,-68.31023296602508,-37.62435199624531,7301823115
    AA.95.73.73,TL,Saudi Arabia,Gradymouth,-49.16675918861615,-86.05920084416894,2559997162
    """

    :ok = File.touch!(tmp_file_path)

    :ok = File.write!(tmp_file_path, csv)

    on_exit(fn ->
      File.rm!(tmp_file_path)
    end)

    [tmp_file_path: tmp_file_path]
  end

  describe "call/2" do
    test "should log the result properly", ctx do
      logs =
        capture_io(fn ->
          ImportIpDataFromFile.call(ctx.tmp_file_path, [])
        end)

      assert logs =~ "Importing CSV file #{ctx.tmp_file_path}"
      assert logs =~ "Import finished in"
      assert logs =~ "Rows inserted: 2"
      assert logs =~ "Errors found: 1"
    end

    test "should log errors in the verbose mode", ctx do
      logs =
        capture_io(fn ->
          ImportIpDataFromFile.call(ctx.tmp_file_path, verbose: true)
        end)

      assert logs =~ "Errors for IP AA.95.73.73: %{ip: [\"invalid format\"]}"
    end
  end
end
