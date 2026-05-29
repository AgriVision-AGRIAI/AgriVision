import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';
import '../../../utils/app-localization.utils.dart';

class TreatmentPlanCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const TreatmentPlanCard({super.key, required this.data});

  @override
  State<TreatmentPlanCard> createState() => _TreatmentPlanCardState();
}

class _TreatmentPlanCardState extends State<TreatmentPlanCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.translate("Treatment Plan"), style: AppTextStyles.h3),
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
                children: [
                  const Icon(CupertinoIcons.drop, color: AppThemeColors.success),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.translate("RECOMMENDED SPRAY"),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.data['spray_name']?.toString() ?? 'N/A',
                style: AppTextStyles.h3,
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(
                    icon: CupertinoIcons.drop_fill,
                    title: AppLocalizations.of(context)!.translate("DOSAGE"),
                    value: widget.data['dosage']?.toString() ?? 'N/A'
                  ),
                  _InfoItem(
                    icon: CupertinoIcons.calendar,
                    title: AppLocalizations.of(context)!.translate("FREQUENCY"),
                    value: widget.data['frequency'] != null ? AppLocalizations.of(context)!.translate("frequency_table", params: {
                      "frequency": widget.data['frequency']
                    } ): 'N/A'
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
