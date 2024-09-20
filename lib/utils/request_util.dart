import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:voices_dating/utils/string_extension.dart';
import 'package:voices_dating/utils/list_extension.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import '../entity/user_data_entity.dart';


class RequestUtil{

  static getSignInMap({required String email,required String password}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("email", () => email);
    requestMap.putIfAbsent("password", () => password);
    return requestMap;
  }

  static getAppleSignInMap({required String identityToken,required String appleUid}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("identityToken", () => identityToken);
    requestMap.putIfAbsent("appleUid", () => appleUid);
    return requestMap;
  }

  static getUserProfileMap(
      {required String userId}) {
    Map<String, dynamic> requestMap = {};
    if (userId.hasData) {
      requestMap.putIfAbsent("profId", () => userId);
    }

    return requestMap;
  }

  static getContactsMap({int pageNum = 1, int offset = 10,int? languageStatus}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    if(languageStatus!=null){
      requestMap.putIfAbsent("languageStatus", () => languageStatus);
    }
    return requestMap;
  }


  static getDeleteAttachMap({required attachId,int? isPrivate}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("attachId", () => attachId);
    if (isPrivate != null) {
      requestMap.putIfAbsent("private", () => isPrivate);
    }

    return requestMap;
  }

  static getSetAvatarMap({required String attachId}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("attachId", () => attachId);
    return requestMap;
  }

  static getChangePhotoTypeMap({required int attachId, required int photoType}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("attachId", () => attachId);
    requestMap.putIfAbsent("photoType", () => photoType);

    return requestMap;
  }

  static getTimeLineMap({required int pageNum, required int offset,  String? userId}) {
    Map<String, dynamic> requestMap = {};
    List<String> type = ["2","3","4","5","6","7","8","9","10","11","12","13","15","16","17","19"];

    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    requestMap.putIfAbsent("profId", () => userId);
    requestMap.putIfAbsent("type", () => type);

    return requestMap;
  }

  static getActivityCommentListMap({required String activityId,required int page,int offset = 20, bool returnReply = false}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("timelineId", () => activityId);
    requestMap.putIfAbsent("page", () => page);
    requestMap.putIfAbsent("offset", () => offset);
    requestMap.putIfAbsent("returnReply", () => returnReply);
    return requestMap;
  }

