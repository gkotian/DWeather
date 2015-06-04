module WeatherApp;

/* Imports. */
import std.json;
import std.net.curl;
import std.stdio;
import WeatherInfo;


/* Class containing all weather information for a city. */
public class WeatherApp
{
    /* URL used to get the public IP address of the user's system. */
    // private const ip_address_url = "http://ip.jsontest.com";
    private enum ip_address_url = "https://api.ipify.org/?format=json";

    /* Stem of the URL used to retrieve the name of the user's current city. The public IP address
     * of the user's system needs to be appended to it to form the full required URL. */
    private enum city_name_url_stem = "http://getcitydetails.geobytes.com/GetCityDetails?fqcn=";

    /* Stem of the URL used to retrieve the weather information of the user's current city. The city
     * name needs to be appended to it to form the full required URL. */
    private enum weather_url_stem = "http://api.openweathermap.org/data/2.5/weather?q=";

    /* Associative array containing the weather information of all cities
     * queried so far (indexed by city names). */
    private WeatherInfo[string] all_weather_infos;

    /* The main function that starts the weather application operations. */
    public void run ()
    {
        string public_ip_addr;

        this.getPublicIpAddress(public_ip_addr);

        string city;

        this.getCityName(public_ip_addr, city);

        JSONValue weather_json;

        if (!this.getWeatherDetails(city, weather_json))
        {
            writeln("Failed to get weather information for '" ~ city ~ "'.");
        }
        else
        {
            WeatherInfo weather_info;

            weather_info.initFromJSON(weather_json);

            this.all_weather_infos[city] = weather_info;

            weather_info.showWeatherInfo();
        }

        while (1)
        {
            write("Enter a city ('q' to quit): ");

            city = readln();

            import std.uni;
            city = toLower(city[0 .. $-1]);

            if (city == "q")
            {
                break;
            }

            import std.datetime;
            auto now_sec = stdTimeToUnixTime(Clock.currStdTime());

            auto p = city in all_weather_infos;

            if (p is null || p.isInfoStale())
            {
                if (!this.getWeatherDetails(city, weather_json))
                {
                    writeln("Failed to get weather information for '" ~ city ~ "'.");
                    continue;
                }

                if (p is null)
                {
                    WeatherInfo weather_info;

                    this.all_weather_infos[city] = weather_info;

                    p = city in all_weather_infos;
                }

                p.initFromJSON(weather_json);
            }

            p.showWeatherInfo();
        }
    }

    private void getPublicIpAddress (out string public_ip_addr)
    {
        auto content = get(this.ip_address_url);

        auto parsed_json = parseJSON(content);

        public_ip_addr = parsed_json["ip"].str;
    }

    private void getCityName (string public_ip_addr, out string city_name)
    {
        auto city_name_url = this.city_name_url_stem ~ public_ip_addr;
        auto content = get(city_name_url);

        auto parsed_json = parseJSON(content);

        import std.uni;
        city_name = toLower(parsed_json["geobytescity"].str);
    }

    private bool getWeatherDetails (string city_name, out JSONValue weather_json)
    {
        auto weather_url = this.weather_url_stem ~ city_name;

        auto content = get(weather_url);

        weather_json = parseJSON(content);

        return (weather_json["cod"].integer == 200);
    }
}

