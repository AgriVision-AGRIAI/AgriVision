import 'package:flutter/cupertino.dart';
import '../../themes/utils/typography.theme.dart';

class WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherMetric({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.h3),
      ],
    );
  }
}
