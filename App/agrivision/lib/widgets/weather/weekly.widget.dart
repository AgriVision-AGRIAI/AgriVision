import 'package:flutter/cupertino.dart';
import '../../services/environment.services.dart';
import '../../utils/app-localization.utils.dart';
import 'weekly-item.widget.dart';
import 'icon.widget.dart';

class WeeklyWeatherList extends StatefulWidget {
  final double lat;
  final double lon;
  const WeeklyWeatherList({super.key, required this.lat, required this.lon});

  @override
  State<WeeklyWeatherList> createState() => _WeeklyWeatherListState();
}

class _WeeklyWeatherListState extends State<WeeklyWeatherList> {
  final EnvironmentService _envService = EnvironmentService();
  bool _isLoading = true;
  List<_DayForecast> _forecast = [];
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ─────────────────────────────────────────
  // Resolve WeatherType from rainfall mm
  // ─────────────────────────────────────────
  WeatherType _resolveType(double rain) {
    if (rain > 0.8) return WeatherType.rainy;
    if (rain > 0.2) return WeatherType.cloudy;
    return WeatherType.sunny;
  }
  // ─────────────────────────────────────────
  // "2026-05-28" → "Thursday"
  // ─────────────────────────────────────────
  String _dayName(String raw) {
    try {
      final date = DateTime.parse(raw);
      final days = [
        AppLocalizations.of(context)!.translate("Monday"), 
        AppLocalizations.of(context)!.translate("Tuesday"), 
        AppLocalizations.of(context)!.translate("Wednesday"),
        AppLocalizations.of(context)!.translate("Thursday"), 
        AppLocalizations.of(context)!.translate("Friday"), 
        AppLocalizations.of(context)!.translate("Saturday"), 
        AppLocalizations.of(context)!.translate("Sunday"),
      ];
      return days[date.weekday - 1];
    } catch (_) {
      return raw;
    }
  }
  Future<void> _fetch() async {
    try {
      final result = await _envService.getWeather(
        lat: widget.lat,
        lon: widget.lon,
      );
      if (result['success'] == true) {
        final list = result['details']['forecast'] as List<dynamic>;
        setState(() {
          _forecast = list.map((item) {
            final map      = item as Map<String, dynamic>;
            final rain     = (map['Total Rainfall (mm)'] as num).toDouble();
            final temp     = (map['Avg Temperature (°C)'] as num).toDouble();
            final humidity = (map['Avg Humidity (%)'] as num).toInt();
            final wind     = (map['Avg Wind Speed (m/s)'] as num).toDouble();
            return _DayForecast(
              day:         _dayName(map['Date'] as String),
              temperature: temp,
              humidity:    humidity,
              rainfall:    rain,
              windSpeed:   wind,
              type:        _resolveType(rain),
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CupertinoActivityIndicator()) : ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _forecast.length,
      itemBuilder: (context, index) {
        final day = _forecast[index];
        return WeeklyWeatherItem(
          day:         day.day,
          temperature: '${day.temperature.toStringAsFixed(1)}°C',
          humidity:    '${day.humidity}%',
          rainfall:    '${day.rainfall.toStringAsFixed(2)} mm',
          type:        day.type,
          warning:     day.type == WeatherType.rainy,
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Internal data model
// ─────────────────────────────────────────
class _DayForecast {
  final String day;
  final double temperature;
  final int humidity;
  final double rainfall;
  final double windSpeed;
  final WeatherType type;
  const _DayForecast({
    required this.day,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.type,
  });
}
