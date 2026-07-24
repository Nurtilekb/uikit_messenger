import 'package:flutter/material.dart';
import 'package:uikit/screens/users_list_screen.dart';

class EmptyChatWidget extends StatelessWidget {
  const EmptyChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStyle = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(30, 158, 158, 158),
              borderRadius: BorderRadius.circular(68),
            ),
            child: const Icon(
              Icons.messenger,
              color: Color.fromARGB(159, 158, 158, 158),
              size: 42,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Пока нет чатов',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Начните переписку — найдите пользователя по имени или email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (UsersListScreen())),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: themeStyle.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),

              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Center(
                child: Text(
                  '+ Новый чат',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight(600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
