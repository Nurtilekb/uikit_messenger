import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/appbar_button.dart';

class HomeAppBar extends StatelessWidget {
  final void Function()? onTapSearch;
  final VoidCallback? onTapProfile;
  const HomeAppBar({this.onTapSearch, this.onTapProfile, super.key});

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
  final void Function()? onTapSearch;
  final VoidCallback? _clearSelection;
  final VoidCallback? _deleteSelectedChats;
  final VoidCallback? _onArchive;
  final Set<String> wefwef;
  const HomeAppBar2({
    this.onTapSearch,
    super.key,
    this._clearSelection,
    this._deleteSelectedChats,
    this._onArchive,
    required this.wefwef,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: colors.iconPrimary),
        onPressed: _clearSelection,
      ),
      title: Text(
        'Выбрано: ${wefwef.length}',
        style: TextStyle(color: colors.textPrimary),
      ),
      backgroundColor: colors.cardBackground,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: _deleteSelectedChats,
        ),
        IconButton(
          icon: Icon(Icons.archive_outlined, color: colors.iconPrimary),
          onPressed: _onArchive,
        ),
      ],
    );
  }
}
