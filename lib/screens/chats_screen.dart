import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/chat_widgets/chat_app_bar.dart';
import 'package:uikit/widgets/chat_widgets/chat_composer.dart';
import 'package:uikit/widgets/chat_widgets/chat_firestore_helpers.dart';
import 'package:uikit/widgets/chat_widgets/chat_message_list.dart';
import 'package:uikit/widgets/chat_widgets/chat_selection_app_bar.dart';

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
      _resetChatState();
    }
  }

  @override
  void initState() {
    super.initState();
    _initMessageStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _markChatAsRead();
    });
  }

  void _resetChatState() {
    _lastMessageCount = 0;
    selectedMessageIds.clear();
    _initMessageStream();
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

  String _chatDocId(String userId1, String userId2) =>
      buildChatDocId(userId1, userId2);

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
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      selectedMessageIds.contains(id)
          ? selectedMessageIds.remove(id)
          : selectedMessageIds.add(id);
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
        if (docs.isNotEmpty && _shouldScrollToBottom(docs.length)) {
          if (_lastMessageCount > 0 && currentUserId != null) {
            unawaited(_updateUnreadCount(currentUserId, docs));
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
                    child: ChatMessageList(
                      docs: docs,
                      colors: colors,
                      currentUserId: currentUserId,
                      selectedMessageIds: selectedMessageIds,
                      isSelectionMode: _isSelectionMode,
                      scrollController: _scrollController,
                      onToggleSelection: _toggleSelection,
                    ),
                  ),
                ),
                _isSelectionMode
                    ? SizedBox()
                    : ChatComposer(
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
    return ChatSelectionAppBar(
      selectedCount: selectedMessageIds.length,
      onClose: _clearSelection,
      onDelete: _showDeleteDialog,
    );
  }

  bool _shouldScrollToBottom(int currentLength) {
    return currentLength > _lastMessageCount || _lastMessageCount == 0;
  }

  Future<void> _updateUnreadCount(
    String currentUserId,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    await updateUnreadCountForChat(
      _chatDocId(widget.userId, currentUserId),
      currentUserId,
      docs.skip(_lastMessageCount).toList(),
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    return ChatAppBar(
      userName: widget.numName,
      isOnline: widget.isOnline,
      avatarUrl: widget.imageAvatar,
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
