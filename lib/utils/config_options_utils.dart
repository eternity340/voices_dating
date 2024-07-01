
import 'dart:convert';

import '../constants/constant_data.dart';
import '../entity/user_options_entity.dart';
import 'shared_preference_util.dart';

class ConfigOptionsUtils {

  static  UserOptionsEntity? profileOptionEntity;

  static List<int> calculatedKey(int key) {
    var list = <int>[];
    for (int i = 0; i < 32; i++) {
      var value = (key & (0x01 << i));
      if (value != 0) {
        list.add(value);
      }
    }
    return list;
  }

  static String getValueByKey({required ProfileType type, required int key}) {

    List<OptionItem> listData = getOptionType(type: type)!;
    int index  = listData.indexWhere((element){
      return element.id==key.toString();
    });
    if(index>=0) {
      return listData[index].label??"";
    } else {
      return "";
    }

  }

  static String getValueByCalculatedKey({required ProfileType type, required int key}) {

    var items = calculatedKey(key);
    var values = <String>[];
    for (var item in items) {
      var value = getValueByKey(type: type,key: item);
      if (value.isNotEmpty) {
        values.add(value);
      }
    }
    if (values.isNotEmpty) {
      return values.join(", ");
    } else {
      return "";
    }
  }

  static int getKeyByValue({required ProfileType type, required String value}) {
    int valueKey = 0;
    List<OptionItem> listData = getOptionType(type: type)!;

    try {
      for (var item in listData) {
        if (item.label == value) {
          valueKey = int.tryParse(item.id!)??0;
          break;
        }
      }
    } catch (e) {}
    return valueKey;
  }

  // static int getKeyByValue(List<OptionItem> dataList, String valueStr) {
  //   int valueKey = 0;
  //   try {
  //     for (var item in dataList) {
  //       if (item.label == valueStr) {
  //         valueKey = int.tryParse(item.id!)??0;
  //         break;
  //       }
  //     }
  //   } catch (e) {}
  //   return valueKey;
  // }

  static int getCalculatedKeyByValue({required ProfileType type, required String value}) {
    int valueKey = 0;
    // List<String> valueList = valueStr.split(",");
    List<OptionItem> dataList = getOptionType(type: type)!;

    for (var item in dataList) {
      if (value.contains(item.label??"")) {
        valueKey += int.parse(item.id!);
      }
    }
    return valueKey;
  }

  static int getCalculatedKeyByList(
      List<OptionItem> typeList, List<String> dataList) {
    int valueKey = 0;
    for (var item in typeList) {
      if (dataList.contains(item.label)) {
        valueKey += int.parse(item.id!);
      }
    }
    return valueKey;
  }

  static int getCalculatedKeyByListMap(
      Map<int, String> map, List<String> dataList) {
    int valueKey = 0;
    map.forEach((key,value) {
      if (dataList.contains(value)) {
        valueKey += key;
      }
    });
    return valueKey;
  }

  static String getValueByCalculatedKeyMap(Map<int, String> map, int key) {
    var items = calculatedKey(key);
    var values = [];
    for (var item in items) {
      var value = getValueByKeyMap(map, item);
      if (value.isNotEmpty) {
        values.add(value);
      }
    }
    if (values.isNotEmpty) {
      return values.join(",");
    } else {
      return "";
    }
  }

  static String getValueByKeyMap(Map<int, String> map, int key) {
    if (map.containsKey(key)) {
      String value = map[key]??"";
      if (value.contains("leave this blank")) {
        return "";
      }
      return map[key]??"";
    }
    return "";
  }

  static updateConfigData({required UserOptionsEntity profileData}) {
    profileOptionEntity = profileData;
    SharedPreferenceUtil().setValue(key: SharedPresKeys.localProfileOptions, value: json.encode(profileData));
  }

  static List<OptionItem>? getOptionType({required ProfileType type}){
    if(profileOptionEntity==null){
      String? jsonData =  SharedPreferenceUtil().getValue(key: SharedPresKeys.localProfileOptions);
      if(jsonData!=null) {
        profileOptionEntity = UserOptionsEntity.fromJson(json.decode(jsonData));
      }else{
        return [];
      }
    }
    switch(type){
      case ProfileType.body:
        return profileOptionEntity?.body;
      case ProfileType.distance:
        return profileOptionEntity?.distance;
      case ProfileType.drink:
        return profileOptionEntity?.drink;
      case ProfileType.education:
        return profileOptionEntity?.education;
      case ProfileType.ethnicity:
        return profileOptionEntity?.ethnicity;
      case ProfileType.eyes:
        return profileOptionEntity?.eyes;
      case ProfileType.favoriteMusic:
        return profileOptionEntity?.favoriteMusic;
      case ProfileType.gender:
        return profileOptionEntity?.gender;
      case ProfileType.hair:
        return profileOptionEntity?.hair;
      case ProfileType.haveChildren:
        return profileOptionEntity?.haveChildren;
      case ProfileType.height:
        return profileOptionEntity?.height;
      case ProfileType.hobby:
        return profileOptionEntity?.hobby;
      case ProfileType.income:
        return profileOptionEntity?.income;
      case ProfileType.language:
        return profileOptionEntity?.language;
      case ProfileType.marital:
        return profileOptionEntity?.marital;
      case ProfileType.occupation:
        return profileOptionEntity?.occupation;
      case ProfileType.paymentType:
        return profileOptionEntity?.paymentType;
      case ProfileType.personality:
        return profileOptionEntity?.personality;
      case ProfileType.pet:
        return profileOptionEntity?.pet;
      case ProfileType.politicalBelief:
        return profileOptionEntity?.politicalBelief;
      case ProfileType.relation:
        return profileOptionEntity?.relation;
      case ProfileType.relationship:
        return profileOptionEntity?.relationship;
      case ProfileType.religion:
        return profileOptionEntity?.religion;
      case ProfileType.sign:
        return profileOptionEntity?.sign;
      case ProfileType.smoke:
        return profileOptionEntity?.smoke;
      case ProfileType.wantChildren:
        return profileOptionEntity?.wantChildren;
      default:
        return <OptionItem>[];
    }
  }

  static List<String> getOptionLabelList({required ProfileType type}) {
    List<OptionItem>? dataList =  getOptionType(type: type);
    List<String> labelList = [];
    if(dataList!=null) {
      for (OptionItem item in dataList) {
        labelList.add(item.label!);
      }
    }
    return labelList;
  }


  static final typePrivateAlbumStatus = {
    0: "Request to View",
    1: "Approved",
    2: "Access Requested",
    3: "Rejected",
    4: "Hidden",
    5: "Hidden"
  };

}

enum ProfileType {
  body,
  distance,
  drink,
  education,
  ethnicity,
  eyes,
  favoriteMusic,
  gender,
  hair,
  haveChildren,
  height,
  hobby,
  income,
  language,
  marital,
  occupation,
  paymentType,
  personality,
  pet,
  politicalBelief,
  relation,
  relationship,
  religion,
  sign,
  smoke,
  wantChildren,
}
