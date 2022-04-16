import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_example_flutter/src/entities/weather/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/hourly_weather_controller.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/weather_icon_image.dart';

import 'suggested_places.dart';

class HourlyWeather extends ConsumerWidget {
  const HourlyWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(hourlyWeatherControllerProvider);
    return forecastDataValue.when(
      data: (forecastData) {
        // API returns data points in 3-hour intervals -> 1 day = 8 intervals
        final items = [8, 16, 24, 32, 39];
        return HourlyWeatherRow(
          weatherDataItems: [
            for (var i in items) forecastData.list[i],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text(e.toString()),
    );
  }
}

class HourlyWeatherRow extends StatelessWidget {
  const HourlyWeatherRow({Key? key, required this.weatherDataItems})
      : super(key: key);
  final List<WeatherData> weatherDataItems;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 16),
            child: Text("Next 7 days"),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weatherDataItems
                    .map((data) => HourlyWeatherItem(data: data))
                    .toList(),
              ))
        ]);
  }
}

class HourlyWeatherItem extends ConsumerWidget {
  const HourlyWeatherItem({Key? key, required this.data}) : super(key: key);
  final WeatherData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    const fontWeight = FontWeight.normal;
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = '$maxTemp°/ $minTemp°';

    String titleText() {
      if (data.date.isTomorrow) {
        return 'Tomorrow';
      } else {
        return DateFormat.EEEE().format(data.date);
      }
    }

    return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: rectShapeContainer(Column(
          children: [
            IntrinsicHeight(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                titleText(),
                style:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 3),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    DateFormat.d().addPattern('/').add_M().format(data.date),
                    style: textTheme.labelSmall!.copyWith(
                      fontWeight: fontWeight,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  )),
            ])),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              WeatherIconImage(iconUrl: data.iconUrl, size: 48),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  highAndLow,
                  style: textTheme.bodyText1!.copyWith(fontWeight: fontWeight),
                ),
              ),
            ])
          ],
        ),const EdgeInsets.only(left: 16.0,right: 16,top: 12),10.0));
  }
}

extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
