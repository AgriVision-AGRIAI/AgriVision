import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/utils/typography.theme.dart';
import 'icon.widget.dart';

class WeeklyWeatherItem extends StatelessWidget {
  final String day;
  final String description;
  final String high;
  final String low;
  final WeatherType type;
  final bool warning;

  const WeeklyWeatherItem({
    super.key,
    required this.day,
    required this.description,
    required this.high,
    required this.low,
    required this.type,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warning ? AppThemeColors.weatherwarning : AppThemeColors.cardbackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            WeatherIconUtil.getIcon(type),
            color: WeatherIconUtil.getColor(type),
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: AppTextStyles.h3),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(high, style: AppTextStyles.h3),
              Text(low, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
