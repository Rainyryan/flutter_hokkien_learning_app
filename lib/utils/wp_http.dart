import 'package:dio/dio.dart';

import 'constants.dart';

class DioHttpUtil {
  static final DioHttpUtil _instance = DioHttpUtil._internal();
  factory DioHttpUtil() => _instance;
  DioHttpUtil._internal();

  late Dio _dio;

  // initialie dio
  Dio init() {
    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: openaiBaseUrl,
      connectTimeout: 10000, // 10秒
      receiveTimeout: 5000, // 5秒
      headers: {
        "Authorization": 'Bearer $openaiApiKey',
      },
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    return _dio;
  }

  // post request
  Future<Response> post(String url,
      {required Map<String, dynamic> data}) async {
    Response response = await _dio.post(url, data: data);
    return response;
  }

  Future<String> complete(String prompt) async {
    var res = await post("/completions", data: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "temperature": 1.3,
      "max_tokens": 128,
    });
    if (res.data["choices"] != null) {
      return res.data["choices"][0]["text"].toString();
    }
    return "-1";
  }
}
