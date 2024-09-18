import 'dart:convert';
import 'json_format/json_format.dart';

class UploadFileEntity {
  UploadFileEntity({
    this.attachId,
    this.url,
    this.width,
    this.height,
    this.hasFace,
  });

  factory UploadFileEntity.fromJson(Map<String, dynamic> jsonRes) => UploadFileEntity(
    attachId: asT<String?>(jsonRes['attachId']),
    height: asT<String?>(jsonRes['height']),
    url: asT<String?>(jsonRes['url']),
    width: asT<String?>(jsonRes['width']),
    hasFace: asT<String?>(jsonRes['hasFace'])
  );

  String? attachId;
  String? height;
  String? url;
  String? width;
  String? hasFace;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'attachId': attachId,
    'height': height,
    'url': url,
    'width': width,
    'hasFace':hasFace
  };

  UploadFileEntity clone() => UploadFileEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
