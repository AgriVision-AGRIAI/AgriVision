import 'package:flutter/cupertino.dart';

import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';

class CropRecommendHeader extends StatelessWidget {
  const CropRecommendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.back,
              color: AppThemeColors.primary,
              size: 32,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Crop Recommendation"),
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}