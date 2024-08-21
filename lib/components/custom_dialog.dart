import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/string_res.dart';
import '../utils/app_style_utils.dart';

class CustomDialog extends StatelessWidget {
  final String noticeContent;
  final String? cancelLabel;
  final String? confirmLabel;
  final Color? cancelTextColor;
  final Color? confirmTextColor;
  final bool singleBtn;
  final VoidCallback? confirmTap;

  const CustomDialog(
      {Key? key,
        required this.noticeContent,
        this.cancelLabel,
        this.confirmLabel,
        this.cancelTextColor,
        this.confirmTextColor,
        this.singleBtn = false,
        this.confirmTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Text(
          noticeContent,
          style: AppStyleUtils.titleStyles,
        ),
      ),
      actions: <Widget>[
        if(!singleBtn)
          CupertinoDialogAction(
            child: Text(
              cancelLabel ?? StringRes.getString(StringRes.cancel),
              style: AppStyleUtils.labelStyles.copyWith(color: cancelTextColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        CupertinoDialogAction(
          child: Text(confirmLabel ?? StringRes.getString(StringRes.confirm),
              style: AppStyleUtils.labelStyles.copyWith(color: confirmTextColor)),
          onPressed: () async {
            Navigator.of(context).pop();
            if(confirmTap!=null){
              confirmTap!();
            }
          },
        ),
      ],
    );
  }
}
