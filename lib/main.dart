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
  Brightness _brightness = Brightness.light;
  double _fontSize = 15;

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
        brightness: _brightness,
        primarySwatch: Colors.blueGrey,

        // Define the default font family.
        // fontFamily: 'New Roman',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: _fontSize),
          bodyText2: TextStyle(fontSize: _fontSize, color: Colors.white),
          subtitle1: TextStyle(fontSize: _fontSize, color: Colors.black),
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
              Column(children: [
                Image(image: AssetImage('assets/9302004.jpg')),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Dark Mode",
                          style: TextStyle(
                              color: _brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.blueGrey)),
                    ),
                    Switch(
                      value: _brightness == Brightness.dark,
                      onChanged: (value) => setState(() {
                        _brightness =
                            value ? Brightness.dark : Brightness.light;
                      }),
                      activeColor: Colors.lightBlueAccent,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "字體大小",
                    style: TextStyle(
                        color: _brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blueGrey),
                    textAlign: TextAlign.left,
                  ),
                ),
                Slider(
                  value: _fontSize,
                  onChanged: (value) => {
                    setState(() {
                      _fontSize = value;
                    })
                  },
                  label: "Font Size",
                  min: 10,
                  max: 20,
                )
              ]),
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
                title: Text(
                  "來聊天！",
                  style: TextStyle(fontSize: 20),
                ),
                icon: Icon(Icons.chat_bubble),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("台語辭典", style: TextStyle(fontSize: 18)),
                icon: Icon(Icons.book),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("台語怎麼說", style: TextStyle(fontSize: 16)),
                icon: Icon(Icons.transcribe),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                title: Text("設定", style: TextStyle(fontSize: 20)),
                icon: Icon(Icons.settings),
                activeColor: Colors.lightBlueAccent,
                inactiveColor: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
