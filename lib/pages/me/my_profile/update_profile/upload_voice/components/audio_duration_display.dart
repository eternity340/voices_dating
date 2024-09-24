import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../service/audio_service.dart';

class AudioDurationDisplay extends StatefulWidget {
  final String audioPath;

  const AudioDurationDisplay({Key? key, required this.audioPath}) : super(key: key);

  @override
  _AudioDurationDisplayState createState() => _AudioDurationDisplayState();
}

class _AudioDurationDisplayState extends State<AudioDurationDisplay> {
  late Future<int> _durationFuture;

  @override
  void initState() {
    super.initState();
    _durationFuture = AudioService.instance.getAudioDuration(widget.audioPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _durationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Text(
            '${snapshot.data}s',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
