

import '../block_member_entity.dart';
import '../list_user_entity.dart';
import '../user_photo_entity.dart';

class JsonConvert {
  JsonConvert._();

  static T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }

    String typeStr = T.toString();
    if (value is List) {
      return generateOBJList<T>(typeStr, value);
    }
    return _generateItemOBJ(typeStr, value) as T;
  }
}

M _generateItemOBJ<M>(String typeStr, dynamic jsonObj) {
  dynamic obj;
  switch (typeStr) {
    case "BlockMemberEntity":
      obj = BlockMemberEntity.fromJson(jsonObj);
      break;

    case 'UserPhotoEntity':
      obj = UserPhotoEntity.fromJson(jsonObj);
      break;

    case "ListUserEntity":
      obj = ListUserEntity.fromJson(jsonObj);
      break;
  }
  return obj as M;
}

T generateOBJList<T>(String typeStr, List data) {
  typeStr = typeStr.substring(5, typeStr.length - 1);
  late List list;
  switch (typeStr) {

    case "ListUserEntity":
      list = data.map((e) => _generateItemOBJ<ListUserEntity>(typeStr, e)).toList();
      break;
  }
  return list as T;
}
