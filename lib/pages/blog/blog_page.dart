import 'package:flutter/material.dart';
import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';

class BlogPage extends StatelessWidget {
  // final TokenEntity tokenEntity;
  //
  // BlogPage({required this.tokenEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Welcome to the Blog Page!'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AllNavigationBar(), // Pass tokenEntity to AllNavigationBar
          ),
        ],
      ),
    );
  }
}
