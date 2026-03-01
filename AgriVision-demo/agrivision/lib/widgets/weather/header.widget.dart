import 'package:flutter/cupertino.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/typography.theme.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, size: 28, fill: 1),
        ),
        const Spacer(),
        Column(
          children: const [
            Text(
              'CURRENT LOCATION',
              style: AppTextStyles.weather_h2
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(CupertinoIcons.location_solid,
                    size: 14, color: AppThemeColors.success),
                SizedBox(width: 4),
                Text('Nashik, MH', style: AppTextStyles.h3),
              ],
            ),
          ],
        ),
        const Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: const Icon(CupertinoIcons.refresh, size: 28, fill: 1),
        ),
      ],
    );
  }
}
