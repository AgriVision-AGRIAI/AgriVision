import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../widgets/profile/avatar.widget.dart';
import '../../widgets/profile/language-selector.widget.dart';
import '../../widgets/profile/setting-tile.widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Profile',
          style: AppTextStyles.h2,
        ),
        automaticallyImplyLeading: false, // ❌ no back button
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ResponsiveBase(
            child: Column(
              children: const [
                SizedBox(height: AppSpacing.lg),
            
                /// 👤 PROFILE
                ProfileAvatar(),
            
                SizedBox(height: AppSpacing.xl),
            
                /// 🌐 LANGUAGE
                LanguageSelector(),
            
                SizedBox(height: AppSpacing.xl),
            
                /// 🚪 LOGOUT
                SettingTile(
                  icon: CupertinoIcons.arrow_right_square,
                  iconBg: AppThemeColors.logoutbg,
                  title: 'Logout from Account',
                  titleColor: AppThemeColors.error,
                  centerTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
