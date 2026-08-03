import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:uikit/models/chat_model.dart';
import 'package:uikit/router/app_router.dart';

import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/widgets/home_widgets/home_appbar.dart';
import 'package:uikit/widgets/user_tile.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> selectedChatIds = {};
  bool get _isSelectionMode => selectedChatIds.isNotEmpty;

  void _toggleSelection(String id) {
    setState(() {
      if (selectedChatIds.contains(id)) {
        selectedChatIds.remove(id);
      } else {
        selectedChatIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedChatIds.clear();
    });
  }

  void _onArchive() {
    setState(() {
      chats.where((chat) => selectedChatIds.contains(chat.chatID)).toList();

      chats.removeWhere((chat) => selectedChatIds.contains(chat.chatID));
      selectedChatIds.clear();
    });
  }

  void _deleteSelectedChats() {
    if (selectedChatIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чаты?'),
        content: Text(
          'Вы уверены, что хотите удалить ${selectedChatIds.length} чат(ов)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                chats.removeWhere(
                  (chat) => selectedChatIds.contains(chat.chatID),
                );
                selectedChatIds.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool isEmpty = false;

  List<Chat> chats = [
    Chat(
      name: 'Kutman Sayitkanov',
      lastMessage: 'bro, go to gym today?',
      time: DateTime.now().subtract(const Duration(days: 1)),

      chatID: '1',
    ),
    Chat(
      name: 'Aigerim',
      lastMessage: 'Спасибо за помощь! 😊',
      time: DateTime.now(),

      chatID: '2',
    ),
    Chat(
      name: 'Bekzat',
      lastMessage: 'Когда встречаемся?',
      time: DateTime.now().subtract(const Duration(days: 1)),

      chatID: '3',
    ),
    Chat(
      name: 'Daniyar Ermatov',
      lastMessage: 'Мы можем с вами встретиться?',
      time: DateTime.now().subtract(const Duration(hours: 2)),

      chatID: '4',
    ),
    Chat(
      name: 'Aizhan Matraimova',
      lastMessage: 'Давай сегодя пойдем в ынтымак за ручки держась',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      chatID: '5',
    ),
    Chat(
      name: 'Ruslan',
      lastMessage: 'Где ты? Я уже на месте',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      chatID: '6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _isSelectionMode
                ? HomeAppBar2(
                    selectedChatIds: selectedChatIds,
                    clearSelection: _clearSelection,
                    deleteSelectedChats: _deleteSelectedChats,
                    onArchive: _onArchive,
                  )
                : HomeAppBar(
                    onTapSearch: () {
                      context.router.push(SearchRoute());
                    },
                    onTapProfile: () {
                      context.router.push(ProfileRoute());
                    },
                  ),
            const SizedBox(height: 10),
            if (chats.isNotEmpty)
              Expanded(
                child: ChatsPage(),
                // child: ListView.separated(
                //   itemCount: chats.length,
                //   separatorBuilder: (_, _) => const SizedBox(height: 5),
                //   itemBuilder: (context, index) {
                //     final chat = chats[index];
                //     final isSelected = selectedChatIds.contains(chat.chatID);

                //     return UserTile(
                //       onTap: () {
                //         if (_isSelectionMode) {
                //           _toggleSelection(chat.chatID);
                //         } else {
                //           context.router.push(
                //             ChatsRoute(
                //               numName: chat.name,
                //               isOnline: true,
                //               imageAvatar: '',
                //               userId: '${chat.chatID}',
                //             ),
                //           );
                //         }
                //       },
                //       onlongPress: () {
                //         _toggleSelection(chat.chatID);
                //       },
                //       name: chat.name,
                //       lastMessage: chat.lastMessage,
                //       isOnline: true,
                //       unreadCount: 2,
                //       avatarUrl: '',
                //       time: chat.time.toString(),
                //       isSelected: isSelected,
                //     );
                //   },
                // ),
              ),
            if (chats.isEmpty) const Center(child: EmptyChatWidget()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: themeStyle.primaryColor,
        onPressed: () {
          context.router.push(const UsersListRoute());
        },
        child: Icon(Icons.add, color: colors.textOnPrimary),
      ),
    );
  }
}

class ChatsPage extends StatelessWidget {
  ChatsPage({super.key});

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> get chatsStream {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participantIds', arrayContains: currentUserId)
          .orderBy('updatedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data!.docs;

        return ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final chat = chats[index].data();

            final participants = List<String>.from(chat['participantIds']);

            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
            );

            return ListTile(
              title: Text(otherUserId), // пока выводим uid
              subtitle: Text(chat['lastMessage']),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
