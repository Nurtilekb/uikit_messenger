import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/user_avatar.dart';
import 'package:uikit/widgets/home_widgets/user_tile_content.dart';

void main() {
  testWidgets('UserAvatar renders initials when no avatar is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData().copyWith(
          extensions: <ThemeExtension<dynamic>>[AppColors.light],
        ),
        home: const Scaffold(
          body: UserAvatar(
            name: 'Alice Johnson',
            avatarUrl: '',
            isOnline: true,
          ),
        ),
      ),
    );

    expect(find.text('AJ'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNothing);
  });

  testWidgets('UserTileContent shows unread badge and preview text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData().copyWith(
          extensions: <ThemeExtension<dynamic>>[AppColors.light],
        ),
        home: const Scaffold(
          body: UserTileContent(
            name: 'Alice',
            lastMessage: 'Hello there',
            time: '12:30',
            unreadCount: 3,
          ),
        ),
      ),
    );

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Hello there'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}
