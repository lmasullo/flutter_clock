// Dependencies
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Weather extends ConsumerStatefulWidget {
  const Weather({super.key, required this.rebuild});

  final bool rebuild;

  @override
  ConsumerState<Weather> createState() => _WeatherState();
}

class _WeatherState extends ConsumerState<Weather> {
  // Variables
  // Initialize the local storage
  final LocalStorage localStorage = LocalStorage('snooze');
  String currentWeather = 'Loading...';
  String? weatherCity;

  getWeather() async {
    print('Getting weather...');

    // Pause 1 second
    Future.delayed(const Duration(milliseconds: 250), () async {
      weatherCity = await localStorage.getItem('city');
      print('weatherCityLocal in weather: $weatherCity');

      String key = '237050c89d2935837b7f5dcb2f94d52b';
      // String cityName = 'Lampasas';
      WeatherFactory wf = WeatherFactory(key);

      var w = await wf.currentWeatherByCityName(weatherCity!);

      String currentWeatherTemp = w.tempMax!.fahrenheit!.toInt().toString();
      print('Current Weather: $currentWeatherTemp');
      if (currentWeatherTemp != currentWeather &&
          currentWeatherTemp != 'Loading...') {
        print('Setting current weather...');
        setState(() {
          currentWeather = currentWeatherTemp;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Building weather...');

    if (widget.rebuild) {
      getWeather();
    }

    // Return the time string
    return Text(
      '$currentWeather\u2109',
      style: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 40,
      ),
    );
  }
}
