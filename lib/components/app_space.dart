import 'package:flutter/material.dart';

class RowSpace extends StatelessWidget{
  final double width;

  const RowSpace({Key? key,required this.width}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(color:Colors.transparent,
        width: width);
  }
}

class ColumnSpace extends StatelessWidget{
  final double height;

  const ColumnSpace({Key? key,required this.height}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(color:Colors.transparent,
        height: height);
  }
}