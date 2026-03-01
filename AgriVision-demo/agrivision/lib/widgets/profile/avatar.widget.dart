import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/images/farmer.png'),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppThemeColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.check_mark,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Ramesh Kumar',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 4),
        const Text(
          'Verified Farmer • Oct 2023',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
