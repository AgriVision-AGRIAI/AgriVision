import 'package:flutter/cupertino.dart';

import '../../themes/utils/colors.theme.dart';
import '../../utils/app-localization.utils.dart';

class FertilizerBanner extends StatelessWidget {
  const FertilizerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/bk.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 18,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppThemeColors.primary,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.sparkles,
                    color: CupertinoColors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    AppLocalizations.of(context)!.translate("AI ANALYSIS ACTIVE"),
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}