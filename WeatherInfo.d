module WeatherInfo;


/* Imports. */
import core.stdc.time;


public struct WeatherInfo
{
    /* The time when this weather information was last queried.
     * (the timestamp present in the response (in the "dt" field) doesn't seem to quite match the
     * last query time). */
    private time_t last_query_time;

    /* Coordinates of the city. */
    private struct Coordinates
    {
        /* Latitude of the city. */
        private double latitude;

        /* Longitude of the city. */
        private double longitude;
    }

    private Coordinates coordinates;

    /* Wind conditions in the city. */
    private struct Wind
    {
        /* Wind speed. */
        private double speed;

        /* Wind direction. */
        private double degrees;
    }

    private Wind wind;

    /* ID of the city. */
    private long city_id;

    /* Name of the city. */
    private string city_name;

    /* Country code of the city. */
    private string country_code;

    /* Time of sunrise at the city (on the day of the query). */
    private time_t sunrise;

    /* Time of sunset at the city (on the day of the query). */
    private time_t sunset;

    /* Short description of the weather. */
    private string weather_short_desc;

    /* Long description of the weather. */
    private string weather_long_desc;

    /* The current temperature (in degrees celsius). */
    private double temp_cur;

    /* The maximum temperature of the day (in degrees celsius). */
    private double temp_max;

    /* The minimum temperature of the day (in degrees celsius). */
    private double temp_min;

    /* Atmospheric pressure (in hPa). */
    private long pressure;

    /* Humidity (in %). */
    private long humidity;

    /* Cloudiness (in %). */
    private long cloudiness;

    /* Precipitation volume for the last 3 hours (in millimetres). */
    private double rain;

    /* Timestamp in query response. */
    private time_t query_timestamp;

    /* Status of query. */
    private long query_status_code;

    /* Returns true if this weather information is more than 10 minutes old. */
    public bool isInfoStale ()
    {
        import std.datetime;
        auto now_sec = stdTimeToUnixTime(Clock.currStdTime());

        return (this.last_query_time < (now_sec - (10 * 60)));
    }

    /* Prints the current weather information. */
    public void showWeatherInfo ()
    {
        import std.conv;
        import std.stdio;
        import std.string;

        // writeln(this.city_name ~ ", " ~ this.country_code ~ " (" ~ to!string(this.city_id) ~ ")");
        // writeln("    " ~ this.weather_short_desc ~ " (" ~ this.weather_long_desc ~ ")");
        // writeln("    current temperature : " ~ to!string(this.temp_cur) ~ " (min " ~
        //         to!string(this.temp_min) ~ ", max " ~ to!string(this.temp_max) ~ ")");

        auto city_and_country = this.city_name ~ ", " ~ this.country_code;

        writefln("    +-----------------------------------------+");
        writefln("    |%s|", center(city_and_country, 41));
        writefln("    +-----------------------------------------+");
        writefln("    |  weather      |  %s|", leftJustify(this.weather_short_desc, 23));
        writefln("    +-----------------------------------------+");
        writefln("    |  temperature  |  %.2f°C                |", this.temp_cur);
        writefln("    +-----------------------------------------+");
        writefln("    |  pressure     |  %d hPa               |", this.pressure);
        writefln("    +-----------------------------------------+");
        writefln("    |  humidity     |  %d%%                    |", this.humidity);
        writefln("    +-----------------------------------------+");
        writefln("    |  sunrise      |  %d             |", this.sunrise);
        writefln("    +-----------------------------------------+");
        writefln("    |  sunset       |  %d             |", this.sunset);
        writefln("    +-----------------------------------------+");
        writefln("");
    }

    import std.json;
    public void initFromJSON (JSONValue json)
    {
        this.coordinates.latitude = json["coord"]["lat"].floating;
        this.coordinates.longitude = json["coord"]["lon"].floating;
        this.wind.speed = json["wind"]["speed"].floating;
        this.wind.degrees = json["wind"]["deg"].floating;
        this.city_id = json["id"].integer;
        this.city_name = json["name"].str;
        this.country_code = json["sys"]["country"].str;
        this.sunrise = json["sys"]["sunrise"].integer;
        this.sunset = json["sys"]["sunset"].integer;
        this.weather_short_desc = json["weather"][0]["main"].str;
        this.weather_long_desc = json["weather"][0]["description"].str;
        this.temp_cur = json["main"]["temp"].floating - 273.15;
        this.temp_max = json["main"]["temp_max"].floating - 273.15;
        this.temp_min = json["main"]["temp_min"].floating - 273.15;
        this.pressure = json["main"]["pressure"].integer;
        this.humidity = json["main"]["humidity"].integer;
        this.cloudiness = json["clouds"]["all"].integer;

        if ( this.weather_short_desc == "Rain" )
        {
            this.rain = json["rain"]["3h"].floating;
        }

        this.query_timestamp = json["dt"].integer;
        this.query_status_code = json["cod"].integer;

        import std.datetime;
        this.last_query_time = stdTimeToUnixTime(Clock.currStdTime());
    }
}

