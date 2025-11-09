import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_event.dart';
import '../../blocs/theme/theme_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

/// ProfileScreen - User profile and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: context.isDarkMode
              ? AppColors.darkGradient
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundLight, Colors.white],
                ),
        ),
        child: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is! AuthAuthenticated) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              final user = authState.user;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    Text(
                      'Profile',
                      style: context.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 32),
                    
                    // Profile Card
                    GlassCard(
                      showGlow: true,
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              user.displayName?.substring(0, 1).toUpperCase() ??
                                  user.email.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Name
                          Text(
                            user.displayName ?? 'User',
                            style: context.textTheme.titleLarge,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Email
                          Text(
                            user.email,
                            style: context.textTheme.bodyMedium,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Member since
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Member since ${user.createdAt.year}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Settings Section
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          
                          // Dark Mode Toggle
                          BlocBuilder<ThemeBloc, ThemeState>(
                            builder: (context, themeState) {
                              final isDarkMode = themeState.themeMode == ThemeMode.dark;
                              
                              return _buildSettingItem(
                                context: context,
                                icon: isDarkMode
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                title: 'Dark Mode',
                                subtitle: isDarkMode ? 'Enabled' : 'Disabled',
                                trailing: Switch(
                                  value: isDarkMode,
                                  onChanged: (value) {
                                    context.read<ThemeBloc>().add(
                                      const ThemeToggled(),
                                    );
                                  },
                                  activeColor: AppColors.accent,
                                ),
                              );
                            },
                          ),
                          
                          const Divider(height: 32),
                          
                          // Try-On History
                          _buildSettingItem(
                            context: context,
                            icon: Icons.history,
                            title: 'Try-On History',
                            subtitle: 'View your past try-ons',
                            onTap: () {
                              // Navigate to history
                            },
                          ),
                          
                          const Divider(height: 32),
                          
                          // Favorites
                          _buildSettingItem(
                            context: context,
                            icon: Icons.favorite,
                            title: 'Favorites',
                            subtitle: 'Saved try-on results',
                            onTap: () {
                              // Navigate to favorites
                            },
                          ),
                          
                          const Divider(height: 32),
                          
                          // Privacy Policy
                          _buildSettingItem(
                            context: context,
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'How we handle your data',
                            onTap: () {
                              // Show privacy policy
                            },
                          ),
                          
                          const Divider(height: 32),
                          
                          // About
                          _buildSettingItem(
                            context: context,
                            icon: Icons.info_outline,
                            title: 'About',
                            subtitle: 'App version 1.0.0',
                            onTap: () {
                              // Show about dialog
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Logout Button
                    PrimaryButton(
                      text: 'Sign Out',
                      icon: Icons.logout,
                      isOutlined: true,
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Version info
                    Text(
                      'TryWear AI v1.0.0',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: context.isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Sign Out',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out?',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Sign Out',
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthSignOutRequested());
                        Navigator.pop(dialogContext);
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
