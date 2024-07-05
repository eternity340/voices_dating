import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../entity/list_user_entity.dart';

class ProfileCard extends StatelessWidget {
  final ListUserEntity userEntity;

  const ProfileCard({Key? key, required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.0642),
            offset: Offset(0, 7),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 27.2, sigmaY: 27.2),
          child: Container(
            width: 283,
            height: 166,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userEntity.username ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Open Sans',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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
                        '${userEntity.age ?? 0} years old',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
