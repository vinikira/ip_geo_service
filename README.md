# IpGeoService

A service to import IP Geo localization data and expose it via REST API.

WARNING: Do not use this, it is not production ready and was made as
part of an interview assessment.

## Getting started
### Local
Make sure you have Elixir and Erlang installed, you can use the
`asdfvm` to install them:

``` shell
asdf install
```

Also, make sure you have a Postgres database running in your machine,
you can use the `docker-compose.yml`:

``` shell
docker-compose up
```

Run the following to do the project setup:

``` shell
mix setup
```

Finally up the server:

``` shell
iex -S mix phx.server
```

### Docker
You can use the Dockerfile to build a image of the project:

``` shell
docker build . -t ip_geo_service
```

Then you can run it:

``` shell
docker run ip_geo_service:latest
```

Make sure to set the `DATABASE_URL` environment variable.

### Importing CSV
In order to import a CSV file, you can run the following command on
the IEx or mix release's eval:

``` shell
IpGeoService.Release.ImportIpDataFromFile.call("./path_to_your_file.csv", [])
```

You can also enable the verbose mode in order to get more detail about
possible errors:

``` shell
IpGeoService.Release.ImportIpDataFromFile.call("./path_to_your_file.csv",
verbose: true)
```

### Getting IP info
Once you have some IP data imported you can request them via HTTP
request as the following:

``` shell
curl http://localhost:4000/api/ip_info/192.168.0.1
```

You will receive the following response shape in case of success:

``` json
{
  "data": {
    "ip": "207.178.204.6",
    "city": "Terryview",
    "country": "Sao Tome and Principe",
    "country_code": "SN",
    "latitude": -76.9220262252864,
    "longitude": -53.94186920376674,
    "mystery_value": 4631788066
  }
}%
```

And the following in case of your requested IP is not found:

``` json
{
  "errors": {
    "detail": "Not Found"
  }
}%
```

## Documentation
You can build and open the docs with the following command:

``` shell
mix docs --open
```
