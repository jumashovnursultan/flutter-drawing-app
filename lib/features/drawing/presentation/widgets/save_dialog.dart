import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class SaveDialog extends StatefulWidget {
  const SaveDialog({super.key});

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _controller.text =
        'Рисунок ${now.day}.${now.month}.${now.year} ${now.hour}:${now.minute}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.saveDrawingTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: AppStrings.drawingTitle,
            hintText: AppStrings.enterDrawingTitle,
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введите название';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }
}
