import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    this.icon,
    this.onTap,
    this.iconColor,
    this.background,
    this.borderColor,
    required this.childd,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final Color? background;
  final Color? borderColor;
  final Color? iconColor;
  final Widget childd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: childd,
      ),
    );
  }
}
