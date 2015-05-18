/* Usage:
 *     $> gdc main.d WeatherApp.d WeatherInfo.d -nophoboslib -lgphobos2 -lcurl && ./a.out
 */

module main;

/* Imports. */
import WeatherApp;


/* Main function. */
int main ()
{
    auto weather_app = new WeatherApp();

    weather_app.run();

    return 0;
}

