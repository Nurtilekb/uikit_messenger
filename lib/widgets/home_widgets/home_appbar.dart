import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/appbar_button.dart';

class HomeAppBar extends StatelessWidget {
  final void Function()? onTapSearch;
  final VoidCallback? onTapProfile;
  final VoidCallback? deleteSelectedChats;
  const HomeAppBar({
    this.onTapSearch,
    this.onTapProfile,
    this.deleteSelectedChats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);

    return AppBar(
      backgroundColor: colors.cardBackground,
      actionsPadding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
      title: Text(
        "chats".tr(),
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: colors.textPrimary,
        ),
      ),
      actions: [
        CircleIconButton(
          childd: Icon(Icons.search, size: 27, color: colors.textPrimary),
          onTap: onTapSearch,
        ),
        const SizedBox(width: 12),
        CircleIconButton(
          childd: Text(
            "me".tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          background: themeStyle.dividerColor,
          onTap: onTapProfile,
        ),
      ],
    );
  }
}

class HomeAppBar2 extends StatelessWidget {
  final VoidCallback? clearSelection;
  final VoidCallback? deleteSelectedChats;
  final VoidCallback? onArchive;
  final Set<String> selectedChatIds;
  const HomeAppBar2({
    super.key,
    this.clearSelection,
    this.deleteSelectedChats,
    this.onArchive,
    required this.selectedChatIds,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: colors.iconPrimary),
        onPressed: clearSelection,
      ),
      title: Text(
        'Выбрано: ${selectedChatIds.length}',
        style: TextStyle(color: colors.textPrimary),
      ),
      backgroundColor: colors.cardBackground,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: deleteSelectedChats,
        ),
        IconButton(
          icon: Icon(Icons.archive_outlined, color: colors.iconPrimary),
          onPressed: onArchive,
        ),
      ],
    );
  }
}
