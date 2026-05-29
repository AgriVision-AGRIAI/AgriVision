import 'package:flutter/cupertino.dart';

import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';

class FertilizerHeader extends StatelessWidget {
  const FertilizerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.back,
              color: AppThemeColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Fertilizer Recommendation"),
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