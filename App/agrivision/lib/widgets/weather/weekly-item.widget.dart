import 'package:flutter/cupertino.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import 'icon.widget.dart';

class WeeklyWeatherItem extends StatelessWidget {
  final String day;
  final String temperature;
  final String humidity;
  final String rainfall;
  final WeatherType type;
  final bool warning;

  const WeeklyWeatherItem({
    super.key,
    required this.day,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.type,
    this.warning = false,
  });

  @override
Widget build(BuildContext context) {
  final icon = WeatherIconUtil.getIcon(type);
  final iconColor = WeatherIconUtil.getColor(type);

  return Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: warning
          ? AppThemeColors.rainy.withOpacity(0.08)
          : AppThemeColors.cardbackground,
      borderRadius: BorderRadius.circular(18),
      border: warning
          ? Border.all(
              color: AppThemeColors.rainy.withOpacity(0.3),
              width: 1,
            )
          : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Weather icon ──
        Icon(
          icon,
          color: iconColor,
          size: 30,
        ),

        const SizedBox(width: 14),

        // ── Center content ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day
              Text(
                day,
                style: AppTextStyles.weatherDay,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        // ── Right section ──
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Big Temperature
            Text(
              temperature,
              style: AppTextStyles.weatherDay.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Humidity + Rainfall
              Row(
                children: [
                  _Metric(
                    icon: CupertinoIcons.drop_fill,
                    value: humidity,
                  ),

                  const SizedBox(width: 14),

                  _Metric(
                    icon: CupertinoIcons.cloud_rain_fill,
                    value: rainfall,
                  ),
                ],
              ),

            
          ],
        ),
      ],
    ),
  );
}
}

// ─────────────────────────────────────────
// Small inline metric with icon + value
// ─────────────────────────────────────────
class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Metric({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppThemeColors.textSecondary),
        const SizedBox(width: 3),
        Text(value, style: AppTextStyles.caption),
      ],
    );
  }
}