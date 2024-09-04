import 'package:first_app/utils/replace_word_util.dart';

extension StringExt on String? {
  String replaceWord(bool isSelf) {
    if (this == null || this!.isEmpty) {
      return '';
    }
    if (isSelf) {
      return this!;
    }

    String temp = this!;

    var women = [
      "sugar baby",
      "sugarbaby",
      "suger baby",
      "sugar babies",
      "sugar mommy",
      "sugar momma",
      "sugar mama",
      "sugar mummies",
      "sugar mommas",
      "sugar mamas",
      "sugarmummies",
      "sugarmommies",
      "sugarmamas"
    ];

    var man = [
      "sugar daddy",
      "sugardaddy",
      "suger daddy",
      "sugar daddies",
      "sugardaddies",
      "Sugardaddy"
      'sugar',
    ];

    for (var element in women) {
      temp = temp.replaceAll(RegExp(element, caseSensitive: false), "*");
    }
    for (var element in man) {
      temp = temp.replaceAll(RegExp(element, caseSensitive: false), "*");
    }
    ReplaceWordUtil.words.forEach((key, value) {
      temp = temp.replaceAll(RegExp(key, caseSensitive: false), value);
    });
    return temp;
  }

  bool isNullOrEmpty() {
    if (this == null) {
      return true;
    }
    return this!.trim().isEmpty;
  }

  String? replaceBreak() {
    if (this == null || this!.isEmpty) {
      return this;
    }
    return this!.replaceAll(RegExp("\\s{2,}|\t|\r|\n"), '\n');
  }
}
