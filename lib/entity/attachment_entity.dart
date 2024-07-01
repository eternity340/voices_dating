import 'dart:convert';

import 'attach_video_entity.dart';
import 'json_format/json_format.dart';




class AttachmentEntity {
  AttachmentEntity({
    this.id,
    this.url,
    this.duration,
    this.cover,
    this.video,
    this.type,
    this.width,
    this.height,
  });

  factory AttachmentEntity.fromJson(Map<String, dynamic> jsonRes) =>
      AttachmentEntity(
        id: asT<String?>(jsonRes['id']),
        url: asT<String?>(jsonRes['url']),
        duration: asT<int?>(jsonRes['duration']),
        type: asT<int?>(jsonRes['type']),
        width: asT<int?>(jsonRes['width']),
        height: asT<int?>(jsonRes['height']),
        cover: jsonRes['cover'] == null
            ? null
            : AttachVideoEntity.fromJson(
            asT<Map<String, dynamic>>(jsonRes['cover'])!),
        video: jsonRes['video'] == null
            ? null
            : AttachVideoEntity.fromJson(
            asT<Map<String, dynamic>>(jsonRes['video'])!),
      );

  String? id;
  String? url;
  int? duration;
  AttachVideoEntity? cover;
  AttachVideoEntity? video;
  int? type;
  int? width;
  int? height;


  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'url': url,
    'duration': duration,
    'cover': cover,
    'video': video,
    'type': type,
    'width': width,
    'height': height,
  };

  AttachmentEntity clone() => AttachmentEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
