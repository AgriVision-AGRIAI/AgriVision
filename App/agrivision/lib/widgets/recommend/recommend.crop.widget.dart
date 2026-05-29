import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/recommendation.services.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';

class AIRecommendationCard extends StatefulWidget {
  final double lat;
  final double lon;
  const AIRecommendationCard({super.key, required this.lat, required this.lon});

  @override
  State<AIRecommendationCard> createState() => _AIRecommendationCardState();
}

class _AIRecommendationCardState extends State<AIRecommendationCard> {
  final RecommendationService _service = RecommendationService();
  bool _isLoading = true;
  String? _cropName;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _fetchRecommendation();
  }

  Future<void> _fetchRecommendation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await _service.getCropRecommendation(
        lat: widget.lat,
        lon: widget.lon,
      );
      if (result['success'] == true && result['details'] != null) {
        setState(() {
          _cropName = (result['details'] as String).toLowerCase().trim();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? AppLocalizations.of(context)!.translate("Failed to get recommendation");
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

  /// Converts crop name to a display-friendly title
  /// e.g. "muskmelon" → "Muskmelon", "green gram" → "Green Gram"
  String get _cropDisplayName {
    if (_cropName == null) return '';
    return _cropName!
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  /// Returns the local asset path for the crop image.
  /// Falls back to a placeholder if the asset isn't found.
  String get _cropImagePath {
    if (_cropName == null || _cropName == "muskmelon")
      return 'assets/images/bk.jpg';
    // Normalize: lowercase + replace spaces with underscores
    final normalized = _cropName!.replaceAll(' ', '_');
    return 'assets/images/$normalized.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: _isLoading
          ? _buildSkeleton()
          : _errorMessage != null
          ? _buildError()
          : _buildCard(),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Container(
              height: 245,
              width: double.infinity,
              color: CupertinoColors.systemGrey5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 40,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              color: AppThemeColors.primary,
              borderRadius: BorderRadius.circular(40),
              onPressed: _fetchRecommendation,
              child: Text(AppLocalizations.of(context)!.translate("Retry"), style: AppTextStyles.buttonStyles),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Main Card ───────────────────────────────────────────────────────────────

  Widget _buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: Image.asset(
                _cropImagePath,
                height: 245,
                width: double.infinity,
                fit: BoxFit.cover,
                // Falls back gracefully if the asset file is missing
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 245,
                  width: double.infinity,
                  color: CupertinoColors.systemGrey5,
                  child: const Icon(
                    CupertinoIcons.photo,
                    size: 48,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ),

            // ── Match badge ──────────────────────────────────────────────────
            Positioned(
              right: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.sparkles,
                      size: 16,
                      color: AppThemeColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.translate("95% MATCH"),
                      style: const TextStyle(
                        color: AppThemeColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Crop title ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Text(_cropDisplayName, style: AppTextStyles.cropTitle),
              const Spacer(),
              // Refresh button to re-fetch manually
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _fetchRecommendation,
                child: const Icon(
                  CupertinoIcons.refresh,
                  size: 22,
                  color: AppThemeColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
