import 'package:get/get.dart';
import 'package:first_app/resources/intl/string_en.dart';
import 'package:first_app/resources/intl/string_fr.dart';

class StringResI18n extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": enStringMap,
    "en_UK": enStringMap,
    "en_CA": enStringMap,
    "en_AU": enStringMap,
    "en_IN": enStringMap,
    "fr_FR": frStringMap,
    "fr_CA": frStringMap,
    "fr_BE": frStringMap,
    "fr_CH": frStringMap,
    "fr_LU": frStringMap,
  };

}