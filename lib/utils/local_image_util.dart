import 'package:flutter/widgets.dart';

class LocalImageUtil {
  static Image getAssetImage({
    required String imageName,
    String? package,
    BoxFit? boxFit,
    double? width,
    double? height,
    Color? color,
  }) {
    return Image.asset(
      imageName,
      package: package,
      fit: boxFit,
      width: width,
      height: height,
      color: color,
    );
  }

  static ImageProvider getAssetImageProvider(
      {required String imageName,
        String? package,
        BoxFit? boxFit,
        double? width,
        double? height,
        Color? color}) {
    return Image.asset(
      imageName,
      package: package,
      fit: boxFit,
      width: width,
      height: height,
      color: color,
    ).image;
  }
}
