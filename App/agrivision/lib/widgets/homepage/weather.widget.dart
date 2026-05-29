import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/typography.theme.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/environment.services.dart';
import '../../utils/app-localization.utils.dart';
import '../weather/icon.widget.dart';

class HomeWeatherCard extends StatefulWidget {
  const HomeWeatherCard({super.key});

  @override
  State<HomeWeatherCard> createState() => _HomeWeatherCardState();
}

class _HomeWeatherCardState extends State<HomeWeatherCard> {
  final EnvironmentService _envService = EnvironmentService();
  bool _isLoading = true;
  String? _error;
  // Parsed weather fields
  double? _temperature;
  int? _humidity;
  double? _rainfall;
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // ─────────────────────────────────────────
  // Determine WeatherType from rainfall mm
  // ─────────────────────────────────────────
  WeatherType _resolveWeatherType() {
    final rain = _rainfall ?? 0;
    if (rain > 0.8) return WeatherType.rainy;
    if (rain > 0.2) return WeatherType.cloudy;
    return WeatherType.sunny;
  }
  String _weatherLabel(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return 'SUNNY';
      case WeatherType.cloudy:
        return 'CLOUDY';
      case WeatherType.rainy:
        return 'RAINY';
    }
  }


  // ─────────────────────────────────────────
  // Fetch location → call weather API
  // ─────────────────────────────────────────
  Future<void> _fetchWeather() async {
    try {
      // 1. Get device location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied.');
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      // 2. Call weather service
      final result = await _envService.getTodayWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
      if (result['success'] == true) {
        final today = result['details']['today'] as Map<String, dynamic>;
        setState(() {
          _temperature = (today['Temperature (°C)'] as num).toDouble();
          _humidity    = (today['Humidity (%)'] as num).toInt();
          _rainfall    = (today['Rainfall (mm)'] as num).toDouble();
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildContent(),
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

  Widget _buildContent() {
 
    // ── Loading state ──
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CupertinoActivityIndicator(),
      );
    }
    // ── Error state ──
    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("LIVE UPDATE"),
            style: const TextStyle(
              color: AppThemeColors.success,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.translate("Unable to load weather"),
            style: AppTextStyles.body,
          ),
        ],
      );
    }
    // ── Data state ──
    final weatherType = _resolveWeatherType();
    final icon        = WeatherIconUtil.getIcon(weatherType);
    final iconColor   = WeatherIconUtil.getColor(weatherType);
    final label       = _weatherLabel(weatherType);
    final tempDisplay = '${_temperature!.toStringAsFixed(1)}°C';
    final statusLine  = AppLocalizations.of(context)!.translate(label)+' | '+AppLocalizations.of(context)!.translate("Humidity")+' $_humidity%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("LIVE UPDATE"),
          style: const TextStyle(
            color: AppThemeColors.success,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(tempDisplay, style: AppTextStyles.h1),
          ],
        ),
        const SizedBox(height: 4),
        Text(statusLine, style: AppTextStyles.body),
      ],
    );
  }
}


