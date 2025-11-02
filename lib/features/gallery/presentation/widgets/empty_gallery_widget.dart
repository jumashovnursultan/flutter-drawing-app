import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class EmptyGalleryWidget extends StatelessWidget {
  final VoidCallback onCreateNew;

  const EmptyGalleryWidget({super.key, required this.onCreateNew});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.noDrawingsYet,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.emptyGalleryMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCreateNew,
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.createNew),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
