import 'package:agrivision/utils/crop-prediction.utils.dart';
import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/typography.theme.dart';
import '../../../utils/app-localization.utils.dart';

class SymptomsList extends StatefulWidget {
  final List<CropSymptoms> data;
  const SymptomsList({super.key, required this.data});

  @override
  State<SymptomsList> createState() => _SymptomsListState();
}

class _SymptomsListState extends State<SymptomsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.translate("Key Symptoms"), style: AppTextStyles.h3),
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.translate("FIELD GUIDE"),
              style: const TextStyle(
                fontSize: 12,
                color: AppThemeColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        ...widget.data.asMap().entries.map((entry) {
          final int index = entry.key;
          final symptom = entry.value;
          return _symptomItem(
            icon: symptomIcons[index % symptomIcons.length],
            title: symptom.title,
            description: symptom.description,
          );
        }).toList(),
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
