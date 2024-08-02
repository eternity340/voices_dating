import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/Constant_styles.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioPlayerWidget({Key? key, required this.audioPath}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });
  }

  Future<void> _initializeTotalDuration() async {
    final duration = await _audioPlayer.getDuration();
    if (duration != null) {
      setState(() {
        _totalDuration = duration;
      });
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioPath));
      _initializeTotalDuration();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 34.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: Color(0xFF2FE4D4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        if (_isPlaying)
          StreamBuilder<Duration>(
            stream: _audioPlayer.onPositionChanged,
            builder: (context, snapshot) {
              final currentPosition = snapshot.data ?? Duration.zero;
              return Text(
                '${_formatDuration(currentPosition)} / ${_formatDuration(_totalDuration)}',
                style: ConstantStyles.audioTextStyle,
              );
            },
          ),
      ],
    );
  }
}
