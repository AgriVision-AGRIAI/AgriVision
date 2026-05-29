import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../utils/language.utils.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final currentLocale = languageProvider.selectedLocale;
    final languages = LanguageProvider.supportedLanguages;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.globe,
                color: AppThemeColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.translate("App Language"),
                style: AppTextStyles.h3,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          ...List.generate(
            (languages.length / 2).ceil(),
            (rowIndex) {
              final leftIndex = rowIndex * 2;
              final rightIndex = leftIndex + 1;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    // Left tile
                    Expanded(
                      child: _LanguageTile(
                        label: languages[leftIndex]['name'] as String,
                        locale:
                            languages[leftIndex]['locale'] as Locale,
                        isSelected:
                            currentLocale.languageCode ==
                                (languages[leftIndex]['locale']
                                        as Locale)
                                    .languageCode,
                        onTap: () {
                          languageProvider.changeLanguage(
                            languages[leftIndex]['locale']
                                as Locale,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    // Right tile
                    rightIndex < languages.length
                        ? Expanded(
                            child: _LanguageTile(
                              label: languages[rightIndex]['name']
                                  as String,
                              locale:
                                  languages[rightIndex]['locale']
                                      as Locale,
                              isSelected:
                                  currentLocale.languageCode ==
                                      (languages[rightIndex]
                                                  ['locale']
                                              as Locale)
                                          .languageCode,
                              onTap: () {
                                languageProvider.changeLanguage(
                                  languages[rightIndex]
                                      ['locale'] as Locale,
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: SizedBox(),
                          ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Individual language tile
// ─────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final String label;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemeColors.success
              : AppThemeColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w600,
                  )
                : AppTextStyles.body,
          ),
        ),
      ),
    );
  }
}