import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';


class PurchaseRecordPage extends StatelessWidget{
  final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final userData = Get.arguments['userDataEntity'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
              showMiddleText:true ,
              middleText: '',
              showBackgroundImage: false,
              showBackButton: true,
              child: Container()),
        ],
      ),
    );
  }

}