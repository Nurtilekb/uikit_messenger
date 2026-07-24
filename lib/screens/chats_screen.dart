import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/Chat_widgets/Chat_message_bubble.dart';
import 'package:uikit/widgets/chat_widgets/chat_app_bar.dart';
import 'package:uikit/widgets/chat_widgets/chat_composer.dart';

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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      {'text': 'Привет! Как дела?', 'isMe': false, 'time': '10:30'},
      {'text': 'Привет! Все отлично, а у тебя?', 'isMe': true, 'time': '10:32'},
      {'text': 'Тоже хорошо! Чем занимаешься?', 'isMe': false, 'time': '10:35'},
      {'text': 'Работаю над новым проектом', 'isMe': true, 'time': '10:38'},
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

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': _getCurrentTime(),
      });
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      appBar: ChatAppBar(
        userName: widget.numName,
        isOnline: widget.isOnline,
        avatarUrl: widget.imageAvatar,
      ),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: colors.chatBackground,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessageBubble(
                    text: message['text'],
                    isMe: message['isMe'],
                    time: message['time'],
                  );
                },
              ),
            ),
          ),
          ChatComposer(controller: _messageController, onSend: _sendMessage),
        ],
      ),
    );
  }
}
