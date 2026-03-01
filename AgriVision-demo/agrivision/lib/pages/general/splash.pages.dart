import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../widgets/responsive-base.widget.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../authentication/signin.pages.dart';

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

  Timer(const Duration(seconds: 4), () {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (_, _, _) => const LoginScreen(),
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
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                ),
                child: const Icon(
                  CupertinoIcons.leaf_arrow_circlepath,
                  color: CupertinoColors.white,
                  size: 36,
                ),
              ),
            ),
          ),
      
          const SizedBox(height: AppSpacing.xl),
      
          Text(
            'KrushiMitra',
            style: AppTextStyles.h1.copyWith(
              color: theme.primaryColor,
            ),
          ),
      
          const SizedBox(height: AppSpacing.sm),
      
          Text(
            'Smart Farming Made Simple',
            style: AppTextStyles.body.copyWith(
              color: theme.primaryColor.withOpacity(0.7),
            ),
          ),
      
          const Spacer(flex: 3),
      
          Text(
            'PREPARING YOUR FIELD',
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.2,
              color: theme.primaryColor.withOpacity(0.6),
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
            '✦ Powered by AI Intelligence',
            style: AppTextStyles.caption.copyWith(
              color: theme.primaryColor.withOpacity(0.5),
            ),
          ),
      
          const SizedBox(height: AppSpacing.sm),
      
          Text(
            'v2.4.0 • Farmer’s Friend',
            style: AppTextStyles.caption.copyWith(
              color: theme.primaryColor.withOpacity(0.4),
            ),
          ),
      
          const Spacer(),
        ],
      ),
    ),
  );
}

}
