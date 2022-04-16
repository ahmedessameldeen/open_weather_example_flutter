import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_weather_example_flutter/src/entities/weather/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/hourly_weather_controller.dart';
import 'package:open_weather_example_flutter/src/features/weather_page/weather_icon_image.dart';

class SuggestedPlaces extends ConsumerWidget {
  const SuggestedPlaces({Key? key}) : super(key: key);

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
            child: Text("Where you can go?"),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weatherDataItems
                    .map((data) => HourlyWeatherItem(data: data))
                    .toList(),
              )),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: rectShapeContainer(
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Discover more'),
                              SizedBox(width: 16),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: Colors.white,
                                size: 24.0,
                              )
                            ]),
                      ),
                      const EdgeInsets.all(12.0),24.0))
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
    final rating = '4.8';
    final visits = '123';

    final distance = "15";
    final time = "30";

    return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: rectShapeContainer(
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Image border
                  child: SizedBox.fromSize(
                    size: const Size(98, 78), // Image radius
                    child: Image.network(
                        'https://i.picsum.photos/id/1020/4288/2848.jpg?hmac=Jo3ofatg0fee3HGOliAIIkcg4KGXC8UOTO1dm5qIIPc',
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 12,right: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                            child: Text(
                          'Cairo Festival city',
                          style: textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold,fontSize: 16),
                        )),
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          child:  Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xfffaae00),
                                  size: 16.0,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating,
                                  style: textTheme.bodyText1!
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '($visits)',
                                  style: textTheme.button!
                                      .copyWith(fontWeight: FontWeight.w300,color: Colors.white.withOpacity(0.6)),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:  Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/ic_distance.svg',
                                  color: Colors.white,
                                  width: 13.33,
                                  height: 10.0,
                                  semanticsLabel: "distance",
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '$distance km',
                                  style: textTheme.caption!
                                      .copyWith(fontWeight: FontWeight.w400,color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                SvgPicture.asset(
                                  'assets/ic_time.svg',
                                  color: Colors.white,
                                  width: 12.0,
                                  height: 12.0,
                                  semanticsLabel: "distance",
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$time min',
                                  style: textTheme.caption!
                                      .copyWith(fontWeight: FontWeight.w400,color: Colors.white),
                                )
                              ]),
                        )

                      ],
                    ))
              ],
            ),
            const EdgeInsets.all(8.0),10.0));
  }
}

Widget rectShapeContainer(Widget child, EdgeInsets margin,double borderRadius) {
  return Container(
    padding: margin,
    decoration: BoxDecoration(
      //you can get rid of below line also
      borderRadius: BorderRadius.circular(borderRadius),
      //below line is for rectangular shape
      shape: BoxShape.rectangle,
      //you can change opacity with color here(I used black) for rect
      color: Colors.black.withOpacity(0.20),
      //I added some shadow, but you can remove boxShadow also.
      boxShadow: const <BoxShadow>[
        BoxShadow(color: Color(0x202f2e2e)),
      ],
    ),
    child: child,
  );
}
