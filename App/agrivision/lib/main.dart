import 'package:agrivision/pages/general/splash.pages.dart';
import 'package:agrivision/themes/light.theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/tab-shell.pages.dart';
import 'utils/app-localization.utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/language.utils.dart';
import 'themes/dark.theme.dart';
import 'themes/provider.theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.selectedLocale,
      supportedLocales: LanguageProvider.supportedLocales,
      // 🔥 ADD THESE 3 LINES
      localizationsDelegates: const [
        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(),
      routes: {
        '/home': (context) => const MainTabShell(),
        '/splash': (context) => const SplashScreen(),
      },
      theme: themeProvider.isDark ? darkMode : lightMode,
    );
  }
}
