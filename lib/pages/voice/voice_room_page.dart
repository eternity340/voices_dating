import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/background.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';

class VoiceRoomPage extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity? userData = Get.arguments['userData'] as UserDataEntity?;

   VoiceRoomPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Background(
        showBackButton: false,
        child: Stack(
          children: [

          ],
        ),
      ),
    );
  }
}
