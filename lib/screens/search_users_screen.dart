import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uikit/repositories/user_repository.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/widgets/on_user_search_tile.dart';

class _ChatSearchItem {
  const _ChatSearchItem({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  final String userId;
  final String name;
  final String email;
  final String avatarUrl;
}

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  Future<List<_ChatSearchItem>> _loadChatSearchItems(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    String currentUserId,
  ) async {
    final items = <_ChatSearchItem>[];

    for (final doc in chatDocs) {
      final data = doc.data();
      final participantIds = <String>[];
      if (data['participantIds'] is List) {
        participantIds.addAll(List<String>.from(data['participantIds']));
      }

      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) continue;

      final user = await _userRepository.getUserById(otherUserId);
      final name = (user?.name ?? data['name'] ?? '').toString().trim();
      final email = (user?.email ?? data['email'] ?? '').toString().trim();

      items.add(
        _ChatSearchItem(
          userId: otherUserId,
          name: name.isNotEmpty ? name : 'Без имени',
          email: email.isNotEmpty ? email : '',
          avatarUrl: data['avatarUrl']?.toString() ?? '',
        ),
      );
    }

    return items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final getStyle = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AppInputWidget(
            onChanged: (value) {
              setState(() {});
            },
            controller: _searchController,
            trailing: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                _searchController.clear();
              },
              icon: Icon(Icons.cancel, color: colors.iconSecondary),
            ),
            leading: Icon(Icons.search, color: colors.iconSecondary),
            filledColor: getStyle.dividerColor,
          ),
        ),
        backgroundColor: getStyle.scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
            child: Text('users2'.tr(), style: getStyle.textTheme.bodySmall),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where(
                      'participantIds',
                      arrayContains: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .orderBy('updatedAt', descending: true)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (asyncSnapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки пользователей'));
                  }

                  final chatDocs = asyncSnapshot.data?.docs ?? [];
                  final query = _searchController.text.trim().toLowerCase();
                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

                  if (currentUserId == null) {
                    return const Center(
                      child: Text('Пользователь не авторизован'),
                    );
                  }

                  return FutureBuilder<List<_ChatSearchItem>>(
                    future: _loadChatSearchItems(chatDocs, currentUserId),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          query.isNotEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (futureSnapshot.hasError) {
                        return Center(child: Text('Ошибка загрузки чатов'));
                      }

                      final users = futureSnapshot.data ?? [];
                      final filteredUsers = users.where((item) {
                        final name = item.name.toLowerCase();
                        final email = item.email.toLowerCase();
                        return query.isEmpty
                            ? true
                            : name.contains(query) || email.contains(query);
                      }).toList();

                      if (filteredUsers.isEmpty) {
                        return EmptyChatWidget(
                          title: query.isEmpty
                              ? 'У вас пока нет диалогов'
                              : 'Ничего не найдено',
                          subtitle: query.isEmpty
                              ? 'Начните разговор с пользователем, чтобы он появился здесь'
                              : 'Проверьте имя пользователя или email и попробуйте снова',
                          icon: Icons.search,
                        );
                      }

                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredUsers[index];
                          return InkWell(
                            child: SearchChatTile(
                              name: item.name,
                              gmailAccaunt: item.email,
                            ),
                            onTap: () {
                              context.router.push(
                                ChatsRoute(
                                  numName: item.name,
                                  userId: item.userId,
                                  isOnline: false,
                                  imageAvatar: item.avatarUrl,
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 25);
                        },
                        itemCount: filteredUsers.length,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
