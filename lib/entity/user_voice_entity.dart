import 'dart:convert';
import 'json_format/json_format.dart';

class UserVoiceEntity {
  UserVoiceEntity({
    this.attachId,
    this.description,
    this.duration,
    this.voiceId,
    this.status,
    this.voiceUrl
  });

  factory UserVoiceEntity.fromJson(Map<String, dynamic> jsonRes) => UserVoiceEntity(
    description: asT<String?>(jsonRes['description']),
    attachId: asT<String?>(jsonRes['attachId']),
    duration: asT<String?>(jsonRes['duration']),
    voiceId: asT<String?>(jsonRes['voiceId']),
    status: asT<String?>(jsonRes['status']),
    voiceUrl: asT<String?>(jsonRes['voiceUrl']),
  );

  String? description;
  String? attachId;
  String? duration;
  String? status;
  String? voiceUrl;
  String? voiceId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'description': description,
    'attachId': attachId,
    'duration': duration,
    'String': voiceId,
    'status': status,
    'voiceUrl': voiceUrl,
  };

  UserVoiceEntity clone() => UserVoiceEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
