import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../explore/explore_screen.dart';
import '../tryon/tryon_screen.dart';
import '../profile/profile_screen.dart';

/// HomeScreen - Main navigation screen with bottom nav bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    ExploreScreen(),
    TryOnScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceDark.withOpacity(0.95),
                    AppColors.backgroundDark,
                  ],
                )
              : null,
          color: isDark ? null : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Explore',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.camera_alt_outlined,
                  activeIcon: Icons.camera_alt,
                  label: 'Try On',
                  index: 1,
                  isCenter: true,
                ),
                _buildNavItem(
                  icon: Icons.person_outlined,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isActive = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 24 : 16,
          vertical: isCenter ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? (isCenter ? AppColors.primaryGradient : null)
              : null,
          color: isActive && !isCenter
              ? AppColors.primary.withOpacity(0.1)
              : null,
          borderRadius: BorderRadius.circular(isCenter ? 20 : 16),
          boxShadow: isActive && isCenter
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? (isCenter ? Colors.white : AppColors.primary)
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              size: isCenter ? 28 : 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isCenter ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
