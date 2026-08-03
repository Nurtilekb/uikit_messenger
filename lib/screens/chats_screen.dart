import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/Chat_widgets/Chat_message_bubble.dart';
import 'package:uikit/widgets/chat_widgets/chat_app_bar.dart';
import 'package:uikit/widgets/chat_widgets/chat_composer.dart';

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

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  bool get _isSelectionMode => selectedMessageIds.isNotEmpty;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    final currentUserId = _currentUserId;

    if (text.isEmpty || currentUserId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc('${widget.userId}_$currentUserId')
          .collection('messages')
          .add({
            'text': text,
            'senderId': currentUserId,
            'sendAt': _getCurrentTime(),
          });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      print('Ошибка записи: $e');
    }
  }

  Future<void> _deleteSelectedMessages() async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || selectedMessageIds.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    final collectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.userId}_$currentUserId')
        .collection('messages');

    for (final messageId in selectedMessageIds) {
      batch.delete(collectionRef.doc(messageId));
    }

    try {
      await batch.commit();
    } catch (e) {
      print('Ошибка удаления: $e');
    }

    setState(() {
      selectedMessageIds.clear();
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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

    final messageStream = currentUserId == null
        ? const Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
        : FirebaseFirestore.instance
              .collection('chats')
              .doc('${widget.userId}_$currentUserId')
              .collection('messages')
              .orderBy('sendAt', descending: false)
              .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: messageStream,
      builder: (context, asyncSnapshot) {
        final docs = asyncSnapshot.data?.docs ?? [];

        return Scaffold(
          appBar: _isSelectionMode
              ? AppBar(
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('confirmdeleting'.tr()),
                              content: Text('descriptdeleting'.tr()),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('cancel'.tr()),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text(
                                    'delete'.tr(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await _deleteSelectedMessages();
                                    if (mounted) Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              : ChatAppBar(
                  userName: widget.numName,
                  isOnline: widget.isOnline,
                  avatarUrl: widget.imageAvatar,
                ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: colors.chatBackground,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final message = doc.data();
                        final isMe = message['senderId'] == currentUserId;
                        final isSelected = selectedMessageIds.contains(doc.id);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 1,
                          ),
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          child: ChatMessageBubble(
                            text: message['text'] ?? '',
                            isMe: isMe,
                            time: message['sendAt'] ?? '',
                            onlongTap: () {
                              _toggleSelection(doc.id);
                            },
                            ontapp: () {
                              if (_isSelectionMode) {
                                _toggleSelection(doc.id);
                              }
                            },
                          ),
                        );
                      },
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
}
