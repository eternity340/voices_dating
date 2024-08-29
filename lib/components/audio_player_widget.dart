import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'dart:async';
import 'bar/bar_scale_pulse_out_loading.dart';
import '../service/audio_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioPlayerWidget({Key? key, required this.audioPath}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioService audioService = AudioService.instance;
  bool _isPlaying = false;
  late List<double> _barHeights;
  final int _barCount = 20;
  final Random _random = Random();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _completionSubscription;

  @override
  void initState() {
    super.initState();
    _generateRandomBarHeights();
    _initAudioService();
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

  Future<void> _initAudioService() async {
    await audioService.initialize();
    _positionSubscription = audioService.onPositionChanged?.listen((Duration position) {
    });
    _completionSubscription = audioService.onPlayerCompletion.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _generateRandomBarHeights() {
    _barHeights = List.generate(_barCount, (_) => 10.h + _random.nextDouble() * 20.h);
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await audioService.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      try {
        await audioService.play(widget.audioPath);
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error playing audio: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _completionSubscription?.cancel();
    //audioService.dispose();
    super.dispose();
  }
}
