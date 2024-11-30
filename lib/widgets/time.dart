// Dependencies
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  late Timer _timer;
  late DateTime _currentTime;
  final player = AudioPlayer();
  bool snoozeOn = false;
  int snoozeLeft = 0;
  int snoozeMinutes = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    // Start a timer to update the time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  String _formatHour(int hour) {
    return (hour % 12 == 0 ? 12 : hour % 12)
        .toString(); // Convert 24-hour to 12-hour format
  }

  String _formatMinutes(int minutes) {
    return minutes
        .toString()
        .padLeft(2, '0'); // Pad single-digit minutes with a leading zero
  }

  String _getAmPm(int hour) {
    return hour >= 12 ? "PM" : "AM";
  }

  @override
  Widget build(BuildContext context) {
    // Variables
    final hour = _formatHour(_currentTime.hour);
    final minutes = _formatMinutes(_currentTime.minute);
    final amPm = _getAmPm(_currentTime.hour);
    String alarmTime = 'Off';

    return

        // Scaffold(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   appBar: AppBar(
        //     title: Text("Current Time"),
        //     backgroundColor: Theme.of(context).colorScheme.primary,
        //   ),
        //   body:

        Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min, // Shrink the column to its children
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 30,
                Icons.alarm,
                color: Theme.of(context).colorScheme.surface,
              ),
              Text(
                alarmTime,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                size: 30,
                Icons.snooze,
                color: Theme.of(context).colorScheme.surface,
              ),
              Text(
                snoozeOn ? '$snoozeLeft mins left' : '$snoozeMinutes mins',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          // Display the hour on top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // Make the : visible every other second
                hour,
                style: TextStyle(
                  fontSize: 200,
                  color: Theme.of(context).colorScheme.surface,
                  height: 1, // Reduce line height (default is ~1.2)
                ),
              ),
              Text(
                // Make the : visible every other second
                _currentTime.second % 2 == 0 ? ':' : ' ',
                style: TextStyle(
                  fontSize: 200,
                  color: Theme.of(context).colorScheme.surface,
                  height: 1, // Reduce line height (default is ~1.2)
                ),
              ),
            ],
          ),
          // Directly reduce spacing between hour and minutes/AM-PM
          Transform.translate(
            offset: Offset(0, -10), // Adjust vertical alignment
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minutes,
                  style: TextStyle(
                    fontSize: 200,
                    color: Theme.of(context).colorScheme.surface,
                    height: 1, // Match reduced line height
                  ),
                ),
                Text(
                  amPm,
                  style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.surface,
                    height: 1, // Align with reduced text height
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // );
  }
}
