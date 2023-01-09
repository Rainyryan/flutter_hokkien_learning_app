import 'dart:convert';
import 'dart:async';
import 'word.dart';
import 'package:http/http.dart' as http;


class WordModel {
  static Future<Word> getWord(String keyword) async {
    String my_url = 'https://www.moedict.tw/t/$keyword.json';
    String testurl = 'https://www.moedict.tw/t/%E7%99%BC%E7%A9%8E.json';
    final res = await http.get(
      Uri.parse(my_url),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return Word.fromJson(json);
    } else {
      return Word.notExist();
    }
  }
}
