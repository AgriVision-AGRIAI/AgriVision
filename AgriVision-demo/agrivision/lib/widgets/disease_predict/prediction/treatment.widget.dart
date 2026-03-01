import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';

class TreatmentPlanCard extends StatelessWidget {
  const TreatmentPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Treatment Plan', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppThemeColors.cardbackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(CupertinoIcons.drop, color: AppThemeColors.success),
                  SizedBox(width: 8),
                  Text(
                    'RECOMMENDED SPRAY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Copper Fungicide XL',
                style: AppTextStyles.h3,
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _InfoItem(
                    icon: CupertinoIcons.drop_fill,
                    title: 'DOSAGE',
                    value: '2ml / 1L water',
                  ),
                  _InfoItem(
                    icon: CupertinoIcons.calendar,
                    title: 'FREQUENCY',
                    value: 'Every 7 Days',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppThemeColors.success),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppThemeColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
