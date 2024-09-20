import 'dart:convert';

import 'package:voices_dating/entity/json_format/json_format.dart';

class ReportReasonEntity {
  String? descr;
  String? id;
  List<ReportReasonEntityItems>? items;

  ReportReasonEntity({
    this.descr,
    this.id,
    this.items,
  });

  factory ReportReasonEntity.fromJson(Map<String, dynamic> jsonRes) {
    final List<ReportReasonEntityItems>? items =
    jsonRes['items'] is List ? <ReportReasonEntityItems>[] : null;
    if (items != null) {
      for (final dynamic item in jsonRes['items']!) {
        if (item != null) {
          tryCatch(() {
            items.add(asT<ReportReasonEntityItems>(item)!);
          });
        }
      }
    }

    return ReportReasonEntity(
        descr: asT<String?>(jsonRes['descr']),
        id: asT<String?>(jsonRes['id']),
        items: items);
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'descr': descr,
    'items': items,
  };

  ReportReasonEntity clone() => ReportReasonEntity.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ReportReasonEntityItems {
  String? descr;
  String? id;

  ReportReasonEntityItems({
    this.id,
    this.descr,
  });

  factory ReportReasonEntityItems.fromJson(Map<String, dynamic> jsonRes) =>
      ReportReasonEntityItems(
        id: asT<String?>(jsonRes['id']),
        descr: asT<String?>(jsonRes['descr']),
      );

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'descr': descr,
  };

  ReportReasonEntityItems clone() => ReportReasonEntityItems.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}