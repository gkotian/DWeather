module WeatherInfo;


/* Imports. */
import core.stdc.time;


public struct WeatherInfo
{
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
    private int city_id;

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
    private double pressure;

    /* Humidity (in %). */
    private int humidity;

    /* Cloudiness (in %). */
    private int cloudiness;

    /* Precipitation volume for the last 3 hours (in millimetres). */
    private double rain;

    /* Timestamp of query. */
    private time_t query_time;

    /* Status of query. */
    private int query_status_code;

    /* Prints the current weather information. */
    public void showWeatherInfo ()
    {
        import std.conv;
        import std.stdio;

        writeln(this.city_name ~ ", " ~ this.country_code ~ " (" ~ to!string(this.city_id) ~ ")");
        writeln("    " ~ this.weather_short_desc ~ " (" ~ this.weather_long_desc ~ ")");
        writeln("    current temperature : " ~ to!string(this.temp_cur) ~ " (min " ~
                to!string(this.temp_min) ~ ", max " ~ to!string(this.temp_max) ~ ")");
    }

    import std.json;
    public void initFromJSON (JSONValue json)
    {
        this.coordinates.latitude = json["coord"]["lat"].floating;
        this.coordinates.longitude = json["coord"]["lon"].floating;
        this.wind.speed = json["wind"]["speed"].floating;
        this.wind.degrees = json["wind"]["deg"].floating;
        // this.city_id = json["id"].floating;
        this.city_name = json["name"].str;
        this.country_code = json["sys"]["country"].str;
        this.sunrise = json["sys"]["sunrise"].integer;
        this.sunset = json["sys"]["sunset"].integer;
        this.weather_short_desc = json["weather"][0]["main"].str;
        this.weather_long_desc = json["weather"][0]["description"].str;
        this.temp_cur = json["main"]["temp"].floating - 273.15;
        this.temp_max = json["main"]["temp_max"].floating - 273.15;
        this.temp_min = json["main"]["temp_min"].floating - 273.15;
        this.pressure = json["main"]["pressure"].floating;
        // this.humidity = json["main"]["humidity"].integer;
        // this.cloudiness = json["clouds"]["all"].integer;
        this.rain = json["rain"]["3h"].floating;
        this.query_time = json["dt"].integer;
        // this.query_status_code = json["cod"].integer;
    }
}

