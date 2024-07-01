import 'dart:convert';

import 'json_format/json_format.dart';


class LanguageMatchInfoEntity {
  LanguageMatchInfoEntity({
    this.languageMatchedMe,
    this.languageMyMatched,
  });

  factory LanguageMatchInfoEntity.fromJson(Map<String, dynamic> json) =>
      LanguageMatchInfoEntity(
        languageMatchedMe: asT<int?>(json['languageMatchedMe']),
        languageMyMatched: asT<int?>(json['languageMyMatched']),
      );

  int? languageMatchedMe;
  int? languageMyMatched;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'languageMatchedMe': languageMatchedMe,
    'languageMyMatched': languageMyMatched,
  };
}
