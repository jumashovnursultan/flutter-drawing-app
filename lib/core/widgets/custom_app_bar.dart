import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor = const Color(0xFF221C2E),
    this.textColor = Colors.white,
    this.iconColor = const Color(0xFFFF6B6B),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
