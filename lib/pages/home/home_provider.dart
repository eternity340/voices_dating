import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart'; // 导入 UserDataEntity

class HomePageProvider extends StatelessWidget {
  final Widget child;
  final TokenEntity tokenEntity;
  final UserDataEntity userData; // 添加 userData 字段

  HomePageProvider({required this.child, required this.tokenEntity, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(tokenEntity, userData), // 传递 userData
      child: child,
    );
  }
}
