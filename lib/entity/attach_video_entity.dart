import 'json_format/json_format.dart';
import 'dart:convert';

class AttachVideoEntity {
  AttachVideoEntity({
    this.duration,
    this.height,
    this.id,
    this.status,
    this.type,
    this.url,
    this.moderationLabelScore,
  });

  factory AttachVideoEntity.fromJson(Map<String, dynamic> jsonRes) =>
      AttachVideoEntity(
        duration: asT<int?>(jsonRes['duration']),
        height: asT<int?>(jsonRes['height']),
        id: asT<String?>(jsonRes['id']),
        status: asT<String?>(jsonRes['status']),
        type: asT<String?>(jsonRes['type']),
        url: asT<String?>(jsonRes['url']),
        moderationLabelScore: jsonRes['moderationLabelScore'] == null
            ? null
            : ModerationLabelScore.fromJson(
            asT<Map<String, dynamic>>(jsonRes['moderationLabelScore'])!),
      );

  int? duration;
  int? height;
  String? id;
  String? status;
  String? type;
  String? url;
  ModerationLabelScore? moderationLabelScore;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'duration': duration,
    'height': height,
    'id': id,
    'status': status,
    'type': type,
    'url': url,
    'moderationLabelScore': moderationLabelScore,
  };

  AttachVideoEntity clone() => AttachVideoEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ModerationLabelScore {
  ModerationLabelScore({
    this.nudity,
    this.suggestive,
  });

  factory ModerationLabelScore.fromJson(Map<String, dynamic> jsonRes) =>
      ModerationLabelScore(
        nudity: asT<String?>(jsonRes['nudity']),
        suggestive: asT<String?>(jsonRes['suggestive']),
      );

  String? nudity;
  String? suggestive;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'nudity': nudity,
    'suggestive': suggestive,
  };

  ModerationLabelScore clone() => ModerationLabelScore.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}