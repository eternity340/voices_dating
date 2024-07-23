import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';

class ProfileContent extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity userData;

  ProfileContent({required this.tokenEntity, required this.userData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              context,
              title: 'Username',
              value: userData.username,
              onTap: () {
                Get.toNamed('/me/my_profile/change_username', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Age',
              value: userData.age.toString(),
              onTap: () {
                Get.toNamed('/me/my_profile/change_age', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Height',
              value: userData.height != null ? '${userData.height} cm' : '',
              onTap: () {
                Get.toNamed('/me/my_profile/change_height', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Headline',
              value: userData.headline.toString(),
              onTap: () {
                Get.toNamed('/me/my_profile/change_headline', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
            _buildInfoSection(
              context,
              title: 'Location',
              value: userData.location != null &&
                  userData.location!.city != null &&
                  userData.location!.country != null
                  ? '${userData.location!.city}, ${userData.location!.country}'
                  : '',
              onTap: () {
                Get.toNamed('/me/my_profile/change_location', arguments: {'token': tokenEntity, 'userData': userData});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Color(0xFF8E8E93),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 270.0),
            child: Image.asset(
              'assets/images/Path.png',
              width: 18,
              height: 18,
            ),
          ),
        ),
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: 330,
          height: 1,
          color: Color(0xFFEBEBEB),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
