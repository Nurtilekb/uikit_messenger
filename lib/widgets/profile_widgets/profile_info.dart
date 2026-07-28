import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileInfo extends StatefulWidget {
  final String name;
  final String email;
  final ValueChanged<bool>? onChanged; // Callback для уведомления об изменениях

  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    this.onChanged,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  bool _hasChanges = false;
  late String _originalName;
  late String _originalEmail;

  @override
  void initState() {
    super.initState();
    _originalName = widget.name;
    _originalEmail = widget.email;
    _titleController.text = widget.name;
    _emailController.text = widget.email;

    _titleController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasChanges =
        _titleController.text.trim() != _originalName ||
        _emailController.text.trim() != _originalEmail;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
      widget.onChanged?.call(hasChanges);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _titleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 60, 40, 30),
      color: colors.cardBackground,
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: Center(
                child: TextField(
                  autofocus: true,
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
