import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:drawing_app/core/services/notification_service.dart';
import 'package:drawing_app/core/widgets/custom_app_bar.dart';
import 'package:drawing_app/core/widgets/custom_gradient_button.dart';
import 'package:drawing_app/core/widgets/gradient_background.dart';
import 'package:drawing_app/features/drawing/presentation/screens/editor_screen.dart';
import 'package:drawing_app/features/gallery/domain/entities/drawing.dart';
import 'package:drawing_app/injection_container/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../widgets/drawing_grid_item.dart';
import '../widgets/empty_gallery_widget.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthBloc>().state;
        String userId = '';

        if (authState is AuthAuthenticated) {
          userId = authState.user.id;
        }

        return di.sl<GalleryBloc>()..add(LoadDrawingsEvent(userId));
      },
      child: const GalleryScreenContent(),
    );
  }
}

class GalleryScreenContent extends StatelessWidget {
  const GalleryScreenContent({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String drawingId, String title) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить рисунок?'),
        content: Text('Вы уверены, что хотите удалить "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GalleryBloc>().add(DeleteDrawingEvent(drawingId));
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onCreateNew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditorScreen()),
    ).then((shouldRefresh) {
      if (shouldRefresh == true) {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          context.read<GalleryBloc>().add(
            RefreshDrawingsEvent(authState.user.id),
          );
        }
      }
    });
  }

  void _onDrawingTap(BuildContext context, Drawing drawing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditorScreen(drawingId: drawing.id, imageBase64: drawing.thumbnail),
      ),
    ).then((shouldRefresh) {
      if (shouldRefresh == true) {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          context.read<GalleryBloc>().add(
            RefreshDrawingsEvent(authState.user.id),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: AppStrings.gallery,
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/logout.svg'),
            onPressed: () => _showLogoutDialog(context),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/paint_roller.svg'),
              onPressed: () => _onCreateNew(context),
            ),
          ],
        ),

        body: BlocConsumer<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state is GalleryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is GalleryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GalleryEmpty) {
              return EmptyGalleryWidget(
                onCreateNew: () => _onCreateNew(context),
              );
            }

            if (state is GalleryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<GalleryBloc>().add(
                            LoadDrawingsEvent(authState.user.id),
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              );
            }

            if (state is GalleryLoaded) {
              final authState = context.read<AuthBloc>().state;
              String userId = '';

              if (authState is AuthAuthenticated) {
                userId = authState.user.id;
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GalleryBloc>().add(RefreshDrawingsEvent(userId));
                },
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 46,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.drawings.length,
                  itemBuilder: (context, index) {
                    final drawing = state.drawings[index];
                    return DrawingGridItem(
                      drawing: drawing,
                      onTap: () => _onDrawingTap(context, drawing),
                      onDelete: () =>
                          _showDeleteDialog(context, drawing.id, drawing.title),
                    );
                  },
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomGradientButton(
            text: AppStrings.create,
            onPressed: () => _onCreateNew(context),
          ),
        ),
      ),
    );
  }
}
