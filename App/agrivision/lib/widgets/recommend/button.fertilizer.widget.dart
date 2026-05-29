import 'package:flutter/cupertino.dart';

import '../../utils/app-localization.utils.dart';

class FertilizerButton extends StatelessWidget {
  final VoidCallback onTap;

  const FertilizerButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3E7B57),
              Color(0xFF78B18F),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E7B57).withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.sparkles,
              color: CupertinoColors.white,
              size: 28,
            ),

            const SizedBox(width: 14),

            Text(
              AppLocalizations.of(context)!.translate("Generate Fertilizer Plan"),
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}