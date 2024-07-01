import 'dart:convert';

import 'json_format/json_format.dart';

class UniversalPopEntity {
  UniversalPopEntity({
    this.buttons,
    this.canClose,
    this.cancelButtonText,
    this.confirmButtonText,
    this.content,
    this.createTime,
    this.endTime,
    this.id,
    this.platform,
    this.popupType,
    this.priority,
    this.showCancelButton,
    this.showConfirmButton,
    this.startTime,
    this.status,
    this.title,
  });

  factory UniversalPopEntity.fromJson(Map<String, dynamic> json) {
    final List<Buttons>? buttons = json['buttons'] is List ? <Buttons>[] : null;
    if (buttons != null) {
      for (final dynamic item in json['buttons']!) {
        if (item != null) {
          tryCatch(() {
            buttons.add(Buttons.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return UniversalPopEntity(
      buttons: buttons,
      canClose: asT<int?>(json['can_close']),
      cancelButtonText: asT<String?>(json['cancel_button_text']),
      confirmButtonText: asT<String?>(json['confirm_button_text']),
      content: asT<String?>(json['content']),
      createTime: asT<String?>(json['create_time']),
      endTime: asT<String?>(json['end_time']),
      id: asT<int?>(json['id']),
      platform: asT<int?>(json['platform']),
      popupType: asT<int?>(json['popup_type']),
      priority: asT<int?>(json['priority']),
      showCancelButton: asT<int?>(json['show_cancel_button']),
      showConfirmButton: asT<int?>(json['show_confirm_button']),
      startTime: asT<String?>(json['start_time']),
      status: asT<int?>(json['status']),
      title: asT<String?>(json['title']),
    );
  }

  List<Buttons>? buttons;
  int? canClose;
  String? cancelButtonText;
  String? confirmButtonText;
  String? content;
  String? createTime;
  String? endTime;
  int? id;
  int? platform;
  int? popupType;
  int? priority;
  int? showCancelButton;
  int? showConfirmButton;
  String? startTime;
  int? status;
  String? title;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'buttons': buttons,
    'can_close': canClose,
    'cancel_button_text': cancelButtonText,
    'confirm_button_text': confirmButtonText,
    'content': content,
    'create_time': createTime,
    'end_time': endTime,
    'id': id,
    'platform': platform,
    'popup_type': popupType,
    'priority': priority,
    'show_cancel_button': showCancelButton,
    'show_confirm_button': showConfirmButton,
    'start_time': startTime,
    'status': status,
    'title': title,
  };
}

class Buttons {
  Buttons({
    this.confirmButtonType,
    this.functionName,
    this.functionParam,
    this.id,
    this.popupId,
    this.url,
  });

  factory Buttons.fromJson(Map<String, dynamic> json) => Buttons(
    confirmButtonType: asT<int?>(json['confirm_button_type']),
    functionName: asT<String?>(json['function_name']),
    functionParam: asT<String?>(json['function_param']),
    id: asT<int?>(json['id']),
    popupId: asT<int?>(json['popup_id']),
    url: asT<String?>(json['url']),
  );

  int? confirmButtonType;
  String? functionName;
  String? functionParam;
  int? id;
  int? popupId;
  String? url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'confirm_button_type': confirmButtonType,
    'function_name': functionName,
    'function_param': functionParam,
    'id': id,
    'popup_id': popupId,
    'url': url,
  };
}
