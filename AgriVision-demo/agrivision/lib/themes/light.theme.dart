import 'package:flutter/cupertino.dart';
import 'utils/colors.theme.dart';

final CupertinoThemeData lightMode = CupertinoThemeData(
  brightness: Brightness.light,

  primaryColor: AppThemeColors.primary,
  scaffoldBackgroundColor: AppThemeColors.background,
  barBackgroundColor: AppThemeColors.surface,

  textTheme: const CupertinoTextThemeData(
    textStyle: TextStyle(
      fontSize: 14,
      height: 1.6,
      fontFamily: 'Roboto',
      color: AppThemeColors.textPrimary,
    ),
    navTitleTextStyle: TextStyle(
      fontSize: 18,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      color: AppThemeColors.textPrimary,
    ),
    navLargeTitleTextStyle: TextStyle(
      fontSize: 32,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      color: AppThemeColors.textPrimary,
    ),
  ),
);

