import 'dart:convert';

import 'json_format/json_format.dart';



class PromptNoPhotoEntity {
  PromptNoPhotoEntity({
    this.dontRemindNonphoto,
    this.nonphotoUpdateTime,
  });

  factory PromptNoPhotoEntity.fromJson(Map<String, dynamic> jsonRes) =>
      PromptNoPhotoEntity(
        dontRemindNonphoto: asT<String?>(jsonRes['dont_remind_nonphoto']),
        nonphotoUpdateTime: asT<String?>(jsonRes['nonphoto_update_time']),
      );

  String? dontRemindNonphoto;
  String? nonphotoUpdateTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dont_remind_nonphoto': dontRemindNonphoto,
    'nonphoto_update_time': nonphotoUpdateTime,
  };

  PromptNoPhotoEntity clone() => PromptNoPhotoEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
