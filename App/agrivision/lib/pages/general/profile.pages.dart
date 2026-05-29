import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import '../../services/auth.services.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../widgets/profile/avatar.widget.dart';
import '../../widgets/profile/language-selector.widget.dart';
import '../../widgets/profile/setting-tile.widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ─────────────────────────────────────────
  // Logout handler
  // ─────────────────────────────────────────
  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog before logging out
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("Logout")),
        content: Text(
          AppLocalizations.of(
            context,
          )!.translate("Are you sure you want to logout?"),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context)!.translate("Cancel")),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context)!.translate("Logout")),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authService = AuthService();
      await authService.logout(); // clears token from secure storage

      if (!context.mounted) return;

      // Reset the language selection back to default on logout (optional)
      // await context.read<LanguageProvider>().changeLanguage(const Locale('en', 'US'));

      // Navigate to login and clear the navigation stack
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/splash', // adjust to your named route
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("ERROR")),
          content: Text('Logout failed: $e'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.translate("OK")),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context)!.translate("Profile"),
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
              children: [
                const SizedBox(height: AppSpacing.lg),

                /// 👤 PROFILE
                const ProfileAvatar(),

                const SizedBox(height: AppSpacing.xl),

                /// 🌐 LANGUAGE
                const LanguageSelector(),

                const SizedBox(height: AppSpacing.xl),

                /// 🚪 LOGOUT
                GestureDetector(
                  onTap: () => _handleLogout(context),
                  child: SettingTile(
                    icon: CupertinoIcons.arrow_right_square,
                    iconBg: AppThemeColors.logoutbg,
                    title: AppLocalizations.of(
                      context,
                    )!.translate("Logout from Account"),
                    titleColor: AppThemeColors.error,
                    centerTitle: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
