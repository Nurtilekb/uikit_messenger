import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class BuiltLangItem extends StatelessWidget {
  final String text;
  final String currentSelected;
  final AppColors colors;
  final VoidCallback onTap;

  const BuiltLangItem({
    super.key,
    required this.text,
    required this.currentSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentSelected == text;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.settingsItemSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? colors.settingsItemSelected
                : colors.settingsItemBorder,
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? colors.textOnPrimary : colors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check, color: colors.textOnPrimary, size: 18),
          ],
        ),
      ),
    );
  }
}
