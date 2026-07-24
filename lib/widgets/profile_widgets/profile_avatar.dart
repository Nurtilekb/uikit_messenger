import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String initials;

  const ProfileAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Positioned(
      top: 125,
      left: MediaQuery.of(context).size.width / 2 - 60,
      child: Container(
        height: 125,
        width: 125,
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: colors.cardBackground),
          color: colors.profileAvatarBackground,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 43,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
