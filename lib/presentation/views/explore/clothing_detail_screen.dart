import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/clothing_item_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

class ClothingDetailScreen extends StatelessWidget {
  final ClothingItemModel? item;
  const ClothingDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradient
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundLight, Colors.white],
                ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: item == null
                ? Center(
                    child: Text(
                      'Item not found',
                      style: context.textTheme.titleLarge,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item!.name,
                            style: context.textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GlassCard(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: item!.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item!.brand, style: context.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(item!.description, style: context.textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            Text('Category: ${item!.category} • Color: ${item!.color}',
                                style: context.textTheme.bodySmall),
                            const SizedBox(height: 8),
                            Text('Price: \$${item!.price.toStringAsFixed(2)}',
                                style: context.textTheme.titleMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Use This Clothing',
                        icon: Icons.checkroom,
                        onPressed: () {
                          // Pop back with the selected item so TryOnScreen can capture it if needed
                          Navigator.of(context).pop(item);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
