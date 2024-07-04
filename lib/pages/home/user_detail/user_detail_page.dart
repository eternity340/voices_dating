import 'package:flutter/material.dart';
import '../../../entity/list_user_entity.dart';

class UserDetailPage extends StatelessWidget {
  final ListUserEntity userEntity;

  UserDetailPage({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userEntity.username ?? 'User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${userEntity.username ?? ""}'),
              Text('Age: ${userEntity.age ?? ""}'),
              Text('Avatar: ${userEntity.avatar ?? ""}'),
              Text('Blocked Me: ${userEntity.blockedMe ?? ""}'),
              Text('Body: ${userEntity.body ?? ""}'),
              Text('Can Unlock Liked Me: ${userEntity.canUnlockLikedMe ?? ""}'),
              Text('Can Wink: ${userEntity.canWink ?? ""}'),
              Text('Created: ${userEntity.created ?? ""}'),
              Text('Current Location: ${userEntity.curLocation?.curAddress ?? ""}'),
              Text('Disability: ${userEntity.disability ?? ""}'),
              Text('Distance: ${userEntity.distance ?? ""}'),
              Text('Ethnicity: ${userEntity.ethnicity ?? ""}'),
              Text('Gender: ${userEntity.gender ?? ""}'),
              Text('Have Kids: ${userEntity.haveKids ?? ""}'),
              Text('Headline: ${userEntity.headline ?? ""}'),
              Text('Height: ${userEntity.height ?? ""}'),
              Text('Hidden: ${userEntity.hidden ?? ""}'),
              Text('Hidden Current Location: ${userEntity.hiddenCurrentLocation ?? ""}'),
              Text('Hidden Disability: ${userEntity.hiddenDisability ?? ""}'),
              Text('Hidden Gender: ${userEntity.hiddenGender ?? ""}'),
              Text('Hidden Online: ${userEntity.hiddenOnline ?? ""}'),
              Text('Income: ${userEntity.income ?? ""}'),
              Text('Is New: ${userEntity.isNew ?? ""}'),
              Text('Last Active Time: ${userEntity.lastActiveTime ?? ""}'),
              Text('Last Timeline: ${userEntity.lastTimeline?.join(", ") ?? ""}'),
              Text('Like Me Type: ${userEntity.likeMeType ?? ""}'),
              Text('Like Type: ${userEntity.likeType ?? ""}'),
              Text('Liked: ${userEntity.liked ?? ""}'),
              Text('Liked Me: ${userEntity.likedMe ?? ""}'),
              Text('Location: ${userEntity.location?.city ?? ""}'),
              Text('Marital Status: ${userEntity.marital ?? ""}'),
              Text('Member: ${userEntity.member ?? ""}'),
              Text('Online: ${userEntity.online ?? ""}'),
              Text('Photo Count: ${userEntity.photoCnt ?? ""}'),
              Text('Registration Days: ${userEntity.regDays ?? ""}'),
              Text('Room ID: ${userEntity.roomId ?? ""}'),
              Text('Super Like Me Count: ${userEntity.superLikeMeCnt ?? ""}'),
              Text('Timeline Status: ${userEntity.timeLineStatus ?? ""}'),
              Text('Unlocked: ${userEntity.unlocked ?? ""}'),
              Text('Unlocked Liked Me: ${userEntity.unlockedLikedMe ?? ""}'),
              Text('User ID: ${userEntity.userId ?? ""}'),
              Text('Verified: ${userEntity.verified ?? ""}'),
              Text('Verified Income: ${userEntity.verifiedIncome ?? ""}'),
              Text('Video Count: ${userEntity.videoCnt ?? ""}'),
              Text('Video List: ${userEntity.videoList?.join(", ") ?? ""}'),
              Text('Winked: ${userEntity.winked ?? ""}'),
              Text('Winked Me: ${userEntity.winkedMe ?? ""}'),
              Text('Visited Me Count: ${userEntity.visitedMeCnt ?? ""}'),
              Text('Language: ${userEntity.language ?? ""}'),
              Text('Match Language: ${userEntity.matchLanguage ?? ""}'),
              // Add more fields if necessary
            ],
          ),
        ),
      ),
    );
  }
}
