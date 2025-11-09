import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../blocs/clothing/clothing_bloc.dart';
import '../../blocs/clothing/clothing_event.dart';
import '../../blocs/clothing/clothing_state.dart';
import '../../widgets/clothing_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/glass_card.dart';

/// ExploreScreen - Browse clothing catalog
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<ClothingBloc>().add(const ClothingLoadRequested());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _handleFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<ClothingBloc>().add(
      ClothingFilterRequested(
        category: category == 'All' ? null : category,
      ),
    );
  }
  
  void _handleSearch(String query) {
    if (query.isEmpty) {
      context.read<ClothingBloc>().add(const ClothingLoadRequested());
    } else {
      context.read<ClothingBloc>().add(ClothingSearchRequested(query: query));
    }
  }
  
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore',
                              style: context.textTheme.displaySmall,
                            ),
                            Text(
                              'Find your perfect style',
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Search bar
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        style: TextStyle(
                          color: context.isDarkMode
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search clothing...',
                          hintStyle: TextStyle(
                            color: context.isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: context.isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Categories
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: AppConstants.clothingCategories.length,
                  itemBuilder: (context, index) {
                    final category = AppConstants.clothingCategories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => _handleFilter(category),
                        child: AnimatedContainer(
                          duration: AppConstants.mediumDuration,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.primaryGradient
                                : null,
                            color: isSelected
                                ? null
                                : context.isDarkMode
                                    ? AppColors.surfaceDark
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : context.isDarkMode
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Clothing Grid
              Expanded(
                child: BlocBuilder<ClothingBloc, ClothingState>(
                  builder: (context, state) {
                    if (state is ClothingLoading) {
                      return const LoadingIndicator(
                        message: 'Loading clothing items...',
                      );
                    } else if (state is ClothingError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    } else if (state is ClothingEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: context.isDarkMode
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items found',
                              style: context.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    } else if (state is ClothingLoaded) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return ClothingCard(
                            item: item,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/clothing-detail',
                                arguments: item,
                              );
                            },
                          );
                        },
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
