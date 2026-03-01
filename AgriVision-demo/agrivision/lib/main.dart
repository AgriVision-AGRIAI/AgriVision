import 'package:agrivision/pages/general/splash.pages.dart';
import 'package:agrivision/themes/light.theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/dark.theme.dart';
import 'themes/provider.theme.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      // 🔥 ADD THESE 3 LINES
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      
      home: SplashScreen(),
      theme: themeProvider.isDark ? darkMode : lightMode,
    );
  }
}