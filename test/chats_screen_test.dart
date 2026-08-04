import 'package:flutter_test/flutter_test.dart';
import 'package:uikit/screens/chats_screen.dart';

void main() {
  group('calculateUnreadCount', () {
    test('increments unread count for incoming messages', () {
      expect(calculateUnreadCount(2, isIncomingMessage: true), 3);
    });

    test('keeps unread count unchanged for outgoing messages', () {
      expect(calculateUnreadCount(2, isIncomingMessage: false), 2);
    });
  });
}
