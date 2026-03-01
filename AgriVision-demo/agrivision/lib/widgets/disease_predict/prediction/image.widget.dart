import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../themes/utils/spacing.theme.dart';

class ScanResultCard extends StatelessWidget {
  const ScanResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/farmer.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              CupertinoColors.black.withOpacity(0.6),
              CupertinoColors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppThemeColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '87% MATCH',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Scan Successful',
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
