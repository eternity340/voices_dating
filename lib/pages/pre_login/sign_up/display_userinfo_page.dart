import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../entity/User.dart';

class DisplayUserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text("User Information"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email: ${user.email}"),
              Text("Gender: ${user.gender}"),
              Text("Country: ${user.country}"),
              Text("State: ${user.state}"),
              Text("City: ${user.city}"),
              //Text("Birthday: ${user.birthday?.toLocal()}".split(' ')[0]),
              Text("Age: ${user.age}"),
              Text("Username: ${user.username}"),
              Text("Password: ${user.password}"), // Note: In a real application, you should not display the password
            ],
          ),
        ),
      ),
    );
  }
}
