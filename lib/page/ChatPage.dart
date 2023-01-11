import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hokkien_learning_app/utils/wp_http.dart';

import '../speech/socket_tts.dart';
import '../speech/sound_player.dart';
import '../speech/sound_recorder.dart';
import '../speech/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../speech/socket_stt.dart';
import '../main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  // get SoundRecorder
  final recorder = SoundRecorder();
  // get soundPlayer
  final player = SoundPlayer();

  // Declare TextEditingController to get the value in TextField
  TextEditingController taiwanessController = TextEditingController();
  TextEditingController chineseController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();

  final TextEditingController _chatController = TextEditingController();
  final List<Widget> _messages = [];

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // 設定不讓鍵盤技壓頁面
        resizeToAvoidBottomInset: false,

        // set background color
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: new EdgeInsets.all(8),
                itemBuilder: (context, index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Container(height: 50, child: buildRadio()),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  onSubmitted: (text) async {
                    if (_chatController.text.isEmpty) return;
                    _submitText(text, true);
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white30,
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    hintText: 'Type your message here...',
                  ),
                ),
              ),
              IconButton(
                color: recorder.isRecording ? Colors.red : Colors.white,
                onPressed: () async {
                  // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
                  Directory tempDir =
                      await path_provider.getTemporaryDirectory();
                  // define file directory
                  String path = '${tempDir.path}/SpeechRecognition.wav';
                  // 控制開始錄音或停止錄音
                  await recorder.toggleRecording(path);
                  // When stop recording, pass wave file to socket
                  if (!recorder.isRecording) {
                    if (recognitionLanguage == "Taiwanese") {
                      // if recognitionLanguage == "Taiwanese" => use Minnan model
                      // setTxt is call back function
                      // parameter: wav file path, call back function, model
                      await Speech2Text().connect(path, setTxt, "Minnan");
                      // glSocket.listen(dataHandler, cancelOnError: false);
                    } else {
                      // if recognitionLanguage == "Chinese" => use MTK_ch model
                      await Speech2Text().connect(path, setTxt, "MTK_ch");
                    }
                  }
                  // set state is recording or stop
                  setState(() {
                    recorder.isRecording;
                  });
                },
                icon: Icon(Icons.mic_none),
              ),
              IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_chatController.text.isEmpty) return;
                    var text = _chatController.text;
                    _submitText(text, true);
                    String reply = await DioHttpUtil().complete(text);
                    await Text2Speech().connect(
                        play, reply, recognitionLanguage.toLowerCase());
                    _submitText(reply, false);
                  }),
            ]),
          ],
        ),
      );

  void _submitText(String text, bool mine) {
    _chatController.clear();
    setState(() {
      _messages.insert(
        0,
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.5),
              // width: MediaQuery.of(context).size.width / 1.5,
              // width: _textSize(
              //         text,
              //         Theme.of(context).textTheme.bodyText2 ??
              //             TextStyle(fontSize: 15))
              //     .width,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: mine ? Colors.blueAccent : Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular((20)))),
              // alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                text,
                softWrap: true,
              ),
            )),
      );
    });
  }

  // Size _textSize(String text, TextStyle style) {
  //   final TextPainter textPainter = TextPainter(
  //       text: TextSpan(text: text, style: style),
  //       maxLines: 10,
  //       textDirection: TextDirection.ltr)
  //     ..layout(
  //         minWidth: MediaQuery.of(context).size.width / 10,
  //         maxWidth: MediaQuery.of(context).size.width / 1.2);
  //   print(textPainter.size.width);
  //   return textPainter.size;
  // }

  // set recognitionController.text function
  void setTxt(taiTxt) async {
    _chatController.text = taiTxt;
    _submitText(taiTxt, true);
    String reply = await DioHttpUtil().complete(taiTxt);
    await Text2Speech().connect(play, reply, recognitionLanguage.toLowerCase());
    // print(reply);
    setState(() {
      recognitionController.text = taiTxt;
    });
    _submitText(reply, false);
  }

  Widget buildTaiwaneseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: taiwanessController, // 為了獲得TextField中的value
        decoration: InputDecoration(
          fillColor: Colors.white, // 背景顏色，必須結合filled: true,才有效
          filled: true, // 重點，必須設定為true，fillColor才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.red, // 設定邊框的顏色
              width: 2, // 設定邊框的粗細
            ),
          ),
          hintText: txt, // 提示文字,
          suffixIcon: IconButton(
            // TextField 中最後可以選擇放入 Icon
            icon: const Icon(
              Icons.search, // Flutter 內建的搜尋 icon
              color: Colors.grey, // 設定 icon 顏色
            ),
            // 當 icon 被點擊時執行的動作
            onPressed: () async {
              // 得到 TextField 中輸入的 value
              String strings = taiwanessController.text;
              // 如果為空則 return
              if (strings.isEmpty) return;
              // connect to text2speech socket
              await Text2Speech().connect(play, strings, "taiwanese");
            },
          ),
        ),
      ),
    );
  }

  Future play(String pathToReadAudio) async {
    setState(() {
      // player.init();
      player.isPlaying;
    });
    await player.play(pathToReadAudio);
  }

  Widget buildChineseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: chineseController,
        decoration: InputDecoration(
          filled: true, //重點，必須設定為true，fillColor才有效
          fillColor: Colors.white, //背景顏色，必須結合filled: true,才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.red, // 設定邊框的顏色
              width: 2, // 設定邊框的粗細
            ),
          ),
          hintText: txt,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () async {
              // String strings = chineseController.text;
              // if (strings.isEmpty) return;
              // print(strings);
              // await Text2SpeechFlutter().speak(strings);
              // 得到 TextField 中輸入的 value

              String strings = chineseController.text;
              // 如果為空則 return
              if (strings.isEmpty) return;
              await Text2Speech().connect(play, strings, "chinese");
              // player.init();
              setState(() {
                // player.isPlaying;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: recognitionController, // 設定 controller
        enabled: false, // 設定不能接受輸入
        decoration: const InputDecoration(
          fillColor: Colors.white, // 背景顏色，必須結合filled: true,才有效
          filled: true, // 重點，必須設定為true，fillColor才有效
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
        ),
      ),
    );
  }

  // Use to choose language of speech recognition
  String recognitionLanguage = "Taiwanese";

  Widget buildRadio() {
    return Row(children: <Widget>[
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Taiwanese',
          // Set option name、color
          title: const Text(
            '台語',
            style: TextStyle(color: Colors.white),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Taiwanese";
            });
          },
        ),
      ),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Chinese',
          // Set option name、color
          title: const Text(
            '國語',
            style: TextStyle(color: Colors.white),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Chinese";
            });
          },
        ),
      ),
    ]);
  }
}
