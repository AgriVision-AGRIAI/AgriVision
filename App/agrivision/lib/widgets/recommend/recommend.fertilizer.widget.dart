import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';

class RecommendationBottomSheet extends StatelessWidget {
  final String result;
  const RecommendationBottomSheet({super.key, required this.result});

  /// Extracts a numeric value following a bold label in the markdown string.
  /// e.g. "**N (Nitrogen):** 260 mg/kg" → "260"
  String _extract(String nutrient) {
    final patterns = {
      'nitrogen': RegExp(
        r'Nitrogen.*?([0-9]+(?:\.[0-9]+)?)\s*mg/kg',
        caseSensitive: false,
      ),

      'phosphorus': RegExp(
        r'Phosphorus.*?([0-9]+(?:\.[0-9]+)?)\s*mg/kg',
        caseSensitive: false,
      ),

      'potassium': RegExp(
        r'Potassium.*?([0-9]+(?:\.[0-9]+)?)\s*mg/kg',
        caseSensitive: false,
      ),

      'ph': RegExp(r'pH.*?([0-9]+(?:\.[0-9]+)?)', caseSensitive: false),

      'moisture': RegExp(
        r'moisture.*?([0-9]+(?:\.[0-9]+)?%?)',
        caseSensitive: false,
      ),
    };

    final regex = patterns[nutrient.toLowerCase()];

    if (regex == null) return 'N/A';

    final match = regex.firstMatch(result);

    return match?.group(1) ?? 'N/A';
  }

  /// Extracts the NPK ratio e.g. "1:2:2"
  String get _npkRatio {
    final match = RegExp(
      r'([0-9]+-[0-9]+-[0-9]+)',
      caseSensitive: false,
    ).firstMatch(result);

    return match?.group(1) ?? 'N/A';
  }

  /// Extracts the application rate e.g. "100-150 kg/ha"
  String get _rate {
    final match = RegExp(
      r'rate of\s+([\d\-]+\s*kg/ha)',
      caseSensitive: false,
    ).firstMatch(result);
    return match?.group(1)?.trim() ?? 'N/A';
  }

  /// Derives a soil type label based on P and K levels
  String get _soilType {
    final p = double.tryParse(_extract('P (Phosphorus)')) ?? 0;
    final k = double.tryParse(_extract('K (Potassium)')) ?? 0;
    if (p < 60 && k < 60) return 'Low P & K';
    if (p < 60) return 'Low P';
    if (k < 60) return 'Low K';
    return 'Balanced';
  }

  @override
  Widget build(BuildContext context) {
    final nitrogen = _extract('nitrogen');
    final phosphorus = _extract('phosphorus');
    final potassium = _extract('potassium');
    final ph = _extract('ph');
    final moisture = _extract('moisture');
    final npkRatio = _npkRatio;
    final rate = _rate;
    final soilType = _soilType;

    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: Container(
        height: 760,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey4,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate("Recommended Fertilizer Plan"),
                              style: AppTextStyles.h3,
                            ),
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: NutrientCard(
                        title: AppLocalizations.of(context)!.translate("NITROGEN"),
                        value: nitrogen,
                        unit: 'mg/kg',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: NutrientCard(
                        title: AppLocalizations.of(context)!.translate("PHOSPHORUS"),
                        value: phosphorus,
                        unit: 'mg/kg',
                        green: true,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: NutrientCard(
                        title: AppLocalizations.of(context)!.translate("POTASSIUM"),
                        value: potassium,
                        unit: 'mg/kg',
                        green: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: NutrientCard(title: AppLocalizations.of(context)!.translate("PH"), value: ph),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 2,
                      child: NutrientCard(title: AppLocalizations.of(context)!.translate("MOISTURE"), value: moisture),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF5FAF7), Color(0xFFEAF4EE)],
                    ),
                    border: Border.all(color: const Color(0xFFDDE8E1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("RECOMMENDED NPK"),
                        style: AppTextStyles.analysisLabel,
                      ),

                      const SizedBox(height: 10),

                      Text(npkRatio, style: AppTextStyles.npkValue),

                      Container(height: 1, color: const Color(0xFFDCE5DE)),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _BottomInfo(title: AppLocalizations.of(context)!.translate("RATE"), value: rate),
                          ),

                          Expanded(
                            child: _BottomInfo(
                              title: AppLocalizations.of(context)!.translate("SOIL TYPE"),
                              value: AppLocalizations.of(context)!.translate(soilType),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class NutrientCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final bool green;

  const NutrientCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.green = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: BoxDecoration(
        color: green ? const Color(0xFFF1F7F3) : const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),

          const SizedBox(height: 16),

          Text(
            value,
            style: TextStyle(
              color: green
                  ? AppThemeColors.primary
                  : AppThemeColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (unit != null) ...[
            const SizedBox(height: 6),

            Text(unit!, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

class _BottomInfo extends StatelessWidget {
  final String title;
  final String value;

  const _BottomInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.analysisLabel),

        const SizedBox(height: 10),

        Text(value, style: AppTextStyles.bottomInfoValue),
      ],
    );
  }
}
