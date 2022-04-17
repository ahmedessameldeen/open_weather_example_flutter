import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_weather_example_flutter/src/entities/weather/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/current_weather_controller.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/suggested_places.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/weather_icon_image.dart';

class CurrentWeather extends ConsumerWidget {
  CurrentWeather(this.onNextClicked, this.onPreviousClicked, {Key? key})
      : super(key: key);

  final Function onNextClicked;
  final Function onPreviousClicked;

  var previousEnabled = false;
  var nextEnabled = true;

  var searchVisibility = false;
  var selectedCityVisibility = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherDataValue = ref.watch(currentWeatherControllerProvider);
    final city = ref.watch(cityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_pin,
              color: Colors.white,
              size: 16.0,
            ),
            GestureDetector(
                onTap: () {
                  selectedCityVisibility = !selectedCityVisibility;
                },
                child: Visibility(
                    visible: selectedCityVisibility,
                    child: Text(city,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.normal))))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  // if (previousEnabled) {
                  onPreviousClicked();
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 24, top: 100),
                  child: rectShapeContainer(
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const EdgeInsets.all(12.0),
                      24.0),
                )),
            Flexible(
              child: weatherDataValue.when(
                data: (weatherData) =>
                    CurrentWeatherContents(data: weatherData),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, __) => Text(e.toString()),
              ),
            ),
            GestureDetector(
                onTap: () {
                  // if (nextEnabled) {
                  onNextClicked();
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 24, top: 100),
                  child: rectShapeContainer(
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const EdgeInsets.all(12.0),
                      24.0),
                ))
          ],
        )
      ],
    );
  }
}

class CurrentWeatherContents extends ConsumerWidget {
  const CurrentWeatherContents({Key? key, required this.data})
      : super(key: key);
  final WeatherData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = '$maxTemp°/ $minTemp°';
    final condition = data.description;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(30.0),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tight(const Size(double.infinity, 128)),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                top: 0.0,
                child: Text(temp,
                    style: textTheme.headline1!
                        .copyWith(fontWeight: FontWeight.w300)),
              ),
              Positioned(
                  top: 20,
                  right: 110,
                  child: Text("°c", style: textTheme.bodyText2)),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          WeatherIconImage(iconUrl: data.iconUrl, size: 60),
          Text(condition, style: textTheme.headline5)
        ]),
        Text(highAndLow, style: textTheme.subtitle1),
      ],
    );
  }
}


class GlobalState extends ChangeNotifier{
  String _name = 'Hello';
  String get getName => _name;
  void setName(String value){
    _name = value;
    notifyListeners();
  }
}
