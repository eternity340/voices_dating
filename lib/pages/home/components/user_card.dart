import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../entity/list_user_entity.dart';
import '../profile_detail/profile_detail_page.dart';

class UserCard extends StatelessWidget {
  final ListUserEntity userEntity;

  UserCard({required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProfileDetailPage(userEntity: userEntity));
      },
      child: Container(
        width: 335,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 14,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              width: 88,
              height: 19,
              decoration: BoxDecoration(
                color: Color(0xFFABFFCF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Photos verified',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Open Sans',
                    letterSpacing: 0.02,
                    color: Color(0xFF262626),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: userEntity.avatar != null && userEntity.avatar!.isNotEmpty
                      ? Image.network(
                    userEntity.avatar!,
                    width: 100,
                    height: 129,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/placeholder1.png', // 替换为你的占位符图片路径
                    width: 100,
                    height: 129,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              userEntity.username ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Open Sans',
                                height: 22 / 18, // 行高
                                letterSpacing: -0.011249999515712261,
                                color: Color(0xFF000000),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 0, width: 6),
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Color(0xFFABFFCF),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              userEntity.location?.country ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '|',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${userEntity.age ?? 0} ',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          userEntity.headline ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            for (var i = 1; i < (userEntity.photos?.length ?? 0) && i < 4; i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: userEntity.photos![i].url != null && userEntity.photos![i].url!.isNotEmpty
                                      ? Image.network(
                                    userEntity.photos![i].url!,
                                    width: 37.98,
                                    height: 49,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    'assets/images/placeholder1.png', // 替换为你的占位符图片路径
                                    width: 37.98,
                                    height: 49,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
