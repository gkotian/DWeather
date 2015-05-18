module WeatherApp;

/* Imports. */
import WeatherInfo;


/* Class containing all weather information for a city. */
public class WeatherApp
{
    /* URL used to get the public IP address of the user's system. */
    private const ip_address_url = "http://ip.jsontest.com";

    /* Stem of the URL used to retrieve the name of the user's current city. The public IP address
     * of the user's system needs to be appended to it to form the full required URL. */
    private const city_name_url_stem = "http://getcitydetails.geobytes.com/GetCityDetails?fqcn=";

    /* Stem of the URL used to retrieve the weather information of the user's current city. The city
     * name needs to be appended to it to form the full required URL. */
    private const weather_url_stem = "http://api.openweathermap.org/data/2.5/weather?q=";

    /* Associative array containing the weather information of all cities
     * queried so far (indexed by city names). */
    private WeatherInfo[string] all_weather_infos;

    /* The main function that starts the weather application operations. */
    public void run ()
    {
        string city;

        while (1)
        {
            import std.stdio;
            write("Enter a city ('q' to quit): ");

            city = readln();

            city = city[0 .. $-1];

            if (city == "q")
            {
                break;
            }

            import std.datetime;
            auto now_sec = stdTimeToUnixTime(Clock.currStdTime());
            writeln(now_sec);

            bool query_needed;
            bool new_weather_info_obj_needed;

            auto p = city in all_weather_infos;

            if (p is null)
            {
                query_needed = true;
                new_weather_info_obj_needed = true;
            }
            else if (p.isInfoStale())
            {
                query_needed = true;
            }

            if (query_needed)
            {
                auto weather_url = this.weather_url_stem ~ city;
                // writeln("URL: " ~ weather_url);

                import std.net.curl;
                auto content = get(weather_url);

                writeln("Raw json: " ~ content);

                import std.json;
                auto parsed_json = parseJSON(content);

                if (parsed_json["cod"].integer != 200)
                {
                    writeln("Error");
                    continue;
                }

                if (new_weather_info_obj_needed)
                {
                    auto weather_info = new WeatherInfo();

                    all_weather_infos[city] = *weather_info;

                    p = city in all_weather_infos;
                }

                p.initFromJSON(parsed_json);
            }

            p.showWeatherInfo();
        }
    }
}

