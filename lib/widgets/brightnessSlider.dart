// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BrightnessSlider extends StatefulWidget {
  const BrightnessSlider({super.key});

  @override
  State<BrightnessSlider> createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
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
          Slider(
              thumbColor: Theme.of(context).colorScheme.surface,
              inactiveColor: Theme.of(context).colorScheme.surface,
              activeColor: Theme.of(context).colorScheme.secondary,
              value: brightness,
              onChanged: (value) {
                setState(() {
                  brightness = value;
                });
                ScreenBrightness().setApplicationScreenBrightness(brightness);
              }),
        ],
      ),
    );
  }
}
