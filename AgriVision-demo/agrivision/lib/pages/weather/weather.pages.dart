import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/utils/typography.theme.dart';
import '../../widgets/weather/header.widget.dart';
import '../../widgets/weather/today.widget.dart';
import '../../widgets/weather/weekly.widget.dart';


class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ResponsiveBase(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                WeatherHeader(),
                    
                SizedBox(height: 16),
                    
                TodayWeatherCard(),
                    
                SizedBox(height: 24),
                    
                Text(
                  'Next 7 Days',
                  style: AppTextStyles.h2,
                ),
                    
                SizedBox(height: 12),
                    
                /// ✅ SCROLLABLE AREA
                Expanded(
                  child: WeeklyWeatherList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
