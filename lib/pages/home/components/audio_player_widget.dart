import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import '../../../components/bar/bar_scale_pulse_out_loading.dart';
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
  late List<double> _barHeights;
  final int _barCount = 20;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateRandomBarHeights();

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

  void _generateRandomBarHeights() {
    _barHeights = List.generate(_barCount, (_) => 10.h + _random.nextDouble() * 20.h);
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

  Widget _buildBars() {
    return SizedBox(
      width: 130.w,
      height: 30.h,
      child: _isPlaying
          ? BarScalePulseOutLoading(
        width: 2.w,
        height: 15.h,
        barCount: _barCount,
        color: Color(0xFF2FE4D4),
        duration: Duration(milliseconds: 600),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _barCount,
              (index) => Container(
            width: 2.w,
            height: _barHeights[index],
            decoration: BoxDecoration(
              color: Color(0xFF2FE4D4),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
        ),
      ),
    );
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
        _buildBars(),
      ],
    );
  }
}