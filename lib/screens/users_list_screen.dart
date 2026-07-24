import 'package:flutter/material.dart';
import 'package:uikit/widgets/user_tile.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Пользователи',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return UserTile(
              name: "Nurik",
              lastMessage: 'был в сети год назад',
              time: 'вчера',
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 25);
          },
          itemCount: 7,
        ),
      ),
    );
  }
}
