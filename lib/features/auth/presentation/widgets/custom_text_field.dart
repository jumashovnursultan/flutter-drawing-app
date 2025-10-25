import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hasInteracted = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onTextChanged);

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_hasInteracted) {
      _validate();
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _hasInteracted = true;
      });
      _validate();
    }
  }

  void _validate() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                ],
                stops: [0.1, 0.5, 0.92],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Color(0xFF908E97)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: TextStyle(color: Color(0xFF898790)),
                  ),
                  SizedBox(height: 4),
                ],
                SizedBox(
                  height: 30,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,

                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (value) {
                      final error = widget.validator?.call(value);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _errorText = error;
                          });
                        }
                      });
                      return error;
                    },
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      hintStyle: TextStyle(color: Color(0xFF898790)),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                if (_errorText != null && _errorText!.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Text(
                    _errorText!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
