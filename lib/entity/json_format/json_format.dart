import 'dart:developer';
import '../../utils/log_util.dart';
import '../attach_result_entity.dart';
import '../attachment_entity.dart';
import '../badge_entity.dart';
import '../chat_status_entity.dart';
import '../chatted_user_entity.dart';
import '../city_entity.dart';
import '../comment_entity.dart';
import '../comment_reply_entity.dart';
// import '../im_message_entity.dart';
// import '../im_new_message_emtity.dart';
import '../im_message_entity.dart';
import '../im_new_message_emtity.dart';
import '../language_match_info_entity.dart';
import '../list_user_entity.dart';
import '../match_age_entity.dart';
import '../moment_entity.dart';
import '../notification_entity.dart';
import '../partner_info_entity.dart';
import '../profile_comment_entity.dart';
import '../prompt_no_photo_entity.dart';
import '../pub_moment_result_entity.dart';
import '../report_reason_item_entity.dart';
import '../ret_entity.dart';
import '../token_entity.dart';
import '../universal_pop_entity.dart';
import '../user_data_entity.dart';
import '../user_location_entity.dart';
import '../user_options_entity.dart';
import '../user_photo_entity.dart';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    LogUtil.e(message: '$e');
    LogUtil.e(message: '$stack');
  }
}

