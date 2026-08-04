import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uikit/repositories/chat_repository.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/chats_list_view.dart';
import 'package:uikit/widgets/home_widgets/home_appbar.dart';

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

  final ChatRepository _chatRepository = ChatRepository();

  void _deleteSelectedChats(List<String> idsToDelete) async {
    if (idsToDelete.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чаты?'),
        content: Text(
          'Вы уверены, что хотите удалить ${idsToDelete.length} чат(ов)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _chatRepository.deleteChats(idsToDelete);
              if (!mounted) return;
              _clearSelection();
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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
                    deleteSelectedChats: () =>
                        _deleteSelectedChats(selectedChatIds.toList()),
                    onArchive: () {},
                  )
                : HomeAppBar(
                    onTapSearch: () => context.router.push(SearchRoute()),
                    onTapProfile: () => context.router.push(ProfileRoute()),
                  ),
            const SizedBox(height: 10),
            Expanded(
              child: ChatsListView(
                chatRepository: _chatRepository,
                selectedChatIds: selectedChatIds,
                isSelectionMode: _isSelectionMode,
                onToggleSelection: _toggleSelection,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(themeStyle, colors),
    );
  }

  Widget _buildFab(ThemeData themeStyle, AppColors colors) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: themeStyle.primaryColor,
      onPressed: () => context.router.push(const UsersListRoute()),
      child: Icon(Icons.add, color: colors.textOnPrimary),
    );
  }
}
