import 'package:flutter/cupertino.dart';
import '../../services/environment.services.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import 'metric.widget.dart';
import 'icon.widget.dart';

class TodayWeatherCard extends StatefulWidget {
  final double lat;
  final double lon;
  const TodayWeatherCard({super.key, required this.lat, required this.lon});

  @override
  State<TodayWeatherCard> createState() => _TodayWeatherCardState();
}

class _TodayWeatherCardState extends State<TodayWeatherCard> {
  final EnvironmentService _envService = EnvironmentService();
  bool _isLoading = true;
  String? _error;
  double? _temperature;
  int? _humidity;
  double? _rainfall;
  double? _windSpeed;
  String? _dateLabel; // e.g. "TODAY – MAY 27"
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ─────────────────────────────────────────
  // Resolve WeatherType from rainfall mm
  // ─────────────────────────────────────────
  WeatherType _resolveType(double rain) {
    if (rain > 1.0) return WeatherType.rainy;
    if (rain > 0.2) return WeatherType.cloudy;
    return WeatherType.sunny;
  }
  String _weatherLabel(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return AppLocalizations.of(context)!.translate("Mostly Sunny");
      case WeatherType.cloudy:
        return AppLocalizations.of(context)!.translate("Partly Cloudy");
      case WeatherType.rainy:
        return AppLocalizations.of(context)!.translate("Rainy");
    }
  }
  // ─────────────────────────────────────────
  // Format "2026-05-27" → "TODAY – MAY 27"
  // ─────────────────────────────────────────
  String _formatDate(String raw) {
    const months = [
      '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final parts = raw.split('-');
    if (parts.length < 3) return raw;
    final month = int.tryParse(parts[1]) ?? 0;
    final day = int.tryParse(parts[2]) ?? 0;
    return AppLocalizations.of(context)!.translate("TODAY")+' – ${months[month]} $day';
  }
  Future<void> _fetch() async {
    try {
      final result = await _envService.getTodayWeather(
        lat: widget.lat,
        lon: widget.lon,
      );
      if (result['success'] == true) {
        final today = result['details']['today'] as Map<String, dynamic>;
        setState(() {
          _temperature = (today['Temperature (°C)'] as num).toDouble();
          _humidity    = (today['Humidity (%)'] as num).toInt();
          _rainfall    = (today['Rainfall (mm)'] as num).toDouble();
          _windSpeed   = (today['Wind Speed (m/s)'] as num).toDouble();
          _dateLabel   = _formatDate(today['Date'] as String);
          _isLoading   = false;
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _error     = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CupertinoActivityIndicator(),
              ),
            )
          : _error != null
              ? _buildError()
              : _buildData(),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(AppLocalizations.of(context)!.translate("Unable to load weather"), style: AppTextStyles.body),
      ),
    );
  }
 
  Widget _buildData() {
    final type        = _resolveType(_rainfall!);
    final icon        = WeatherIconUtil.getIcon(type);
    final iconColor   = WeatherIconUtil.getColor(type);
    final description = _weatherLabel(type);
 
    return Column(
      children: [
        // ── Top row: date / temp / icon ──
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_dateLabel ?? '', style: AppTextStyles.weather_h2),
                const SizedBox(height: 6),
                Text(
                  '${_temperature!.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    color: AppThemeColors.textPrimary,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description, style: AppTextStyles.body),
              ],
            ),
            const Spacer(),
            Icon(icon, size: 48, color: iconColor),
          ],
        ),
 
        const SizedBox(height: 16),
 
        // ── Metrics row ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WeatherMetric(
              icon: CupertinoIcons.drop_fill,
              label: AppLocalizations.of(context)!.translate("Humidity"),
              value: '$_humidity%',
            ),
            WeatherMetric(
              icon: CupertinoIcons.wind,
              label: AppLocalizations.of(context)!.translate("Wind"),
              value: '${_windSpeed!.toStringAsFixed(1)} m/s',
            ),
            WeatherMetric(
              icon: CupertinoIcons.cloud_rain_fill,
              label: AppLocalizations.of(context)!.translate("Rainfall"),
              value: '${_rainfall!.toStringAsFixed(2)} mm',
            ),
          ],
        ),
 
        const SizedBox(height: 16),
      ],
    );
  }
}
