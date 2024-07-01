import 'dart:convert';

import 'json_format/json_format.dart';


class PubMomentResult {
  PubMomentResult({
    required this.timelineId,
  });

  factory PubMomentResult.fromJson(Map<String, dynamic> jsonRes) => PubMomentResult(
    timelineId: asT<bool>(jsonRes['timelineId'], false) ?? false,
  );

  bool timelineId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'timelineId': timelineId,
  };

  PubMomentResult clone() => PubMomentResult.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
