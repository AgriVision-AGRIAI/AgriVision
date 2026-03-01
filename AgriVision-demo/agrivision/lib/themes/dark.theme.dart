
import 'package:flutter/cupertino.dart';
import 'utils/colors.theme.dart';

final darkMode = const CupertinoThemeData(
  brightness: Brightness.light,

  primaryColor: AppThemeColors.primary,
  scaffoldBackgroundColor: AppThemeColors.background,
  barBackgroundColor: AppThemeColors.surface,

  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      fontSize: 14,
      height: 1.6,
      fontFamily: 'Roboto',
      color: AppThemeColors.textPrimary,
    ),
    navTitleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Roboto',
      color: AppThemeColors.textPrimary,
    ),
    navLargeTitleTextStyle: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
      color: AppThemeColors.textPrimary,
    ),
  ),
);
