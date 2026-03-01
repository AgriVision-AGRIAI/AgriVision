import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/typography.theme.dart';

class HomeWeatherCard extends StatelessWidget {
  const HomeWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'LIVE UPDATE',
                  style: TextStyle(
                    color: AppThemeColors.success,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(CupertinoIcons.sun_max, color: AppThemeColors.warning),
                    SizedBox(width: 8),
                    Text('28°C', style: AppTextStyles.h1),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Sunny • Humidity 45%',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/farmer.png',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
