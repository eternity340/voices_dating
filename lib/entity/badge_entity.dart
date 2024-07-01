import 'dart:convert';

import 'json_format/json_format.dart';


class BadgeEntity {
  BadgeEntity({
    this.matchedWithoutChattedTotal = 0,
    this.accessedMyPriAlbum = 0,
    this.accessedPriAlbum = 0,
    this.connectionCount = 0,
    this.iLikedCnt = 0,
    this.iLikedCntWithoutMatched = 0,
    this.invitationNumber = 0,
    this.likedMe = 0,
    this.matched = 0,
    this.newAccessedPriAlbum = 0,
    this.newBlogCount = 0,
    this.newDriftCount = 0,
    this.newLikedMe = 0,
    this.newLikedMeWithoutMatched = 0,
    this.newMatched = 0,
    this.newMatchedWithoutChatted = 0,
    this.newMessage = 0,
    this.newNotification = 0,
    this.newRequestedPhoto = 0,
    this.newRequestedPriAlbum = 0,
    this.newSiteNotificationCount = 0,
    this.newVisitedMe = 0,
    this.newVisitedMeTimes = 0,
    this.newVisitedMeUsers = 0,
    this.newWinkedMe = 0,
    this.requestedPhoto = 0,
    this.requestedPriAlbum = 0,
    this.visitedMe = 0,
    this.winkedMe = 0,
  });

  factory BadgeEntity.fromJson(Map<String, dynamic> json) => BadgeEntity(
        matchedWithoutChattedTotal:
            asT<int>(json['MatchedWithoutChattedTotal']) ?? 0,
        accessedMyPriAlbum: asT<int>(json['accessedMyPriAlbum']) ?? 0,
        accessedPriAlbum: asT<int>(json['accessedPriAlbum']) ?? 0,
        connectionCount: asT<int>(json['connectionCount']) ?? 0,
        iLikedCnt: asT<int>(json['iLikedCnt']) ?? 0,
        iLikedCntWithoutMatched: asT<int>(json['iLikedCntWithoutMatched']) ?? 0,
        invitationNumber: asT<int>(json['invitationNumber']) ?? 0,
        likedMe: asT<int>(json['likedMe']) ?? 0,
        matched: asT<int>(json['matched']) ?? 0,
        newAccessedPriAlbum: asT<int>(json['newAccessedPriAlbum']) ?? 0,
        newBlogCount: asT<int>(json['newBlogCount']) ?? 0,
        newDriftCount: asT<int>(json['newDriftCount']) ?? 0,
        newLikedMe: asT<int>(json['newLikedMe']) ?? 0,
        newLikedMeWithoutMatched:
            asT<int>(json['newLikedMeWithoutMatched']) ?? 0,
        newMatched: asT<int>(json['newMatched']) ?? 0,
        newMatchedWithoutChatted:
            asT<int>(json['newMatchedWithoutChatted']) ?? 0,
        newMessage: asT<int>(json['newMessage']) ?? 0,
        newNotification: asT<int>(json['newNotification']) ?? 0,
        newRequestedPhoto: asT<int>(json['newRequestedPhoto']) ?? 0,
        newRequestedPriAlbum: asT<int>(json['newRequestedPriAlbum']) ?? 0,
        newSiteNotificationCount:
            asT<int>(json['newSiteNotificationCount']) ?? 0,
        newVisitedMe: asT<int>(json['newVisitedMe']) ?? 0,
        newVisitedMeTimes: asT<int>(json['newVisitedMeTimes']) ?? 0,
        newVisitedMeUsers: asT<int>(json['newVisitedMeUsers']) ?? 0,
        newWinkedMe: asT<int>(json['newWinkedMe']) ?? 0,
        requestedPhoto: asT<int>(json['requestedPhoto']) ?? 0,
        requestedPriAlbum: asT<int>(json['requestedPriAlbum']) ?? 0,
        visitedMe: asT<int>(json['visitedMe']) ?? 0,
        winkedMe: asT<int>(json['winkedMe']) ?? 0,
      );

  int matchedWithoutChattedTotal;
  int accessedMyPriAlbum;
  int accessedPriAlbum;
  int connectionCount;
  int iLikedCnt;
  int iLikedCntWithoutMatched;
  int invitationNumber;
  int likedMe;
  int matched;
  int newAccessedPriAlbum;
  int newBlogCount;
  int newDriftCount;
  int newLikedMe;
  int newLikedMeWithoutMatched;
  int newMatched;
  int newMatchedWithoutChatted;
  int newMessage;
  int newNotification;
  int newRequestedPhoto;
  int newRequestedPriAlbum;
  int newSiteNotificationCount;
  int newVisitedMe;
  int newVisitedMeTimes;
  int newVisitedMeUsers;
  int newWinkedMe;
  int requestedPhoto;
  int requestedPriAlbum;
  int visitedMe;
  int winkedMe;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'MatchedWithoutChattedTotal': matchedWithoutChattedTotal,
        'accessedMyPriAlbum': accessedMyPriAlbum,
        'accessedPriAlbum': accessedPriAlbum,
        'connectionCount': connectionCount,
        'iLikedCnt': iLikedCnt,
        'iLikedCntWithoutMatched': iLikedCntWithoutMatched,
        'invitationNumber': invitationNumber,
        'likedMe': likedMe,
        'matched': matched,
        'newAccessedPriAlbum': newAccessedPriAlbum,
        'newBlogCount': newBlogCount,
        'newDriftCount': newDriftCount,
        'newLikedMe': newLikedMe,
        'newLikedMeWithoutMatched': newLikedMeWithoutMatched,
        'newMatched': newMatched,
        'newMatchedWithoutChatted': newMatchedWithoutChatted,
        'newMessage': newMessage,
        'newNotification': newNotification,
        'newRequestedPhoto': newRequestedPhoto,
        'newRequestedPriAlbum': newRequestedPriAlbum,
        'newSiteNotificationCount': newSiteNotificationCount,
        'newVisitedMe': newVisitedMe,
        'newVisitedMeTimes': newVisitedMeTimes,
        'newVisitedMeUsers': newVisitedMeUsers,
        'newWinkedMe': newWinkedMe,
        'requestedPhoto': requestedPhoto,
        'requestedPriAlbum': requestedPriAlbum,
        'visitedMe': visitedMe,
        'winkedMe': winkedMe,
      };
}