//Edit by Connor - 基于JsonToDart工具实现的JSON序列化/反序列化
class FFConvert {
  FFConvert._();

  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    String typeStr = T.toString();
    if (value is List) {
      return _generateOBJList<T>(typeStr, value);
    }
    return _generateItemOBJ(typeStr, value) as T;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    LogUtil.e(message: e.toString());
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

M _generateItemOBJ<M>(String typeStr, dynamic jsonObj) {
  late dynamic obj;
  switch (typeStr) {
    case 'TokenEntity':
      obj = TokenEntity.fromJson(jsonObj);
      break;
    case 'AttachmentEntity':
      obj = AttachmentEntity.fromJson(jsonObj);
      break;
    case 'MatchAgeEntity':
      obj = MatchAgeEntity.fromJson(jsonObj);
      break;
    case 'CommentEntity':
      obj = CommentEntity.fromJson(jsonObj);
      break;
    case 'PartnerInfoEntity':
      obj = PartnerInfoEntity.fromJson(jsonObj);
      break;
    case 'ProfileCommentEntity':
      obj = ProfileCommentEntity.fromJson(jsonObj);
      break;
    case 'PromptNoPhotoEntity':
      obj = PromptNoPhotoEntity.fromJson(jsonObj);
      break;
    case 'WfUserDataEntity':
      obj = UserDataEntity.fromJson(jsonObj);
      break;
    case 'UserLocationEntity':
      obj = UserLocationEntity.fromJson(jsonObj);
      break;
    case 'UserOptionsEntity':
      obj = UserOptionsEntity.fromJson(jsonObj);
      break;
    case 'UserPhotoEntity':
      obj = UserPhotoEntity.fromJson(jsonObj);
      break;
    case 'MomentEntity':
      obj = MomentEntity.fromJson(jsonObj);
      break;
    case 'ListUserEntity':
       obj = ListUserEntity.fromJson(jsonObj);
      break;
    case 'CityEntity':
      obj = CityEntity.fromJson(jsonObj);
      break;
    case 'CommentReplyEntity':
      obj = CommentReplyEntity.fromJson(jsonObj);
      break;
    case 'AttachResultEntity':
      obj = AttachResultEntity.fromJson(jsonObj);
      break;
    case 'PubMomentResult':
      obj = PubMomentResult.fromJson(jsonObj);
      break;
    case 'RetEntity':
      obj = RetEntity.fromJson(jsonObj);
      break;
    case 'ChattedUserEntity':
      obj = ChattedUserEntity.fromJson(jsonObj);
      break;
    case 'IMMessageEntity':
      obj = IMMessageEntity.fromJson(jsonObj);
      break;
    case 'IMNewMessageEntity':
      obj = IMNewMessageEntity.fromJson(jsonObj);
      break;
    case 'ChatStatusEntity':
      obj = ChatStatusEntity.fromJson(jsonObj);
      break;
    case 'BadgeEntity':
      obj = BadgeEntity.fromJson(jsonObj);
      break;
    case 'LanguageMatchInfoEntity':
      obj = LanguageMatchInfoEntity.fromJson(jsonObj);
      break;
    case 'ReportReasonEntity':
      obj = ReportReasonEntity.fromJson(jsonObj);
      break;
    case 'ReportReasonEntityItems':
      obj = ReportReasonEntityItems.fromJson(jsonObj);
      break;
    case 'NotificationEntity':
      obj = NotificationEntity.fromJson(jsonObj);
      break;
    case 'UniversalPopEntity':
      obj = UniversalPopEntity.fromJson(jsonObj);
      break;
    case 'Buttons':
      obj = Buttons.fromJson(jsonObj);
      break;
    default:
      LogUtil.logger.e("未解析$typeStr---${jsonObj.toString()}");
      obj = jsonObj;
      break;
  }
  return obj as M;
}

T _generateOBJList<T>(String typeStr, List data) {
  typeStr = typeStr.substring(5, typeStr.length - 1);
  var list;
  switch (typeStr) {
    case 'TokenEntity':
      list = data
          .map<TokenEntity>((e) => _generateItemOBJ<TokenEntity>(typeStr, e))
          .toList();
      break;
    case 'UserDataEntity':
      list = data
          .map<UserDataEntity>(
              (e) => _generateItemOBJ<UserDataEntity>(typeStr, e))
          .toList();
      break;
    case 'AttachmentEntity':
      list = data
          .map<AttachmentEntity>(
              (e) => _generateItemOBJ<AttachmentEntity>(typeStr, e))
          .toList();
      break;
    case 'MatchAgeEntity':
      list = data
          .map<MatchAgeEntity>(
              (e) => _generateItemOBJ<MatchAgeEntity>(typeStr, e))
          .toList();
      break;
    case 'CommentEntity':
      list = data
          .map<CommentEntity>(
              (e) => _generateItemOBJ<CommentEntity>(typeStr, e))
          .toList();
      break;
    case 'PartnerInfoEntity':
      list = data
          .map<PartnerInfoEntity>(
              (e) => _generateItemOBJ<PartnerInfoEntity>(typeStr, e))
          .toList();
      break;
    case 'ProfileCommentEntity':
      list = data
          .map<ProfileCommentEntity>(
              (e) => _generateItemOBJ<ProfileCommentEntity>(typeStr, e))
          .toList();
      break;
    case 'PromptNoPhotoEntity':
      list = data
          .map<PromptNoPhotoEntity>(
              (e) => _generateItemOBJ<PromptNoPhotoEntity>(typeStr, e))
          .toList();
      break;
    case 'UserLocationEntity':
      list = data
          .map<UserLocationEntity>(
              (e) => _generateItemOBJ<UserLocationEntity>(typeStr, e))
          .toList();
      break;
    case 'UserOptionsEntity':
      list = data
          .map<UserOptionsEntity>(
              (e) => _generateItemOBJ<UserOptionsEntity>(typeStr, e))
          .toList();
      break;
    case 'UserPhotoEntity':
      list = data
          .map<UserPhotoEntity>(
              (e) => _generateItemOBJ<UserPhotoEntity>(typeStr, e))
          .toList();
      break;
    case 'ListUserEntity':
      list = data
          .map<ListUserEntity>(
              (e) => _generateItemOBJ<ListUserEntity>(typeStr, e))
          .toList();
      break;
    case 'CityEntity':
      list = data
          .map<CityEntity>((e) => _generateItemOBJ<CityEntity>(typeStr, e))
          .toList();
      break;
    case 'MomentEntity':
      list = data
          .map<MomentEntity>((e) => _generateItemOBJ<MomentEntity>(typeStr, e))
          .toList();
      break;
    case 'CommentReplyEntity':
      list = data
          .map<CommentReplyEntity>(
              (e) => _generateItemOBJ<CommentReplyEntity>(typeStr, e))
          .toList();
      break;
    case 'AttachResultEntity':
      list = data
          .map<AttachResultEntity>(
              (e) => _generateItemOBJ<AttachResultEntity>(typeStr, e))
          .toList();
      break;
    case 'PubMomentResult':
      list = data
          .map<PubMomentResult>(
              (e) => _generateItemOBJ<PubMomentResult>(typeStr, e))
          .toList();
      break;
    case 'ChattedUserEntity':
      list = data
          .map<ChattedUserEntity>(
              (e) => _generateItemOBJ<ChattedUserEntity>(typeStr, e))
          .toList();
      break;
    case 'IMMessageEntity':
      list = data
          .map<IMMessageEntity>(
              (e) => _generateItemOBJ<IMMessageEntity>(typeStr, e))
          .toList();
      break;
    case 'IMNewMessageEntity':
      list = data
          .map<IMNewMessageEntity>(
              (e) => _generateItemOBJ<IMNewMessageEntity>(typeStr, e))
          .toList();
      break;
    case 'ChatStatusEntity':
      list = data
          .map<ChatStatusEntity>(
              (e) => _generateItemOBJ<ChatStatusEntity>(typeStr, e))
          .toList();
      break;
    case 'LanguageMatchInfoEntity':
      list = data
          .map<LanguageMatchInfoEntity>(
              (e) => _generateItemOBJ<LanguageMatchInfoEntity>(typeStr, e))
          .toList();
      break;
    case 'ReportReasonEntity':
      list = data
          .map<ReportReasonEntity>(
              (e) => _generateItemOBJ<ReportReasonEntity>(typeStr, e))
          .toList();
      break;
    case 'ReportReasonEntityItems':
      list = data
          .map<ReportReasonEntityItems>(
              (e) => _generateItemOBJ<ReportReasonEntityItems>(typeStr, e))
          .toList();
      break;
    case 'NotificationEntity':
      list = data
          .map<NotificationEntity>(
              (e) => _generateItemOBJ<NotificationEntity>(typeStr, e))
          .toList();
    case 'UniversalPopEntity':
      list = data
          .map<UniversalPopEntity>(
              (e) => _generateItemOBJ<UniversalPopEntity>(typeStr, e))
          .toList();
      break;
    case 'Buttons':
      list = data
          .map<Buttons>((e) => _generateItemOBJ<Buttons>(typeStr, e))
          .toList();
      break;

    default:
      LogUtil.logger.e("未解析$typeStr-----${typeStr.toString()}");
      if (data.isNotEmpty && data.first is List) {
        list = data.map((e) => _generateOBJList<List>(typeStr, e)).toList();
      } else {
        list = data.map((e) => _generateItemOBJ(typeStr, e)).toList();
      }
      break;
  }
  return list as T;
}
