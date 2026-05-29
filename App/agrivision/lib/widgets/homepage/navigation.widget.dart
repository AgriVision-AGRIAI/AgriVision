import 'package:flutter/cupertino.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../pages/disease_predict/scan.pages.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  void _onScanTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CropScannerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomInset > 0 ? bottomInset : 16,
      ),
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: AppThemeColors.cardbackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
            bottom: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            /// 🔹 LEFT & RIGHT ITEMS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: CupertinoIcons.house_fill,
                  label: 'Home',
                  active: currentIndex == 0,
                  onTap: () => onTabChanged(0),
                ),
      
                const SizedBox(width: 72),
      
                _NavItem(
                  icon: CupertinoIcons.person_alt,
                  label: 'Profile',
                  active: currentIndex == 2,
                  onTap: () => onTabChanged(2),
                ),
              ],
            ),
      
            /// 🔘 FLOATING SCAN BUTTON (modal)
            Positioned(
              top: -25,
              child: GestureDetector(
                onTap: () => _onScanTap(context),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppThemeColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.camera_fill,
                    color: CupertinoColors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 NAV ITEM
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppThemeColors.success : CupertinoColors.systemGrey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
