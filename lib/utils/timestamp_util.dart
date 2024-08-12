import 'package:intl/intl.dart';

class TimestampUtil {
  // 将秒时间戳转换为指定格式的日期字符串
  static String timestampToString(int secondsTimestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(secondsTimestamp * 1000);
    return DateFormat(format).format(dateTime);
  }

  // 将日期字符串转换为秒时间戳
  static int stringToTimestamp(String dateString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    DateTime dateTime = DateFormat(format).parse(dateString);
    return (dateTime.millisecondsSinceEpoch / 1000).round();
  }

  // 获取当前秒时间戳
  static int getCurrentTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch / 1000).round();
  }

  // 获取今天的开始时间戳（秒）
  static int getTodayStartTimestamp() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    return (startOfDay.millisecondsSinceEpoch / 1000).round();
  }

  // 获取今天的结束时间戳（秒）
  static int getTodayEndTimestamp() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return (endOfDay.millisecondsSinceEpoch / 1000).round();
  }

  // 计算两个时间戳之间的差值（返回Duration对象）
  static Duration getTimestampDifference(int startTimestamp, int endTimestamp) {
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startTimestamp * 1000);
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTimestamp * 1000);
    return endDate.difference(startDate);
  }

  // 将秒时间戳转换为相对时间描述
  static String getRelativeTimeDescription(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365}年前';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}个月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inSeconds > -60) {
      return '刚刚';
    } else if (difference.inMinutes > -60) {
      return '${-difference.inMinutes}分钟后';
    } else if (difference.inHours > -24) {
      return '${-difference.inHours}小时后';
    } else if (difference.inDays > -30) {
      return '${-difference.inDays}天后';
    } else if (difference.inDays > -365) {
      return '${-difference.inDays ~/ 30}个月后';
    } else {
      return '${-difference.inDays ~/ 365}年后';
    }
  }

  // 检查时间戳是否为未来时间
  static bool isFutureTimestamp(int timestamp) {
    return timestamp > getCurrentTimestamp();
  }

  // 获取时间戳信息的综合方法
  static Map<String, dynamic> getTimestampInfo(int timestamp) {
    String formattedDate = timestampToString(timestamp);
    String relativeTime = getRelativeTimeDescription(timestamp);
    bool isFuture = isFutureTimestamp(timestamp);

    return {
      'formatted_date': formattedDate,
      'relative_time': relativeTime,
      'is_future': isFuture,
    };
  }
}

void main() {
  int timestamp = 1723428428;

  print('时间戳: $timestamp');
  print('格式化日期: ${TimestampUtil.timestampToString(timestamp)}');
  print('相对时间: ${TimestampUtil.getRelativeTimeDescription(timestamp)}');
  print('是否是未来时间: ${TimestampUtil.isFutureTimestamp(timestamp)}');

  // 使用综合方法
  Map<String, dynamic> info = TimestampUtil.getTimestampInfo(timestamp);
  print('综合信息:');
  print('  格式化日期: ${info['formatted_date']}');
  print('  相对时间: ${info['relative_time']}');
  print('  是否是未来时间: ${info['is_future']}');

  // 获取当前时间戳
  int currentTimestamp = TimestampUtil.getCurrentTimestamp();
  print('当前时间戳: $currentTimestamp');
  print('当前格式化日期: ${TimestampUtil.timestampToString(currentTimestamp)}');
}
