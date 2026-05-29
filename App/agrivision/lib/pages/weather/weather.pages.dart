import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../widgets/weather/header.widget.dart';
import '../../widgets/weather/today.widget.dart';
import '../../widgets/weather/weekly.widget.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // ignore: unused_field
  int _refreshKey = 0;

  double? _lat;
  double? _lon;

  bool _loading = true;
  String? _error;

  void _refreshPage() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        _lat = pos.latitude;
        _lon = pos.longitude;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    if (_loading) {
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    if (_error != null) {
      return CupertinoPageScaffold(
        child: Center(
          child: Text(_error!),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ResponsiveBase(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeatherHeader(lat: _lat!, lon: _lon!, onRefresh: _refreshPage),
                    
                const SizedBox(height: 16),
                    
                TodayWeatherCard(lat: _lat!, lon: _lon!),
                    
                const SizedBox(height: 24),
                    
                Text(
                  AppLocalizations.of(context)!.translate("Next 7 Days"),
                  style: AppTextStyles.h2,
                ),
                    
                const SizedBox(height: 12),
                    
                /// ✅ SCROLLABLE AREA
                Expanded(
                  child: WeeklyWeatherList(lat: _lat!, lon: _lon!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