  static getBlockUserMap({required userId}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => userId);
    return requestMap;
  }

  static getBlockListMap(int pageNum, int offset) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    return requestMap;
  }

  static getReportMap({required String commentId, required String reportedUserId, String? content, String? attachIds}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => reportedUserId);
    requestMap.putIfAbsent("commentId", () => commentId);
    if(!content.isNullOrEmpty) {
      requestMap.putIfAbsent("content", () => content);
    }
    if(!attachIds.isNullOrEmpty){
      requestMap.putIfAbsent("attach_ids", () => attachIds);
    }
    return requestMap;
  }

  static getFeedbackMap({required String text, required String subject,String? attachId,String? email}){
    Map<String, dynamic> requestMap = {};

    requestMap.putIfAbsent("content", () => text);
    requestMap.putIfAbsent("subject", () => subject);
    if(email.hasData){
      requestMap.putIfAbsent("email", () => email);

    }
    if(attachId.hasData){
      requestMap.putIfAbsent("attachId", () => attachId);
    }
    return requestMap;
  }

  static getRequestPrivateMap({required String userId}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => userId);
    return requestMap;
  }

  static getLikeUserMap({required userId,String? from}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => userId);
    if (from.hasData) requestMap.putIfAbsent("from", () => from);
    return requestMap;
  }

  static getUnlikeUserMap({required userId}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => userId);
    return requestMap;
  }

  static getLogoutMap({required String userId,String? deviceId}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("usr_id", () => userId);
    if (deviceId.hasData) {
      requestMap.putIfAbsent("device_id", () => deviceId);
    }
    return requestMap;
  }

  static getDeleteMomentMap({required String activityId}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("timelineId", () => activityId);
    return requestMap;
  }

  static getCommentMomentData({required String activityId,required content,String? atCommentId}){
    Map<String, dynamic> requestMap =  {};
    requestMap.putIfAbsent("timelineId", () => activityId);
    requestMap.putIfAbsent("content", () => content);
    if(atCommentId.hasData) {
      requestMap.putIfAbsent("atCommentId", () => atCommentId);
    }

    return requestMap;
  }


  static getMatchFilterMap( {int pageNum = 1, int offset = 0,
    required UserDataEntity userEntity,int refresh = 0,String type = "",bool isSpark = false,bool isProvider = false,required String myLanguage,required String seekingLanguage}) async {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    requestMap.putIfAbsent("refresh", () => refresh);
    // if(type.hasData){
    //   requestMap.putIfAbsent("type", () => type);
    // }

    Map<String,dynamic>findDataMap = {};

    // findDataMap.putIfAbsent(
    //     "gender", () {
    //   return userEntity.gender!.isEmpty?1:userEntity.gender;
    // });

    int memberStatus = int.tryParse(userEntity.member??"")??0;


    // findDataMap.putIfAbsent("photo", () => 1);
    if(isProvider) {
      findDataMap.putIfAbsent("seekingLanguage", () => seekingLanguage);
    }else{
      findDataMap.putIfAbsent("seekingLanguage", () => myLanguage);
    }

    requestMap.putIfAbsent("find", () => findDataMap);

    return requestMap;
  }

  static getPublishMomentMap({required String content,List<String>? attachList}){
    Map<String, dynamic> requestMap = {};
    if(!attachList.isNullOrEmpty) {
      requestMap["attachIds"] = attachList!.map((item) => item).join(",");
    }
    requestMap["content"] = content;
    return requestMap;
  }

  static  getUploadPhotoMap(
      {required List<File> fileList, bool needCompress = true,
        int photoType = -1,}) async {

    var formData = FormData();
    for (var i = 0; i < fileList.length; i++) {
      File file = fileList[i];
      if (needCompress) {
        Uint8List? compressed = await compressPhoto(file);
        if (compressed?.isNotEmpty ?? false) {
          formData.files.add(MapEntry(
              'file',
              MultipartFile.fromBytes(compressed!,
                  filename: DateTime.now().microsecondsSinceEpoch.toString())));
        }
      } else {
        formData.files.add(MapEntry(
            'file',
            await MultipartFile.fromFile(file.path,
                filename: DateTime.now().microsecondsSinceEpoch.toString())));
      }
    }

    if (photoType != -1) {
      formData.fields.add(MapEntry("photoType", photoType.toString()));
    }

    return formData;
  }


  static getRecentContactsMap({int pageNum = 1, int offset = 10,int newStatus = 1}) {
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    requestMap.putIfAbsent("new", () => newStatus);

    return requestMap;
  }

  static getDeleteContactMap({required String userId}){
    Map<String,dynamic> requestMap = {};
    requestMap.putIfAbsent("profId", () => userId);
    return requestMap;
  }

  static getPinTopMap({required String userId}){
    Map<String,dynamic> requestMap = {};
    requestMap.putIfAbsent("profId", () => userId);
    return requestMap;
  }

  static getCheckChatMap({required String senderId,required String receiverId}){
    Map<String,dynamic> requestMap = {};
    requestMap.putIfAbsent("sender", () => senderId);
    requestMap.putIfAbsent("receiver", () => receiverId);
    return requestMap;
  }

  static getChatHistoryMap({required String contactId,required pageNum,int offset = 20}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("profId", () => contactId);
    requestMap.putIfAbsent("offset", () => offset);
    return requestMap;
  }

  static getChangeUserNameMap({required String userName}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("username", () => userName);
    return requestMap;

  }

  static getUploadVideoMap({required Uint8List fileBytes, required int duration, bool protect = true, required String fileName}){
    Map<String, dynamic> requestMap = {};

    MultipartFile fileMap = MultipartFile.fromBytes(fileBytes,contentType: MediaType('multipart', 'form-data'),
        filename: "$fileName.mp4"
    );
    requestMap.putIfAbsent("file", () => fileMap);
    requestMap.putIfAbsent("duration", () => duration);
    requestMap.putIfAbsent("protect", () => protect?"1":"0");
    return requestMap;

  }

  static getVerifyVideoMap({required String videoId}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("videoId", () => videoId);
    return requestMap;

  }

  static getDisableAccountMap({required String userId,required String pwd}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("userId", () => userId);
    requestMap.putIfAbsent("password", () => pwd);
    return requestMap;
  }

  static getDeleteAccountMap({required String pwd,String? reason}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("password", () => pwd);
    if(!reason.isNullOrEmpty){
      requestMap.putIfAbsent("reason", () => reason);
    }
    return requestMap;
  }

  static getUserNotificationMap({required pageNum,int offset = 20,String? typeData}){
    Map<String, dynamic> requestMap = {};
    requestMap.putIfAbsent("page", () => pageNum);
    requestMap.putIfAbsent("offset", () => offset);
    if(!typeData.isNullOrEmpty) {
      requestMap.putIfAbsent("type", () => typeData);
    }
    return requestMap;
  }

  static Future<Uint8List?> compressPhoto(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1080,
      minHeight: 1920,
    );
    return result;
  }

}