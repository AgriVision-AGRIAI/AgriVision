import 'package:flutter/cupertino.dart';

import '../../../themes/utils/colors.theme.dart';

class ScanFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppThemeColors.success,
          width: 3,
        ),
      ),
    );
  }
}
