import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voices_dating/components/background.dart';

import '../../../../../constants/constant_data.dart';

class AddTagsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        showBackgroundImage: false,
        showMiddleText: false,
        middleText: ConstantData.tagsTitle,
        child: Stack(
          children: [

          ],
        ),
      ),
    );
  }

}