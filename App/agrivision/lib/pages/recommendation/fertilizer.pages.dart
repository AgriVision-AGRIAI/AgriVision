import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:agrivision/themes/utils/spacing.theme.dart';
import 'package:agrivision/themes/utils/typography.theme.dart';
import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/recommendation.services.dart';
import '../../utils/app-localization.utils.dart';
import '../../widgets/recommend/banner.fertilizer.widget.dart';
import '../../widgets/recommend/button.fertilizer.widget.dart';
import '../../widgets/recommend/header.fertilizer.widget.dart';
import '../../widgets/recommend/recommend.fertilizer.widget.dart';
import '../../widgets/recommend/selection-card.fertilizer.widget.dart';

class FertilizerRecommendPage extends StatefulWidget {
  const FertilizerRecommendPage({super.key});

  @override
  State<FertilizerRecommendPage> createState() => _FertilizerRecommendPageState();
}

class _FertilizerRecommendPageState extends State<FertilizerRecommendPage> {
  final RecommendationService _service = RecommendationService();
  double? _lat;
  double? _lon;
  // Defaults to first crop in the list
  // ignore: unused_field
  CropOption _selectedCrop = kCropOptions.first;

  bool _isGenerating = false;
  String? _generateError;

  // ignore: unused_field
  String? _error;

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
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
  Future<void> _generatePlan() async {
    // Guard: need location
    if (_lat == null || _lon == null) {
      setState(() => _generateError = AppLocalizations.of(context)!.translate("Location not available yet. Please wait."));
      return;
    }

    setState(() {
      _isGenerating = true;
      _generateError = null;
    });

    try {
      final result = await _service.getFertilizerRecommendation(
        lat: _lat!,
        lon: _lon!,
        crop: _selectedCrop.name.toLowerCase(), // API expects lowercase
      );

      if (!mounted) return;

      setState(() => _isGenerating = false);

      if (result['success'] == true) {
        // Pass result to the bottom sheet
        showCupertinoModalPopup(
          context: context,
          barrierColor: CupertinoColors.black.withOpacity(0.35),
          builder: (_) => RecommendationBottomSheet(
            result: result['details'],
          ),
        );
      } else {
        setState(() =>
            _generateError = result['message'] ?? AppLocalizations.of(context)!.translate("Failed to generate plan"));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _generateError = AppLocalizations.of(context)!.translate("Something went wrong. Please try again.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: ResponsiveBase(
            child: Column(
              children: [
                const FertilizerHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                  
                        const FertilizerBanner(),
                  
                        const SizedBox(height: 28),
                  
                        FertilizerSelectionCard(
                          selectedCrop: _selectedCrop,
                          onCropChanged: (crop) =>
                              setState(() => _selectedCrop = crop),
                        ),
                  
                        const SizedBox(height: 36),
                  
                        if (_generateError != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  color: CupertinoColors.systemRed,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _generateError!,
                                    style: const TextStyle(
                                      color: CupertinoColors.systemRed,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ── Generate button ───────────────────────────────────
                        _isGenerating
                            ? Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 28),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF3E7B57),
                                      Color(0xFF78B18F),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: CupertinoActivityIndicator(
                                    color: CupertinoColors.white,
                                    radius: 14,
                                  ),
                                ),
                              )
                            : FertilizerButton(onTap: _generatePlan),
                  
                        const SizedBox(height: 22),
                  
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate("Analysis takes approximately 5-10 seconds"),
                            style: AppTextStyles.captionLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}