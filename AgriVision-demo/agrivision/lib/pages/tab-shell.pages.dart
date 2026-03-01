import 'package:agrivision/pages/general/profile.pages.dart';
import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import 'general/home.pages.dart';
import '../../widgets/homepage/navigation.widget.dart';

class MainTabShell extends StatefulWidget {
  const MainTabShell({super.key});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  int _currentIndex = 0;

  void onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          /// 🔹 TAB CONTENT (NO ANIMATION)
          IndexedStack(
            index: _currentIndex,
            children: const [
              HomeScreen(),
              SizedBox(), // placeholder for Scan
              ProfileScreen(),
            ],
          ),

          /// 🔽 BOTTOM NAV
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ResponsiveBase(
              child: HomeBottomNav(
                currentIndex: _currentIndex,
                onTabChanged: onTabChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
