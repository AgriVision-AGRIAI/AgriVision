import 'package:flutter/cupertino.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/typography.theme.dart';
import 'metric.widget.dart';
import 'icon.widget.dart';

class TodayWeatherCard extends StatelessWidget {
  const TodayWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TODAY – JUNE 12',
                    style: AppTextStyles.weather_h2
                  ),
                  SizedBox(height: 6),
                  Text(
                    '32°C',
                    style: TextStyle(
                      color: AppThemeColors.textPrimary,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Mostly Sunny',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                WeatherIconUtil.getIcon(WeatherType.sunny),
                size: 48,
                color: WeatherIconUtil.getColor(WeatherType.sunny),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              WeatherMetric(
                icon: CupertinoIcons.drop_fill,
                label: 'Humidity',
                value: '45%',
              ),
              WeatherMetric(
                icon: CupertinoIcons.wind,
                label: 'Wind',
                value: '12 km/h',
              ),
              WeatherMetric(
                icon: CupertinoIcons.sun_max_fill,
                label: 'UV Index',
                value: 'High (8)',
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
