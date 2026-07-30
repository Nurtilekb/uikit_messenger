import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileInfo extends StatefulWidget {
  final String name;
  final ValueChanged<String>? onChanged;

  final String email;

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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.name;
    _titleController.addListener(_handleNameChanged);
  }

  @override
  void didUpdateWidget(covariant ProfileInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name && _titleController.text != widget.name) {
      _titleController.text = widget.name;
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_handleNameChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    widget.onChanged?.call(_titleController.text);
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
                child: Text(
                  widget.email,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
