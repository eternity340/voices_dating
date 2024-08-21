import 'dart:math';

class DateTimeFormat{

  static const String enDateFormat = "MMM dd, yyyy";

  static List<String> getMonths() {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
  }

  static List<String> getMonthsShort() {
    return [
      "Jan.",
      "Feb.",
      "Mar.",
      "Apr.",
      "May",
      "Jun",
      "Jul.",
      "Aug.",
      "Sep.",
      "Oct.",
      "Nov.",
      "Dec.",
    ];
  }

  static List<String> getWeeksFull() {
    return [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
  }


  static List<String> getWeeksShort() {
    return [
      "Mon",
      "Tue",
      "Wed",
      "Thur",
      "Fri",
      "Sat",
      "Sun",
    ];
  }

  static const String DATE_FORMAT_SEPARATOR = r'[|,-\._: ]+';


  /// Check if the date format is for day(contain y、M、d、E) or not.
  static bool isDayFormat(String format) {
  return format.contains(RegExp(r'[yMdE]'));
  }

  /// Check if the date format is for time(contain H、m、s) or not.
  static bool isTimeFormat(String format) {
  return format.contains(RegExp(r'[Hms]'));
  }

  /// Format datetime string
  static String formatDateTime(
  int value, String format) {
  if (format == null || format.length == 0) {
  return value.toString();
  }

  String result = format;
  // format year text
  if (format.contains('y')) {
  result = _formatYear(value, result);
  }
  // format month text
  if (format.contains('M')) {
  result = _formatMonth(value, result);
  }
  // format day text
  if (format.contains('d')) {
  result = _formatDay(value, result);
  }
  if (format.contains('E')) {
  result = _formatWeek(value, result);
  }
  // format hour text
  if (format.contains('H')) {
  result = _formatHour(value, result);
  }
  // format minute text
  if (format.contains('m')) {
  result = _formatMinute(value, result);
  }
  // format second text
  if (format.contains('s')) {
  result = _formatSecond(value, result);
  }
  if (result == format) {
  return value.toString();
  }
  return result;
  }

  /// Format day display
  static String formatDate(
  DateTime dateTime, String format) {
  if (format == null || format.length == 0) {
  return dateTime.toString();
  }

  String result = format;
  // format year text
  if (format.contains('y')) {
  result = _formatYear(dateTime.year, result);
  }
  // format month text
  if (format.contains('M')) {
  result = _formatMonth(dateTime.month, result);
  }
  // format day text
  if (format.contains('d')) {
  result = _formatDay(dateTime.day, result);
  }
  if (format.contains('E')) {
  result = _formatWeek(dateTime.weekday, result);
  }

  if (format.contains('H')) {
  result = _formatHour(dateTime.hour, result);
  }
  // format minute text
  if (format.contains('m')) {
  result = _formatMinute(dateTime.minute, result);
  }

  if (result == format) {
  return dateTime.toString();
  }
  return result;
  }

  /// format year text
  static String _formatYear(
  int value, String format) {
  if (format.contains('yyyy')) {
  // yyyy: the digit count of year is 4, e.g. 2019
  return format.replaceAll('yyyy', value.toString());
  } else if (format.contains('yy')) {
  // yy: the digit count of year is 2, e.g. 19
  return format.replaceAll('yy',
  value.toString().substring(max(0, value.toString().length - 2)));
  }
  return value.toString();
  }

  /// format month text
  static String _formatMonth(
  int value, String format) {
  List<String> months = getMonths();
  if (format.contains('MMMM')) {
  // MMMM: the full name of month, e.g. January
  return format.replaceAll('MMMM', months[value - 1]);
  } else if (format.contains('MMM')) {
  // MMM: the short name of month, e.g. Jan
  String month = months[value - 1];
  return format.replaceAll('MMM', month.substring(0, min(3, month.length)));
  }
  return _formatNumber(value, format, 'M');
  }

  /// format day text
  static String _formatDay(
  int value, String format) {
  return _formatNumber(value, format, 'd');
  }

  /// format week text
  static String _formatWeek(
  int value, String format) {
  if (format.contains('EEEE')) {
  // EEEE: the full name of week, e.g. Monday
  List<String> weeks = getWeeksFull();
  return format.replaceAll('EEEE', weeks[value - 1]);
  }
  // EEE: the short name of week, e.g. Mon
  List<String> weeks = getWeeksShort();
  return format.replaceAll(RegExp(r'E+'), weeks[value - 1]);
  }

  /// format hour text
  static String _formatHour(
  int value, String format) {
  return _formatNumber(value, format, 'H');
  }

  /// format minute text
  static String _formatMinute(
  int value, String format,) {
  return _formatNumber(value, format, 'm');
  }

  /// format second text
  static String _formatSecond(
  int value, String format) {
  return _formatNumber(value, format, 's');
  }

  /// format number, if the digit count is 2, will pad zero on the left
  static String _formatNumber(int value, String format, String unit) {
  if (format.contains('$unit$unit')) {
  return format.replaceAll('$unit$unit', value.toString().padLeft(2, '0'));
  } else if (format.contains('$unit')) {
  return format.replaceAll('$unit', value.toString());
  }
  return value.toString();
  }

}