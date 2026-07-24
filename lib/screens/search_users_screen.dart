import 'package:flutter/material.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/widgets/on_user_search_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final getStyle = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AppInputWidget(
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.cancel, color: Colors.black26),
            ),
            leading: Icon(Icons.search, color: Colors.black26),
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
            child: Text('ПОЛЬЗОВАТЕЛИ', style: getStyle.textTheme.bodySmall),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return SearchChatTile(
                    name: 'Anya Смирнова',
                    gmailAccaunt: '@annya',
                    avatarUrl:
                        'https://media.gq-magazine.co.uk/photos/5d1392adb363fa622820c7ec/1:1/w_1280,h_1280,c_limit/Conor-McGregor-GQ-20Dec16_rex_b.jpg',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 25);
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
