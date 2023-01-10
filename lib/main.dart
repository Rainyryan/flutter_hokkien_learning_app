import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hokkien_learning_app/page/TranscribePage.dart';
import 'utils/wp_http.dart';
import 'page/ChatPage.dart';
import 'page/DictionaryPage.dart';

void main() {
  DioHttpUtil().init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  int _curentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,

        // Define the default font family.
        // fontFamily: 'New Roman',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 15.0),
          bodyText2: TextStyle(fontSize: 15, color: Colors.white),
          subtitle1: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      // ThemeData(
      //   primarySwatch: Colors.green,
      //   backgroundColor: Colors.black,
      // ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 25,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('來學台語'),
            ],
          ),
          // backgroundColor:,
        ),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _curentIndex = index;
              });
            },
            children: [
              ChatPage(title: "Chat"),
              DictionaryPage(title: "Dictionary"),
              TranscribePage(title: "Transcribe"),
              Column(
                  children: [Image(image: AssetImage('assets/9302004.jpg'))]),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          itemCornerRadius: 18,
          selectedIndex: _curentIndex,
          onItemSelected: (index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text("來聊天！"),
                icon: Icon(Icons.chat_bubble),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("台語辭典"),
                icon: Icon(Icons.book),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("台語怎麼說"),
                icon: Icon(Icons.transcribe),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("Settings"),
                icon: Icon(Icons.settings),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
