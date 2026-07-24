import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final getterStyle = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Профиль',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  color: getterStyle.primaryColor,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Expanded(
            child: ColoredBox(
              color: const Color.fromARGB(17, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    color: const Color.fromARGB(213, 227, 239, 249),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 50, 40, 40),
                    color: Colors.white,
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Мария Ковалева',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight(600),
                            ),
                          ),
                          Text(
                            'maria@email.com',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                              fontWeight: FontWeight(400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                    child: Text(
                      'НАСТРОЙКИ',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 17,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 155,
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(12, 8, 19, 8),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: getterStyle.dividerColor,
                                        ),
                                        height: 980,
                                        width: 40,
                                        child: Icon(Icons.public_rounded),
                                      ),

                                      Text(
                                        'Язык',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Russian',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight(500),
                                          color: Colors.black38,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        CupertinoIcons.forward,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 2,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(12, 8, 19, 8),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: getterStyle.dividerColor,
                                        ),
                                        height: 980,
                                        width: 40,
                                        child: Icon(Icons.dark_mode_outlined),
                                      ),
                                      Text(
                                        'Тёмная тема',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Spacer(),
                                      CupertinoSwitch(
                                        activeTrackColor:
                                            getterStyle.primaryColor,
                                        value: isSwitched,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              246,
                              9,
                              9,
                            ).withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          width: 0.5,
                          color: Color.fromARGB(255, 246, 9, 9),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red.shade500,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Выйти',
                            style: TextStyle(
                              color: Colors.red.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 125,
          left: MediaQuery.of(context).size.width / 2 - 60, // 60 = radius
          child: Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(
              border: Border.all(width: 5, color: Colors.white),
              color: const Color.fromARGB(255, 224, 231, 234),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: const Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.circular(100),
              child: Center(
                child: Text(
                  'MK',
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight(600),
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
