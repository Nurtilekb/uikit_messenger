import 'package:flutter/material.dart';
import 'package:uikit/screens/search_users_screen.dart';
import 'package:uikit/widgets/appbar_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEmpty = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeStyle = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        backgroundColor: themeStyle.primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
                  child: Row(
                    children: [
                      const Text(
                        'Чаты',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      CircleIconButton(
                        childd: Icon(Icons.search, size: 27),
                        onTap: () {},
                      ),
                      SizedBox(width: 12),
                      CircleIconButton(
                        childd: Text(
                          'Я',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        background: themeStyle.dividerColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // if (isEmpty != false)
                //   Expanded(
                //     child: ListView.separated(
                //       padding: const EdgeInsets.fromLTRB(24, 2, 24, 100),
                //       itemCount: 10,
                //       separatorBuilder: (_, _) => const SizedBox(height: 25),
                //       itemBuilder: (context, i) {
                //         return UserTile(
                //           name: 'Nurtilek',
                //           lastMessage:
                //               'bro go to afsasdb asfdg wert werthy retqwer gtrewgwt r wet',
                //           time: '22 июня',
                //         );
                //       },
                //     ),
                //   ),
                if (isEmpty = true) Center(child: EmptyChatWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            onTap: () {},
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
