import 'package:first_app/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';

class ChangeLocation extends StatefulWidget{
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: '   Location',
        showActionButton: true,
        showBackgroundImage: false,
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 167.5, // 居中水平放置，减去一半的输入框宽度
              child: Container(
                width: 335.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '${widget.userData.location?.city}, ${widget.userData.location?.state}, ${widget.userData.location?.country}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Image.asset(
                          'assets/images/icon_location.png',
                          width: 24.0,
                          height: 24.0,
                        ),
                        onPressed: () {
                          // Your location button logic
                        }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
