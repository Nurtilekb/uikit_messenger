import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileLogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.9, color: colors.error),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: colors.error, size: 22),
              const SizedBox(width: 8),
              Text(
                'logout'.tr(),
                style: TextStyle(
                  color: colors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
