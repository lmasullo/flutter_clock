// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  // @override
  // void initState() {
  //   player.setAsset('assets/sounds/thanksgiving.mp4');
  //   super.initState();
  // }

  String alarmTime = '10:44';

  final player = AudioPlayer();
  bool showSnooze = false;
  bool playOnce = false;

  void playAlarm() async {
    if (playOnce == false) {
      print('Playing alarm');
      await player.setAsset('assets/sounds/thanksgiving.mp4');
      await player.play();
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      playOnce = true;
      showSnooze = true;
    });
  }

  void reset() async {
    await player.stop();
    setState(() {
      showSnooze = false;
      playOnce = false;
    });
  }

  void snoozeAlarm() async {
    print('Snoozing alarm');
    await player.stop();

    setState(() {
      // Convert alarmTime to DateTime
      DateTime alarmTimeAsDateTime = DateFormat('h:mm').parse(alarmTime);
      // Add 10 minutes to the alarm time
      alarmTime = DateFormat('h:mm').format(
        alarmTimeAsDateTime.add(
          const Duration(minutes: 1),
        ),
      );
      playOnce = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      showSnooze = false;
      playOnce = false;
    });
  }

  void stopAlarm() async {
    print('Stop alarm');
    await player.stop();

    setState(() {
      playOnce = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      showSnooze = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int digitColor = 0xFF594747;

    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (DateFormat('h:mm').format(DateTime.now()) == alarmTime) {
          playAlarm();
        }

        return Column(
          children: [
            // Text(
            //   alarmTime,
            //   style: const TextStyle(color: Colors.white),
            // ),
            // ElevatedButton(onPressed: reset, child: const Text('Reset')),
            // if (showSnooze == false) ...[
            //   ElevatedButton(onPressed: playAlarm, child: const Text('Play')),
            // ],
            Text(
              'playOnce: $playOnce',
              style: TextStyle(color: Colors.white),
            ),
            if (showSnooze == true) ...[
              ElevatedButton(
                onPressed: snoozeAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(300, 200),
                ),
                child: const Text('Snooze'),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: stopAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(300, 200),
                ),
                child: const Text('Stop'),
              ),
            ] else ...[
              Text(
                DateFormat('h:').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 250,
                  // PRIMARY COLOR 200 shade
                  color: Color(digitColor),
                  // color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                DateFormat('mm').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 250,
                  color: Color(digitColor),
                ),
              ),
              Text(
                DateFormat('a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 50,
                  color: Color(digitColor),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(digitColor),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
