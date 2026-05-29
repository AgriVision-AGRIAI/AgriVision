import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';

class DiseaseDetectedCard extends StatefulWidget {
  final String name;
  const DiseaseDetectedCard({super.key, required this.name});

  @override
  State<DiseaseDetectedCard> createState() => _DiseaseDetectedCardState();
}

class _DiseaseDetectedCardState extends State<DiseaseDetectedCard> {
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
              children: [
                Text(
                  widget.name,
                  style: AppTextStyles.h3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
