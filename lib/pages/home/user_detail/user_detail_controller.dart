import '../../../entity/list_user_entity.dart';

class UserDetailController {
  final ListUserEntity userEntity;

  UserDetailController({required this.userEntity});

  String get username => userEntity.username ?? 'User Details';
  String get age => userEntity.age ?? "";
  String get avatar => userEntity.avatar ?? "";
  String get blockedMe => userEntity.blockedMe?.toString() ?? "";
  String get body => userEntity.body?.toString() ?? "";
  String get canUnlockLikedMe => userEntity.canUnlockLikedMe?.toString() ?? "";
  String get canWink => userEntity.canWink?.toString() ?? "";
  String get created => userEntity.created?.toString() ?? "";
  String get curLocation => userEntity.curLocation?.curAddress ?? "";
  String get disability => userEntity.disability ?? "";
  String get distance => userEntity.distance ?? "";
  String get ethnicity => userEntity.ethnicity?.toString() ?? "";
  String get gender => userEntity.gender ?? "";
  String get haveKids => userEntity.haveKids?.toString() ?? "";
  String get headline => userEntity.headline ?? "";
  String get height => userEntity.height?.toString() ?? "";
  String get hidden => userEntity.hidden ?? "";
  String get hiddenCurrentLocation => userEntity.hiddenCurrentLocation ?? "";
  String get hiddenDisability => userEntity.hiddenDisability ?? "";
  String get hiddenGender => userEntity.hiddenGender ?? "";
  String get hiddenOnline => userEntity.hiddenOnline ?? "";
  String get income => userEntity.income ?? "";
  String get isNew => userEntity.isNew ?? "";
  String get lastActiveTime => userEntity.lastActiveTime?.toString() ?? "";
  String get lastTimeline => userEntity.lastTimeline?.join(", ") ?? "";
  String get likeMeType => userEntity.likeMeType?.toString() ?? "";
  String get likeType => userEntity.likeType?.toString() ?? "";
  String get liked => userEntity.liked?.toString() ?? "";
  String get likedMe => userEntity.likedMe?.toString() ?? "";
  String get location => userEntity.location?.city ?? "";
  String get marital => userEntity.marital?.toString() ?? "";
  String get member => userEntity.member ?? "";
  String get online => userEntity.online ?? "";
  String get photoCnt => userEntity.photoCnt ?? "";
  String get regDays => userEntity.regDays?.toString() ?? "";
  String get roomId => userEntity.roomId ?? "";
  String get superLikeMeCnt => userEntity.superLikeMeCnt?.toString() ?? "";
  String get timeLineStatus => userEntity.timeLineStatus ?? "";
  String get unlocked => userEntity.unlocked?.toString() ?? "";
  String get unlockedLikedMe => userEntity.unlockedLikedMe?.toString() ?? "";
  String get userId => userEntity.userId ?? "";
  String get verified => userEntity.verified ?? "";
  String get verifiedIncome => userEntity.verifiedIncome ?? "";
  String get videoCnt => userEntity.videoCnt?.toString() ?? "";
  String get videoList => userEntity.videoList?.join(", ") ?? "";
  String get winked => userEntity.winked?.toString() ?? "";
  String get winkedMe => userEntity.winkedMe?.toString() ?? "";
  String get visitedMeCnt => userEntity.visitedMeCnt ?? "";
  String get language => userEntity.language ?? "";
  String get matchLanguage => userEntity.matchLanguage ?? "";
// Add more fields if necessary
}
