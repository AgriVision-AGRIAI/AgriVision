import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';

class LocationCard extends StatefulWidget {
  final double lat;
  final double lon;
  const LocationCard({super.key, required this.lat, required this.lon});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
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
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'format': 'jsonv2',
        'addressdetails': '1',
      });
      final response = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'AgriVision/1.0 (contact@agrivision.app)',
              'Accept': 'application/json',
            }, // Nominatim requires a UA
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 403) {
        return 'Location blocked';
      }
      if (response.statusCode != 200) return 'Location unavailable';

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>? ?? {};
      // City fallback chain: city → town → village → county
      final city =
          (address['city'] ??
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              CupertinoIcons.location_solid,
              color: AppThemeColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _locationLabel,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '${widget.lat.toStringAsFixed(4)}° N, ${widget.lon.toStringAsFixed(4)}° E',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
