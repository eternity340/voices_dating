// 在 lib/utils/event_bus.dart 中
import 'package:get/get.dart';

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _userReported = RxString('');

  void reportUser(String userId) {
    _userReported.value = userId;
  }

  Stream<String> get onUserReported => _userReported.stream;
}
