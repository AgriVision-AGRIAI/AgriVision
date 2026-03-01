import 'package:flutter/cupertino.dart';
import 'weekly-item.widget.dart';
import 'icon.widget.dart';

class WeeklyWeatherList extends StatelessWidget {
  const WeeklyWeatherList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(), // iOS feel
      padding: const EdgeInsets.only(bottom: 16),
      children: const [
        WeeklyWeatherItem(
          day: 'Monday',
          description: 'Good day for sowing grains',
          high: '34°',
          low: '24°',
          type: WeatherType.sunny,
        ),
        WeeklyWeatherItem(
          day: 'Tuesday',
          description: 'Optimal for harvesting',
          high: '31°',
          low: '22°',
          type: WeatherType.cloudy,
        ),
        WeeklyWeatherItem(
          day: 'Wednesday',
          description: 'Avoid spraying pesticides',
          high: '27°',
          low: '20°',
          type: WeatherType.rainy,
          warning: true,
        ),
        WeeklyWeatherItem(
          day: 'Thursday',
          description: 'Avoid spraying pesticides',
          high: '34°',
          low: '24°',
          type: WeatherType.sunny,
        ),
        WeeklyWeatherItem(
          day: 'Friday',
          description: 'Avoid spraying pesticides',
          high: '31°',
          low: '22°',
          type: WeatherType.cloudy,
        ),
        WeeklyWeatherItem(
          day: 'Saturday',
          description: 'Avoid spraying pesticides',
          high: '27°',
          low: '20°',
          type: WeatherType.rainy,
          warning: true,
        ),
      ],
    );
  }
}
