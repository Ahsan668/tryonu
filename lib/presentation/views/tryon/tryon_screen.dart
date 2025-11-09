import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/clothing_item_model.dart';
import '../../blocs/tryon/tryon_bloc.dart';
import '../../blocs/tryon/tryon_event.dart';
import '../../blocs/tryon/tryon_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_indicator.dart';

/// TryOnScreen - Virtual try-on interface
class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});
  
  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  ClothingItemModel? _selectedClothing;
  
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TryOnBloc>().setUserId(authState.user.uid);
    }
  }
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        
        context.read<TryOnBloc>().add(
          TryOnUploadPhotoRequested(imageFile: File(image.path)),
        );
      }
    } catch (e) {
      context.showSnackBar('Failed to pick image: $e', isError: true);
    }
  }
  
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectClothing() {
    Navigator.of(context).pushNamed('/explore');
  }
  
  void _processTryOn() {
    if (_selectedClothing != null) {
      context.read<TryOnBloc>().add(
        TryOnProcessRequested(clothingItemId: _selectedClothing!.id),
      );
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
          child: BlocConsumer<TryOnBloc, TryOnState>(
            listener: (context, state) {
              if (state is TryOnError) {
                context.showSnackBar(state.message, isError: true);
              } else if (state is TryOnPhotoUploaded) {
                context.showSnackBar('Photo uploaded successfully!');
              } else if (state is TryOnSuccess) {
                _showResultDialog(state);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'Virtual Try-On',
                      style: context.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your photo and select clothing',
                      style: context.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Photo Upload Section
                    GlassCard(
                      showGlow: _selectedImage != null,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Your Photo',
                                style: context.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          if (_selectedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _selectedImage!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.surfaceDark
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 64,
                                      color: context.isDarkMode
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No photo selected',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 16),
                          
                          PrimaryButton(
                            text: _selectedImage != null
                                ? 'Change Photo'
                                : 'Upload Photo',
                            icon: Icons.camera_alt,
                            onPressed: state is TryOnLoading || state is TryOnProcessing
                                ? null
                                : _showImageSourceDialog,
                            isLoading: state is TryOnLoading,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Clothing Selection Section
                    GlassCard(
                      showGlow: _selectedClothing != null,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.checkroom,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Select Clothing',
                                style: context.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          if (_selectedClothing != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.surfaceDark
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: _selectedClothing!.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedClothing!.name,
                                          style: context.textTheme.titleMedium,
                                        ),
                                        Text(
                                          _selectedClothing!.brand,
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.surfaceDark
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.checkroom_outlined,
                                      size: 48,
                                      color: context.isDarkMode
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No clothing selected',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 16),
                          
                          PrimaryButton(
                            text: 'Browse Catalog',
                            icon: Icons.shopping_bag,
                            isOutlined: true,
                            onPressed: _selectClothing,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Try On Button
                    if (state is TryOnProcessing)
                      const LoadingIndicator(
                        message: 'AI is processing your try-on...',
                      )
                    else
                      PrimaryButton(
                        text: 'Try On Now',
                        icon: Icons.auto_awesome,
                        onPressed: _selectedImage != null && _selectedClothing != null
                            ? _processTryOn
                            : null,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Info text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI processing takes 3-5 seconds',
                              style: TextStyle(
                                color: AppColors.info,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
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
  
  void _showResultDialog(TryOnSuccess state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Try-On Result',
                    style: context.textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: state.result.resultImageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save',
                      icon: Icons.favorite,
                      onPressed: () {
                        context.read<TryOnBloc>().add(
                          TryOnSaveRequested(resultId: state.result.id),
                        );
                        Navigator.pop(context);
                        context.showSnackBar('Saved to your collection!');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Share',
                      icon: Icons.share,
                      isOutlined: true,
                      onPressed: () {
                        // Implement share functionality
                        Navigator.pop(context);
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
