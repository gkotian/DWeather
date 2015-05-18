/* Usage:
 *     $> gdc main.d WeatherApp.d -nophoboslib -lgphobos2 -lcurl && ./a.out
 */

// ip.jsontest.com
// http://getcitydetails.geobytes.com/GetCityDetails?fqcn=217.186.53.81

module main;

import WeatherApp;


int main()
{
    auto weather_app = new WeatherApp();

    weather_app.run();

    return 0;
}

