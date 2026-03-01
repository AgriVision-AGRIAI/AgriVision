import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:flutter/cupertino.dart';

enum WeatherType { sunny, cloudy, rainy }

class WeatherIconUtil {
  static IconData getIcon(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return CupertinoIcons.sun_max_fill;
      case WeatherType.cloudy:
        return CupertinoIcons.cloud_fill;
      case WeatherType.rainy:
        return CupertinoIcons.cloud_rain_fill;
    }
  }

  static Color getColor(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return AppThemeColors.sunny;
      case WeatherType.cloudy:
        return AppThemeColors.cloudy;
      case WeatherType.rainy:
        return AppThemeColors.rainy;
    }
  }
}
