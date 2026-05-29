import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/environment.services.dart';
import '../../utils/app-localization.utils.dart';
import 'land-analysis.crop.widget.dart';

class AnalysisGrid extends StatefulWidget {
  final double lat;
  final double lon;
  const AnalysisGrid({super.key, required this.lat, required this.lon});

  @override
  State<AnalysisGrid> createState() => _AnalysisGridState();
}

class _AnalysisGridState extends State<AnalysisGrid> {
  final EnvironmentService _service = EnvironmentService();
  bool _isLoading = true;
  String? _errorMessage;
  // ── Parsed values ────────────────────────────────────────────────────────────
  String _nitrogen     = 'Not Available';
  String _phosphorus   = 'Not Available';
  String _potassium    = 'Not Available';
  String _ph           = 'Not Available';
  String _temperature  = 'Not Available';
  String _humidity     = 'Not Available';

  @override
  void initState() {
    super.initState();
    _fetchLandDetails();
  }
  Future<void> _fetchLandDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await _service.getLandDetails(
        lat: widget.lat,
        lon: widget.lon,
      );
      if (result['success'] == true && result['details'] != null) {
        final d = result['details'] as Map<String, dynamic>;
        setState(() {
          _nitrogen    = _fmt(d['N']);
          _phosphorus  = _fmt(d['P']);
          _potassium   = _fmt(d['K']);
          _ph          = _fmt(d['ph']);
          _temperature = _fmtUnit(d['Temperature (°C)'], '°C');
          _humidity    = _fmtUnit(d['Humidity (%)'], '%');
          _isLoading   = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? AppLocalizations.of(context)!.translate("Failed to load land details");
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.translate("Something went wrong");
        _isLoading = false;
      });
    }
  }

  /// Returns 'Not Available' for null, otherwise the value as a plain string.
  String _fmt(dynamic val) =>
      val == null ? 'Not Available' : val.toString();
  /// Returns 'Not Available' for null, otherwise appends the unit.
  /// e.g. _fmtUnit(32.09, '°C') → '32.09°C'
  String _fmtUnit(dynamic val, String unit) =>
      val == null ? 'Not Available' : '${val.toString()}$unit';
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildSkeleton();
    if (_errorMessage != null) return _buildError();
    return _buildGrid();
  }

  Widget _buildSkeleton() {
  return Shimmer.fromColors(
    baseColor: CupertinoColors.systemGrey5,
    highlightColor: CupertinoColors.systemGrey4,
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.02,
      children: List.generate(
        6,
        (_) => Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildError() {
    return Column(
      children: [
        const Icon(
          CupertinoIcons.exclamationmark_circle,
          size: 40,
          color: CupertinoColors.systemRed,
        ),
        const SizedBox(height: 10),
        Text(_errorMessage!, textAlign: TextAlign.center),
        const SizedBox(height: 14),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(40),
          onPressed: _fetchLandDetails,
          child: Text(AppLocalizations.of(context)!.translate("Retry")),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.02,
      children: [
        AnalysisItem(
          backgroundColor: const Color(0xFFE7F0EC),
          iconColor: const Color(0xFF145A32),
          icon: CupertinoIcons.drop_fill,
          title: AppLocalizations.of(context)!.translate("NITROGEN (N)"),
          value: _nitrogen,
          unit: _nitrogen != 'Not Available' ? 'mg/kg' : null,
        ),
        AnalysisItem(
          backgroundColor: const Color(0xFFE9EEF9),
          iconColor: const Color(0xFF1E5EFF),
          icon: CupertinoIcons.drop_fill,
          title: AppLocalizations.of(context)!.translate("PHOSPHORUS (P)"),
          value: _phosphorus,
          unit: _phosphorus != 'Not Available' ? 'mg/kg' : null,
        ),
        AnalysisItem(
          backgroundColor: const Color(0xFFF5EFE8),
          iconColor: const Color(0xFFFF5A00),
          icon: CupertinoIcons.drop_fill,
          title: AppLocalizations.of(context)!.translate("POTASSIUM (K)"),
          value: _potassium,
          unit: _potassium != 'Not Available' ? 'mg/kg' : null,
        ),
        AnalysisItem(
          backgroundColor: const Color(0xFFF5EAF3),
          iconColor: const Color(0xFFE10072),
          icon: CupertinoIcons.speedometer,
          title: AppLocalizations.of(context)!.translate("SOIL PH"),
          value: _ph,
        ),
        AnalysisItem(
          backgroundColor: const Color(0xFFF5EFD7),
          iconColor: const Color(0xFFC98300),
          icon: CupertinoIcons.thermometer,
          title: AppLocalizations.of(context)!.translate("TEMPERATURE"),
          value: _temperature,
        ),
        AnalysisItem(
          backgroundColor: const Color(0xFFE2F4FA),
          iconColor: const Color(0xFF0094C6),
          icon: CupertinoIcons.drop,
          title: AppLocalizations.of(context)!.translate("HUMIDITY"),
          value: _humidity,
        ),
      ],
    );
  }
}