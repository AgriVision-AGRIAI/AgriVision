import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';

class WeatherHeader extends StatefulWidget {
  final double lat;
  final double lon;
  final VoidCallback onRefresh;

  const WeatherHeader({super.key, required this.lat, required this.lon, required this.onRefresh});

  @override
  State<WeatherHeader> createState() => _WeatherHeaderState();
}

class _WeatherHeaderState extends State<WeatherHeader> {
  String _locationLabel = 'Fetching...';
  /// Maps full Indian state names → 2-letter state codes
  static const Map<String, String> _stateCodeMap = {
    'andhra pradesh': 'AP',
    'arunachal pradesh': 'AR',
    'assam': 'AS',
    'bihar': 'BR',
    'chhattisgarh': 'CG',
    'goa': 'GA',
    'gujarat': 'GJ',
    'haryana': 'HR',
    'himachal pradesh': 'HP',
    'jharkhand': 'JH',
    'karnataka': 'KA',
    'kerala': 'KL',
    'madhya pradesh': 'MP',
    'maharashtra': 'MH',
    'manipur': 'MN',
    'meghalaya': 'ML',
    'mizoram': 'MZ',
    'nagaland': 'NL',
    'odisha': 'OD',
    'punjab': 'PB',
    'rajasthan': 'RJ',
    'sikkim': 'SK',
    'tamil nadu': 'TN',
    'telangana': 'TS',
    'tripura': 'TR',
    'uttar pradesh': 'UP',
    'uttarakhand': 'UK',
    'west bengal': 'WB',
    'delhi': 'DL',
    'jammu and kashmir': 'JK',
    'ladakh': 'LA',
    'puducherry': 'PY',
    'chandigarh': 'CH',
    'andaman and nicobar islands': 'AN',
    'dadra and nagar haveli and daman and diu': 'DN',
    'lakshadweep': 'LD',
  };
  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final label = await _reverseGeocode(widget.lat, widget.lon);
      if (mounted) setState(() => _locationLabel = label);
    } catch (e) {
      if (mounted) setState(() => _locationLabel = 'Location unavailable');
    }
  }

  /// Calls Nominatim reverse-geocode and returns "City, ST" format.
  Future<String> _reverseGeocode(double lat, double lon) async {
    try {
    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'format': 'jsonv2',
        'addressdetails': '1',
      },
    );
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'AgriVision/1.0 (contact@agrivision.app)',
        'Accept': 'application/json',},   // Nominatim requires a UA
    ).timeout(
      const Duration(seconds: 10),
    );
    if (response.statusCode == 403) {
      return 'Location blocked';
    }
    if (response.statusCode != 200) return 'Location unavailable';

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final address = data['address'] as Map<String, dynamic>? ?? {};
    // City fallback chain: city → town → village → county
    final city = (address['city'] ??
            address['town'] ??
            address['village'] ??
            address['county'] ??
            'Unknown')
        as String;
    final rawState = ((address['state'] ?? '') as String).toLowerCase();
    final stateCode = _stateCodeMap[rawState] ?? rawState.toUpperCase();
    return '$city, $stateCode';
    } catch (e) {
    print('Reverse geocode Location | error: $e');
    return 'Location unavailable';
  }
  }
  
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
          children: [
            Text(
              AppLocalizations.of(context)!.translate("CURRENT LOCATION"),
              style: AppTextStyles.weather_h2
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(CupertinoIcons.location_solid,
                    size: 14, color: AppThemeColors.success),
                const SizedBox(width: 4),
                Text(_locationLabel, style: AppTextStyles.h3),
              ],
            ),
          ],
        ),
        const Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await _fetchLocation();
            widget.onRefresh();
          },
          child: const Icon(CupertinoIcons.refresh, size: 28, fill: 1),
        ),
      ],
    );
  }
}
