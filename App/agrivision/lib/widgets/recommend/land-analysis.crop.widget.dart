import 'package:flutter/cupertino.dart';

import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';

class AnalysisItem extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String value;
  final String? unit;

  const AnalysisItem({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CupertinoColors.systemGrey5,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 32,
          ),

          const Spacer(),

          Text(
            title,
            style: AppTextStyles.analysisLabel,
          ),

          const SizedBox(height: 6),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.analysisValue,
                ),
              ),

              if (unit != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    unit!,
                    style: AppTextStyles.analysisUnit,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}