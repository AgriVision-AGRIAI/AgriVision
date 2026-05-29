import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../utils/app-localization.utils.dart';
import '../../widgets/responsive-base.widget.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../authentication/signin.pages.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../tab-shell.pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
void initState() {
  super.initState();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _controller.forward();
  });

  Timer(const Duration(seconds: 4), () async {
    if (!mounted) return;
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (_, _, _) => token != null ? const MainTabShell() : const LoginScreen(),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  ),
);

  });
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final theme = CupertinoTheme.of(context);

  return CupertinoPageScaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    child: ResponsiveBase(
      child: Column(
        children: [
          const Spacer(flex: 3),
      
          /// 🌿 LOGO
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withOpacity(0.12),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.scaffoldBackgroundColor,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo-transparent.png',
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
      
          const SizedBox(height: AppSpacing.xl),
      
          Text(
            AppLocalizations.of(context)!.translate("AgriVision"),
            style: AppTextStyles.h1.copyWith(
              color: theme.primaryColor,
            ),
          ),
      
          const SizedBox(height: AppSpacing.sm),
      
          Text(
            AppLocalizations.of(context)!.translate("Smart Farming Made Simple"),
            style: AppTextStyles.body.copyWith(
              color: theme.primaryColor.withOpacity(0.9),
            ),
          ),
      
          const Spacer(flex: 3),
      
          Text(
            AppLocalizations.of(context)!.translate("PREPARING YOUR FIELD"),
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.2,
              color: theme.primaryColor.withOpacity(0.9),
            ),
          ),
      
          const SizedBox(height: AppSpacing.sm),
      
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _controller.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      
          const SizedBox(height: AppSpacing.lg),
      
          Text(
            AppLocalizations.of(context)!.translate("✦ Powered by AI Intelligence"),
            style: AppTextStyles.caption.copyWith(
              color: theme.primaryColor.withOpacity(0.9),
            ),
          ),
      
          const SizedBox(height: AppSpacing.sm),
      
          Text(
            AppLocalizations.of(context)!.translate("Farmer’s Friend"),
            style: AppTextStyles.caption.copyWith(
              color: theme.primaryColor.withOpacity(0.9),
            ),
          ),
      
          const Spacer(),
        ],
      ),
    ),
  );
}

}
