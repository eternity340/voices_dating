import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/Constant_styles.dart';
import '../image_res/image_res.dart';

class CoinInfoWidget extends StatelessWidget {
  final int coinAmount;
  final String timeText;

  const CoinInfoWidget({
    Key? key,
    required this.coinAmount,
    required this.timeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          coinAmount.toString(),
          style: ConstantStyles.iconCoinTextStyle,
        ),
        SizedBox(width: 2.w),
        Image.asset(
          ImageRes.iconCoinImagePath,
          width: 13.32.w,
          height: 13.32.h,
        ),
        SizedBox(width: 2.w),
        Text(
          timeText,
          style: ConstantStyles.coinTimeTextStyle,
        ),
      ],
    );
  }
}