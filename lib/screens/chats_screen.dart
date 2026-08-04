import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/Chat_widgets/Chat_message_bubble.dart';
import 'package:uikit/widgets/chat_widgets/chat_app_bar.dart';
import 'package:uikit/widgets/chat_widgets/chat_composer.dart';

int calculateUnreadCount(int currentCount, {required bool isIncomingMessage}) {
  return isIncomingMessage ? currentCount + 1 : currentCount;
}

Future<void> updateUnreadCountForChat(
  String chatId,
  String currentUserId,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> newMessages,
) async {
  if (newMessages.isEmpty || currentUserId.isEmpty) return;

  final incomingMessages = newMessages.where((doc) {
    final senderId = doc.data()['senderId']?.toString();
    return senderId != null && senderId != currentUserId;
  }).toList();

  if (incomingMessages.isEmpty) return;

  final chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  await chatDocRef.set({
    'unreadCount': FieldValue.increment(incomingMessages.length),
  }, SetOptions(merge: true));
}

Future<void> resetUnreadCountForChat(String chatId) async {
  await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
    'unreadCount': 0,
  }, SetOptions(merge: true));
}

@RoutePage()
class ChatsScreen extends StatefulWidget {
  final String numName;
  final bool isOnline;
  final String imageAvatar;
  final String userId;

  const ChatsScreen({
    super.key,
    required this.numName,
    required this.isOnline,
    required this.imageAvatar,
    required this.userId,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final Set<String> selectedMessageIds = {};
  int _lastMessageCount = 0;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messageStream;

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  bool get _isSelectionMode => selectedMessageIds.isNotEmpty;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _lastMessageCount = 0;
      selectedMessageIds.clear();
      _initMessageStream();
    }
  }

  @override
  void initState() {
    super.initState();
    _initMessageStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _markChatAsRead();
      }
    });
  }

  void _initMessageStream() {
    final currentUserId = _currentUserId;
    _messageStream = currentUserId == null
        ? const Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
        : FirebaseFirestore.instance
              .collection('chats')
              .doc(_chatDocId(widget.userId, currentUserId))
              .collection('messages')
              .orderBy('createdAt', descending: false)
              .snapshots(includeMetadataChanges: true);
  }

  String _chatDocId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    final currentUserId = _currentUserId;

    if (text.isEmpty || currentUserId == null) return;

    final chatId = _chatDocId(widget.userId, currentUserId);
    final chatDocRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId);
    _messageController.clear();
    try {
      await chatDocRef.collection('messages').add({
        'text': text,
        'senderId': currentUserId,
        'sendAt': _getCurrentTime(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await chatDocRef.set({
        'participantIds': [currentUserId, widget.userId],
        'lastMessage': text,
        'updatedAt': FieldValue.serverTimestamp(),
        'senderId': currentUserId,
        'unreadCount': 0,
      }, SetOptions(merge: true));

      _scrollToBottom();
    } catch (e) {
      debugPrint('Ошибка записи: $e');
    }
  }

  Future<void> _markChatAsRead() async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || widget.userId.isEmpty) return;

    await resetUnreadCountForChat(_chatDocId(widget.userId, currentUserId));
  }

  Future<void> _deleteSelectedMessages() async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || selectedMessageIds.isEmpty) return;

    final chatDocRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatDocId(widget.userId, currentUserId));
    final messagesRef = chatDocRef.collection('messages');
    final batch = FirebaseFirestore.instance.batch();

    for (final messageId in selectedMessageIds) {
      batch.delete(messagesRef.doc(messageId));
    }

    try {
      await batch.commit();

      final remainingSnapshot = await messagesRef.get();
      final remainingMessage = remainingSnapshot.docs.isNotEmpty
          ? (remainingSnapshot.docs.last.data()['text']?.toString() ?? '')
          : '';

      await chatDocRef.set({
        'lastMessage': remainingMessage,
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          selectedMessageIds.clear();
        });
      }
    } catch (e) {
      debugPrint('Ошибка удаления: $e');
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent <= 0) return;

        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedMessageIds.contains(id)) {
        selectedMessageIds.remove(id);
      } else {
        selectedMessageIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedMessageIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final currentUserId = _currentUserId;

    if (currentUserId != null && _messageStream == null) {
      _initMessageStream();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Ошибка загрузки сообщений: ${snapshot.error}'),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isNotEmpty &&
            (docs.length > _lastMessageCount || _lastMessageCount == 0)) {
          if (_lastMessageCount > 0 && currentUserId != null) {
            unawaited(
              updateUnreadCountForChat(
                _chatDocId(widget.userId, currentUserId),
                currentUserId,
                docs.skip(_lastMessageCount).toList(),
              ),
            );
          }
          _lastMessageCount = docs.length;
          _scrollToBottom();
        }

        return Scaffold(
          appBar: _isSelectionMode
              ? _buildSelectionAppBar()
              : _buildChatAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: colors.chatBackground,
                    child: docs.isEmpty
                        ? Center(
                            child: Text(
                              'Сообщений пока нет',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: docs.length,
                            itemBuilder: (_, index) => _buildMessageTile(
                              docs[index],
                              colors,
                              currentUserId,
                            ),
                          ),
                  ),
                ),
                ChatComposer(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _clearSelection,
      ),
      title: Text('${selectedMessageIds.length}'),
      actions: [
        IconButton(icon: const Icon(Icons.reply), onPressed: () {}),
        IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteDialog(),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    return ChatAppBar(
      userName: widget.numName,
      isOnline: widget.isOnline,
      avatarUrl: widget.imageAvatar,
    );
  }

  Widget _buildMessageTile(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    AppColors colors,
    String? currentUserId,
  ) {
    final message = doc.data();
    final isMe = message['senderId'] == currentUserId;
    final isSelected = selectedMessageIds.contains(doc.id);
    final timeText =
        message['sendAt'] ??
        (message['createdAt'] is Timestamp
            ? (message['createdAt'] as Timestamp).toDate().toLocal().toString()
            : '');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      color: isSelected
          ? colors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: ChatMessageBubble(
        text: message['text'] ?? '',
        isMe: isMe,
        time: timeText,
        onlongTap: () => _toggleSelection(doc.id),
        ontapp: () {
          if (_isSelectionMode) {
            _toggleSelection(doc.id);
          }
        },
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final navigator = Navigator.of(context);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirmdeleting'.tr()),
        content: Text('descriptdeleting'.tr()),
        actions: [
          TextButton(
            child: Text('cancel'.tr()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'delete'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              navigator.pop();
              await _deleteSelectedMessages();
              if (!mounted) return;
            },
          ),
        ],
      ),
    );
  }
}
