int main()
{
    import std.net.curl;
    import std.stdio;

    string line;
    while (1)
    {
        write("Enter a city: ");
        if ((line = readln()) is null)
            break;

        auto city = line[0..$-1];//.trim();
        auto url = "http://api.openweathermap.org/data/2.5/weather?q=" ~ city;
        writeln("URL: " ~ url);
        auto content = get(url);

        writeln("Raw json: " ~ content);

        import std.json;
        auto parsed_json = parseJSON(content);

        // writeln("coord = " ~ parsed_json["coord"].str);
        writeln("cod = ",  parsed_json["cod"].integer);
        // writeln("name = " ~ parsed_json["base"].str);
    }
    return 0;
}
