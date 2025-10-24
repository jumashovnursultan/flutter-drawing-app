import 'package:drawing_app/features/drawing/presentation/screens/editor_screen.dart';
import 'package:drawing_app/injection_container/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _onDrawingTap(BuildContext context, String drawingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(drawingId: drawingId),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои рисунки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => _showLogoutDialog(context),
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
            return EmptyGalleryWidget(onCreateNew: () => _onCreateNew(context));
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

                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.drawings.length,
                itemBuilder: (context, index) {
                  final drawing = state.drawings[index];
                  return DrawingGridItem(
                    drawing: drawing,
                    onTap: () => _onDrawingTap(context, drawing.id),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onCreateNew(context),
        icon: const Icon(Icons.add),
        label: const Text('Создать новый'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
