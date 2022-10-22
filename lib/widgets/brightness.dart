// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';

class Brightness extends StatefulWidget {
  const Brightness({super.key});

  @override
  State<Brightness> createState() => _BrightnessState();
}

class _BrightnessState extends State<Brightness> {
  // Variables
  double brightness = 0.0;

  @override
  void initState() {
    super.initState();
    initPlatformBrightness();
  }

  Future<void> initPlatformBrightness() async {
    double bright;

    try {
      bright = await ScreenBrightness().system;
    } on PlatformException {
      bright = 1.0;
    }
    if (!mounted) return;
    setState(() {
      brightness = bright;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Text(
            'Adjust Brightness',
            style:
                TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
          ),
          Slider(
            value: brightness,
            onChanged: (value) {
              FlutterScreenWake.setBrightness(value);
              setState(() {
                brightness = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
