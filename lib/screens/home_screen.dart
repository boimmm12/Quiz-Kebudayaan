import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_app/common/alert_util.dart';
import 'package:flutter_quiz_app/common/theme_helper.dart';
import 'package:flutter_quiz_app/stores/quiz_store.dart';
import 'package:flutter_quiz_app/widgets/disco_button.dart';

import 'quiz_category.dart';
import 'quiz_history_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final QuizStore _quizStore = QuizStore();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: navigationDrawer(),
        body: Container(
          alignment: Alignment.center,
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: Column(
            children: [
              drawerToggleButton(),
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 7 / 100,
                  )),
                  Image(
                    image: AssetImage("assets/images/logojabar.png"),
                    fit: BoxFit.fitHeight,
                    width: MediaQuery.of(context).size.height * 30 / 100,
                  ),
                  headerText("Quiz Kebudayaan"),
                  SizedBox(height: 15),
                  Padding(
                      padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 1 / 100,
                  )),
                  ...homeScreenButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Quiz Kebudayaan",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                Text(
                  "Version: 1.00",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Start Random Quiz'),
            onTap: () async {
              var quiz = await _quizStore.getRandomQuizAsync();
              Navigator.pushNamed(context, "/quiz", arguments: quiz);
            },
          ),
          ListTile(
            title: const Text('Quiz Category'),
            onTap: () {
              Navigator.pushNamed(context, QuizCategoryScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Quiz History'),
            onTap: () {
              Navigator.pushNamed(context, QuizHistoryScreen.routeName);
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              AlertUtil.showAlert(context, "About us",
                  "Penulisan Ilmiah Universitas Gunadarma");
            },
          ),
          ListTile(
            title: const Text('Exit'),
            onTap: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget drawerToggleButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Image(
          image: AssetImage("assets/icons/menu.png"),
          width: 36,
        ),
        onTap: () {
          _key.currentState!.openDrawer();
        },
      ),
    );
  }

  Text headerText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 50,
          color: ThemeHelper.accentColor,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: ThemeHelper.shadowColor,
                offset: Offset(-5, 5),
                blurRadius: 30)
          ]),
    );
  }

  List<Widget> homeScreenButtons(BuildContext context) {
    return [
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, QuizCategoryScreen.routeName);
        },
        child: Text(
          "Start Quiz",
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        isActive: true,
      ),
      DiscoButton(
        onPressed: () async {
          var quiz = await _quizStore.getRandomQuizAsync();
          Navigator.pushNamed(context, "/quiz", arguments: quiz);
        },
        child: Text(
          "Random Quiz",
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        isActive: true,
      ),
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, QuizHistoryScreen.routeName);
        },
        child: Text(
          "Quiz History",
          style: TextStyle(fontSize: 30, color: ThemeHelper.primaryColor),
        ),
      ),
    ];
  }
}
