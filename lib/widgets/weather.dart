// Dependencies
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String currentWeather = 'Loading...';

  int count = 0;

  getWeather() async {
    print('Getting weather...');
    // WeatherFactory wf = WeatherFactory("237050c89d2935837b7f5dcb2f94d52b");
    // double lat = 55.0111;
    // double lon = 15.0569;
    String key = '237050c89d2935837b7f5dcb2f94d52b';
    String cityName = 'Lampasas';
    WeatherFactory wf = WeatherFactory(key);

    var w = await wf.currentWeatherByCityName(cityName);

    // String cityName = 'Lampasas';
    // Weather w = (await wf.currentWeatherByCityName(cityName)) as Weather;
    print(w.tempFeelsLike!.fahrenheit!.toInt());
    currentWeather = w.tempFeelsLike!.fahrenheit!.toInt().toString();

    setState(() {
      currentWeather = currentWeather;
      count = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    // A stream that emits the current time every second
    return StreamBuilder(
      stream: Stream.periodic(const Duration(minutes: 1)),
      builder: (context, snapshot) {
        // Get the current time
        // final time = DateTime.now();

        // // Get the current time in a string
        // final timeString =
        //     '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

        // increment the count
        count++;
        print('Count: $count');

        if (count == 2) {
          getWeather();
        }

        // Return the time string
        return Text(
          '$currentWeather\u2109',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 50,
          ),
        );
      },
    );
  }
}
