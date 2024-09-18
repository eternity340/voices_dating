import 'dart:convert';
import 'dart:io';

class Base64Util {
  /// 将字符串编码为 Base64
  static String encode(String data) {
    return base64.encode(utf8.encode(data));
  }

  /// 将 Base64 解码为字符串
  static String decode(String data) {
    return utf8.decode(base64.decode(data));
  }



  /// 将 JSON 对象编码为 Base64
  static String encodeJson(Map<String, dynamic> json) {
    return encode(jsonEncode(json));
  }

  static dynamic decodeJson(String data) {
    return jsonDecode(decode(data));
  }

  /// 格式化并打印 JSON 对象
  static void printFormattedJson(dynamic json) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    print(encoder.convert(json));
  }

  /// 解码 Base64 并格式化打印 JSON
  static void decodeAndPrintJson(String base64Data) {
    try {
      dynamic json = jsonDecode(utf8.decode(base64.decode(base64Data)));
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      print(encoder.convert(json));
    } catch (e) {
      print("Error decoding or parsing JSON: $e");
    }
  }

  /// 从控制台读取 JSON 输入
  static Map<String, dynamic>? readJsonFromConsole() {
    print(
        "请输入 JSON 数据（输入完成后请按回车键，然后输入 'END' 并再次按回车结束输入）：");
    String jsonString = "";
    while (true) {
      String? line = stdin.readLineSync();
      if (line?.trim().toUpperCase() == 'END') break;
      if (line != null) jsonString += line;
    }

    if (jsonString
        .trim()
        .isEmpty) {
      print("输入为空，请重新运行程序并输入有效的 JSON 数据。");
      return null;
    }

    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print("JSON 解析错误：$e");
      print("请确保输入的是有效的 JSON 格式。");
      return null;
    }
  }

  String decodeBase64ToJson(String base64String) {
    try {
      List<int> bytes = base64.decode(base64String);
      String jsonString = utf8.decode(bytes);
      return jsonString;
    } catch (e) {
      return "Error decoding Base64: $e";
    }
  }
}

void main() {
  String base64Data = "W3siYXR0YWNoSWQiOjIyOTQ4NjMyLCJ1cmwiOiJodHRwczovL3BpYy52b2ljZXNkYXRpbmcuY29tL2IvN2RjMDAzNzYwMDNhMWZjMGI2MzQ0NjczY2QxN2JkOGIuanBnIiwid2lkdGgiOjg1OCwiaGVpZ2h0IjoxMTAwLCJoYXNGYWNlIjoxfV0=";
  try {
    dynamic decodedData = Base64Util.decodeJson(base64Data);
    Base64Util.printFormattedJson(decodedData);
  } catch (e) {
    print("Error decoding or parsing JSON: $e");
  }
}