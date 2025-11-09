import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// LoadingIndicator - Animated loading indicator with neon glow
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  
  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 50,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accent,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
