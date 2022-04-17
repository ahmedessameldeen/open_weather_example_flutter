import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/hourly_weather.dart';

import 'suggested_places.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key, required this.city}) : super(key: key);
  final String city;

  @override
  MyWeatherPageState createState() => MyWeatherPageState();
}

class MyWeatherPageState extends State<WeatherPage> {
  final List<String> _backgrounds = ["bg_1", "bg_2", "bg_3", "bg_4"];
  var _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final image = 'assets/images/${_backgrounds[_index]}.jpg';
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spacer(),
              // CitySearchBox(),
              const Spacer(),
              CurrentWeather(showNextBackground, showPreviousBackground),
              const Spacer(),
              const SuggestedPlaces(),
              const Spacer(),
              const HourlyWeather(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  showNextBackground() {
    setState(() {
      if (_index >= _backgrounds.length - 1) {
        _index = 0;
      } else {
        _index++;
      }
    });
  }

  showPreviousBackground() {
    setState(() {
      if (_index > 0) {
        _index--;
      } else {
        _index = _backgrounds.length - 1;
      }
    });
  }
}
