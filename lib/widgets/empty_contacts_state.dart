import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class EmptyChatWidget extends StatelessWidget {
  const EmptyChatWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.actionButton,
  });
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? actionButton;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(68),
            ),
            child: Icon(icon, color: colors.iconSecondary, size: 42),
          ),
          const SizedBox(height: 24),
          Text(
            textAlign: TextAlign.center,
            title ?? 'nofound'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle ?? 'checknameoremail'.tr(),

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 30),
          ?actionButton,
        ],
      ),
    );
  }
}
