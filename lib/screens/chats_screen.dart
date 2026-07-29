import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
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

  const ChatsScreen({
    super.key,
    required this.numName,
    required this.isOnline,
    required this.imageAvatar,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final Set<String> selectedMessageIds = {};

  bool get _isSelectionMode => selectedMessageIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      {'id': '1', 'text': 'Привет! Как дела?', 'isMe': false, 'time': '10:30'},
      {
        'id': '2',
        'text': 'Привет! Все отлично, а у тебя?',
        'isMe': true,
        'time': '10:32',
      },
      {
        'id': '3',
        'text': 'Тоже хорошо! Чем занимаешься?',
        'isMe': false,
        'time': '10:35',
      },
      {
        'id': '4',
        'text': 'Работаю над новым проектом',
        'isMe': true,
        'time': '10:38',
      },
    ]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': _messageController.text.trim(),
      'isMe': true,
      'time': _getCurrentTime(),
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    _scrollToBottom();
    _autoReply();
  }

  void _autoReply() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && widget.isOnline == true) {
        setState(() {
          _messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': _getRandomReply(),
            'isMe': false,
            'time': _getCurrentTime(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _getRandomReply() {
    final replies = [
      'Понял, интересно!',
      'Ого, круто!',
      'Давай обсудим позже',
      'Хорошо, договорились!',
      'Спасибо за информацию!',
      'Отлично, жду!',
      'Понял, сделаем',
      'Супер!',
    ];
    return replies[DateTime.now().millisecond % replies.length];
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
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    print('You copied the messages');
                  },
                ),
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
                              onPressed: () => Navigator.of(
                                context,
                              ).pop(), // Closes the dialog
                            ),
                            TextButton(
                              child: Text(
                                'delete'.tr(),
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  _messages.removeWhere(
                                    (msg) =>
                                        selectedMessageIds.contains(msg['id']),
                                  );
                                  selectedMessageIds.clear();
                                });
                                Navigator.of(context).pop();
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
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isSelected = selectedMessageIds.contains(
                      message['id'],
                    );

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      color: isSelected
                          ? colors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      child: ChatMessageBubble(
                        text: message['text'],
                        isMe: message['isMe'],
                        time: message['time'],
                        onlongTap: () {
                          _toggleSelection(message['id']);
                        },
                        ontapp: () {
                          if (_isSelectionMode) {
                            _toggleSelection(message['id']);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            ChatComposer(controller: _messageController, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}
