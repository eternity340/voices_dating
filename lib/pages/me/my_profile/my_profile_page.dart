import 'package:first_app/entity/user_data_entity.dart';
import 'package:flutter/material.dart';
import '../../../entity/token_entity.dart';


class MyProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Positioned(
        top: 500, // Adjust as needed
        left: MediaQuery.of(context).size.width / 2 - 167.5, // Center horizontally
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }
}
