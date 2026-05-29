import 'package:flutter/cupertino.dart';

import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';


class CropOption {
  final String name;
  final String imagePath;
  const CropOption({required this.name, required this.imagePath});
}
const List<CropOption> kCropOptions = [
  CropOption(name: 'Barley',     imagePath: 'assets/images/barley.jpg'),
  CropOption(name: 'Cotton',     imagePath: 'assets/images/cotton.jpg'),
  CropOption(name: 'Maize',      imagePath: 'assets/images/maize.jpg'),
  CropOption(name: 'Mustard',    imagePath: 'assets/images/mustard.jpg'),
  CropOption(name: 'Potato',     imagePath: 'assets/images/potato.jpg'),
  CropOption(name: 'Rice',       imagePath: 'assets/images/rice.jpg'),
  CropOption(name: 'Soyabean',   imagePath: 'assets/images/soyabean.jpg'),
  CropOption(name: 'Sugarcane',  imagePath: 'assets/images/sugarcane.jpg'),
  CropOption(name: 'Tomato',     imagePath: 'assets/images/tomato.jpg'),
  CropOption(name: 'Wheat',      imagePath: 'assets/images/wheat.jpg'),
];


class FertilizerSelectionCard extends StatelessWidget {
  final CropOption selectedCrop;
  final ValueChanged<CropOption> onCropChanged;
  const FertilizerSelectionCard({super.key, required this.selectedCrop, required this.onCropChanged,});

  void _showPicker(BuildContext context) {
    int tempIndex = kCropOptions.indexOf(selectedCrop);
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Done bar ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Select Crop"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onCropChanged(kCropOptions[tempIndex]);
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate("Done"),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            // ── Picker ────────────────────────────────────────────────────────
            SizedBox(
              height: 260,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: tempIndex,
                ),
                itemExtent: 64,
                onSelectedItemChanged: (i) => tempIndex = i,
                children: kCropOptions.map((crop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          crop.imagePath,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: CupertinoColors.systemGrey5,
                            child: const Icon(CupertinoIcons.photo, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppLocalizations.of(context)!.translate(crop.name),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.label,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("Select Crop"),
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: AppSpacing.lg),

          GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFD3DAD5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        selectedCrop.imagePath,
                        width: 58,
                      height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                        width: 58,
                        height: 48,
                        color: CupertinoColors.systemGrey5,
                        child: const Icon(CupertinoIcons.photo),
                      ),
                      ),
                    ),
                  ),
            
                  const SizedBox(width: 16),
            
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate(selectedCrop.name),
                      style: AppTextStyles.headerCaption,
                    ),
                  ),
            
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: AppThemeColors.primary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  CupertinoIcons.info_circle,
                  size: 24,
                  color: AppThemeColors.textPrimary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.translate("Choose the crop to generate a fertilizer treatment plan."),
                  style: AppTextStyles.captionLarge.copyWith(
                    fontSize:12
                  )
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

// ignore: unused_element
class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.analysisLabel,
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: AppTextStyles.infoBoxValue,
          ),
        ],
      ),
    );
  }
}