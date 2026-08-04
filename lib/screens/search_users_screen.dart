import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/widgets/on_user_search_tile.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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
                    .collection('users')
                    .orderBy('name', descending: false)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (asyncSnapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки пользователей'));
                  }

                  final users = asyncSnapshot.data?.docs ?? [];
                  final query = _searchController.text.trim().toLowerCase();

                  final filteredUsers = users.where((doc) {
                    final data = doc.data();
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final email = (data['email'] ?? '')
                        .toString()
                        .toLowerCase();
                    return query.isEmpty
                        ? true
                        : name.contains(query) || email.contains(query);
                  }).toList();

                  if (_searchController.text.isEmpty) {
                    return Center(
                      child: Text(
                        query.isEmpty
                            ? 'Поиск пользователей....'
                            : 'Ничего не найдено',
                        style: getStyle.textTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final userDoc = filteredUsers[index];
                      final data = userDoc.data();

                      return InkWell(
                        child: SearchChatTile(
                          name: data['name']?.toString() ?? 'Без имени',
                          gmailAccaunt: data['email']?.toString() ?? '',
                        ),

                        onTap: () {
                          context.router.push(
                            ChatsRoute(
                              numName: data['name']?.toString() ?? 'Без имени',
                              userId: data['uid']?.toString() ?? '',
                              isOnline: false,
                              imageAvatar: data['avatarUrl']?.toString() ?? '',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
