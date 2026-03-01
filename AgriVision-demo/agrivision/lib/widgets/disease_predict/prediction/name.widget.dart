import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';

class DiseaseDetectedCard extends StatelessWidget {
  const DiseaseDetectedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppThemeColors.weatherbackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: AppThemeColors.warning,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Late Blight Detected',
                  style: AppTextStyles.h3,
                ),
                SizedBox(height: 6),
                Text(
                  'Commonly affects potato and tomato crops during wet seasons.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
