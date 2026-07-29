import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final getStyle = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AppInputWidget(
            trailing: IconButton(
              onPressed: () {},
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
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return SearchChatTile(
                    name: 'Anya Смирнова',
                    gmailAccaunt: '@annya',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 25);
                },
                itemCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
