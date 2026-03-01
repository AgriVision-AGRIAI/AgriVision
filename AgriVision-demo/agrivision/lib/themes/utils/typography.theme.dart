import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:flutter/cupertino.dart';

class AppTextStyles {
  static const h1 = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const title = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const weather_h2 = TextStyle(
    fontSize: 12,
    letterSpacing: 1,
    fontWeight: FontWeight.w400,
    color: AppThemeColors.textPrimary,
  );

  static const buttonStyles = TextStyle(
    color: AppThemeColors.textButton,
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const h2 = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const h3 = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const body = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 16,
    height: 1.6,
  );

  static const caption = TextStyle(
    color: AppThemeColors.textPrimary,
    fontSize: 12,
    height: 1.4,
  );
}
