import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vibration/vibration.dart';
import '../providers/visit_provider.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  late VideoPlayerController _controller;
  bool _isButtonLongPressed = false;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/delete.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startLongPress(BuildContext context) async {
    setState(() {
      _isButtonLongPressed = true;
      _buttonScale = 1.2;
    });

    // Start vibration
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate();
    }

    // Wait for long press duration
    await Future.delayed(Duration(seconds: 3));

    // Delete records and show feedback
    if (_isButtonLongPressed) {
      _deleteAllRecords(context);
    }
  }

  void _endLongPress() async {
    setState(() {
      _isButtonLongPressed = false;
      _buttonScale = 1.0;
    });

    // Stop vibration
    Vibration.cancel();
  }

  void _deleteAllRecords(BuildContext context) async {
    await Provider.of<VisitProvider>(context, listen: false).deleteAllVisits();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Todas las visitas han sido eliminadas.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Center(child: CircularProgressIndicator()), // Mostrar un indicador de carga mientras el video se inicializa
          Positioned(
            top: 50,
            child: Text(
              'Delete all visits',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: Transform.scale(
              scale: _buttonScale,
              child: GestureDetector(
                onLongPressStart: (_) => _startLongPress(context),
                onLongPressEnd: (_) => _endLongPress(),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
