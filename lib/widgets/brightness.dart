// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';

class Brightness extends StatefulWidget {
  const Brightness({super.key});

  @override
  State<Brightness> createState() => _BrightnessState();
}

class _BrightnessState extends State<Brightness> {
  double brightness = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('Adjust Brightness',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              )),
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
