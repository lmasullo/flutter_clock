// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

// State
// import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  void initState() {
    super.initState();
  }

  // Set variables
  final player = AudioPlayer();
  bool showSnooze = false;
  bool playOnce = false;

  // Function to play alarm sound
  void playAlarm() async {
    // Only play the alarm once
    if (playOnce == false) {
      // Set the audio source
      await player.setAsset('assets/sounds/thanksgiving.mp4');
      // Play the audio source
      await player.play();
    }
    // Wait 1 second before setting state, had some build errors
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      playOnce = true;
      showSnooze = true;
    });
  }

  // Function to snooze the alarm
  snoozeAlarm(snoozeMinutes) async {
    // Get the alarm time from the state
    String? alarmTime =
        Provider.of<ApplicationState>(context, listen: false).alarmTime;

    // Get setAlarmTime from ApplicationState
    var setAlarmTime =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTime;

    // Stop the alarm
    await player.stop();

    // Convert alarmTime to DateTime
    DateTime alarmTimeAsDateTime = DateFormat('h:mm').parse(alarmTime!);

    // Add the set snooze minutes to the alarm time
    setAlarmTime(DateFormat('h:mm a').format(
      alarmTimeAsDateTime.add(
        Duration(minutes: snoozeMinutes),
      ),
    ));

    setState(() {
      // Set playOnce so the alarm doesn't play again
      playOnce = true;
    });

    // Delay for 1 second
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Hide the snooze button
      showSnooze = false;

      // Reset playOnce so the alarm can play again
      playOnce = false;
    });
  }

  void stopAlarm() async {
    // Get setAlarmTime from ApplicationState
    var setAlarmTime =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTime;
    await player.stop();

    setState(() {
      // Set the alarm time to 'off'
      setAlarmTime('off');

      // Set playOnce so the alarm doesn't play again
      playOnce = true;
    });
    // Delay for 1 second
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Hide the snooze button
      showSnooze = false;

      // Reset playOnce so the alarm can play again
      playOnce = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get alarmTime from ApplicationState
    String? alarmTime = Provider.of<ApplicationState>(context).alarmTime;

    // Get the snooze minutes from ApplicationState
    int snoozeMinutes = Provider.of<ApplicationState>(context).snoozeMinutes;

    // Set the color
    int digitColor = 0xFF594747;

    // A stream that emits the current time every second
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        // If the current time is the same as the alarm time, play the alarm
        if (DateFormat('h:mm a').format(DateTime.now()) == alarmTime) {
          playAlarm();
        }

        return Column(
          children: [
            // If the alarm is on, show the alarm time and the snooze minutes
            if (alarmTime != 'off') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm, color: Color(digitColor)),
                  Text(
                    alarmTime!,
                    style: TextStyle(
                      color: Color(digitColor),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.snooze, color: Color(digitColor)),
                  Text(
                    '$snoozeMinutes mins',
                    style: TextStyle(
                      color: Color(digitColor),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // A text box that shows how many minutes left until the alarm goes off
                  Text(
                    '${DateFormat('mm').format(DateTime.now().difference(DateFormat('h:mm a').parse(alarmTime)).abs())} mins',
                    style: TextStyle(
                      color: Color(digitColor),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],

            // Show the snooze button
            if (showSnooze == true) ...[
              ElevatedButton(
                onPressed: () => snoozeAlarm(snoozeMinutes),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(300, 200),
                ),
                child: const Text(
                  'Snooze',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
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
                child: const Text(
                  'Stop',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else ...[
              Text(
                DateFormat('h:').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 225,
                  color: Color(digitColor),
                ),
              ),
              Text(
                DateFormat('mm').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 225,
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
