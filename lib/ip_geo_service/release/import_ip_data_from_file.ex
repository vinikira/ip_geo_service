defmodule IpGeoService.Release.ImportIpDataFromFile do
  @moduledoc """
  Task to import a CSV file of IpInfo and upsert into the database.

  ## Example
      iex> IpGeoService.Release.ImportIpDataFromFile.call("./ip_geo_data.csv", [])
      Import finished in 82.089133 seconds
      Rows inserted: 884932
      Errors found: 83395
      :ok
  """
  @app :ip_geo_service

  alias IpGeoService.Repo

  @typedoc """
  The following is the description of the options:

  - **verbose**: whether should log the errors or not
    Default: false

  - **batch_size**: the size of the batch of rows to be processed.
    Default: 50

  - **max_concurrency**: the number of workers that will process the batches.
    Default: 10

   - **validate_country**: whether should validate country code and name or not.
    Default: false
  """
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

    errors_map = Ecto.Changeset.traverse_errors(changeset, &travesse_error/1)

    IO.puts("Errors for IP #{ip}: #{inspect(errors_map)}")
  end

  defp travesse_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end

  defp load_app do
    Application.ensure_all_started(@app)
  end
end
