import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../blocs/tryon_result/tryon_result_cubit.dart';

class TryOnResultScreen extends StatefulWidget {
  final String base64Image;
  final String heroTag;

  const TryOnResultScreen({
    super.key,
    required this.base64Image,
    this.heroTag = 'tryonImageHero',
  });

  @override
  State<TryOnResultScreen> createState() => _TryOnResultScreenState();
}

class _TryOnResultScreenState extends State<TryOnResultScreen> {
  Uint8List get _bytes {
    final data = widget.base64Image.trim();
    final clean = data.contains(',') ? data.split(',').last : data;
    return base64Decode(clean);
  }

  Future<void> _saveToFirebase() async {
    context.read<TryOnResultCubit>().save(_bytes);
  }

  Future<void> _shareImage() async {
    context.read<TryOnResultCubit>().share(_bytes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TryOnResultCubit(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Try-On Result'),
          centerTitle: true,
        ),
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<TryOnResultCubit, TryOnResultState>(
                listener: (context, state) {
                  if (state is TryOnResultSaved) {
                    context.showSnackBar('Saved to generated_results/');
                  } else if (state is TryOnResultError) {
                    context.showSnackBar(state.message, isError: true);
                  } else if (state is TryOnResultShared) {
                    context.showSnackBar('Shared!');
                  }
                },
                builder: (context, state) {
                  final isSaving = state is TryOnResultSaving;
                  final isSharing = state is TryOnResultSharing;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: GlassCard(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: Hero(
                              key: ValueKey(widget.base64Image.hashCode),
                              tag: widget.heroTag,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                  _bytes,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Save Result',
                              icon: Icons.save_alt,
                              onPressed: (isSaving || isSharing) ? null : _saveToFirebase,
                              isLoading: isSaving,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Share Result',
                              icon: Icons.share,
                              isOutlined: true,
                              onPressed: (isSaving || isSharing) ? null : _shareImage,
                              isLoading: isSharing,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
