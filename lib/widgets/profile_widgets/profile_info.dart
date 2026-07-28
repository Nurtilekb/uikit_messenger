import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileInfo extends StatefulWidget {
  final String name;
  final String email;
  const ProfileInfo({super.key, required this.name, required this.email});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.name.toString();
    _emailController.text = widget.email.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                    autofocus: false,
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
                  autofocus: false,
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
