import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';

class SymptomsList extends StatelessWidget {
  const SymptomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('Key Symptoms', style: AppTextStyles.h3),
            Spacer(),
            Text(
              'FIELD GUIDE',
              style: TextStyle(
                fontSize: 12,
                color: AppThemeColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _symptomItem(
          icon: CupertinoIcons.circle_grid_hex,
          title: 'Brown Spots',
          description: 'Circular dark spots with yellow halos',
        ),

        _symptomItem(
          icon: CupertinoIcons.cloud_rain,
          title: 'White Mold',
          description: 'Fuzzy growth on the leaf underside',
        ),
      ],
    );
  }

  Widget _symptomItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppThemeColors.cardbackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemeColors.success),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
