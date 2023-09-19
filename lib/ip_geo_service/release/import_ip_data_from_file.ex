defmodule IpGeoService.Release.ImportIpDataFromFile do
  @app :ip_geo_service

  alias IpGeoService.Repo

  @type option :: {:verbose, boolean()} | IpGeoParser.ImportFromFile.option()

  @spec call(String.t(), [option()]) :: :ok | no_return()
  def call(file_path, opts) when is_binary(file_path) do
    load_app()

    {verbose, opts!} = Keyword.pop(opts, :verbose, false)

    IO.puts("Importing CSV file #{file_path}")

    {time, {inserted, errors}} =
      :timer.tc(fn -> IpGeoParser.import_from_file(file_path, Repo, opts!) end)

    IO.puts("Import finished in #{time / 1_000_000} seconds")
    IO.puts("Rows inserted: #{inserted}")
    IO.puts("Errors found: #{length(errors)}")

    if verbose do
      Enum.each(errors, &log_error/1)
    end

    :ok
  end

  defp log_error(changeset) do
    ip = Map.get(changeset.changes, :ip, "No IP")

    errors_map =
      Ecto.Changeset.traverse_errors(
        changeset,
        fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
          end)
        end
      )

    IO.puts("Errors for IP #{ip}: #{inspect(errors_map)}")
  end

  defp load_app do
    Application.load(@app)
  end
end
