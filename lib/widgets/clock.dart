// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

// State
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
  bool snoozeOn = false;
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
  snoozeAlarm() async {
    // Get the alarm time from the state
    String? alarmTime =
        Provider.of<ApplicationState>(context, listen: false).alarmTime;

    // Get setAlarmTime from ApplicationState
    var setAlarmTime =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTime;

    // Get the snoozeMinutes from the state
    int snoozeMinutes =
        Provider.of<ApplicationState>(context, listen: false).snoozeMinutes;

    // Stop the alarm
    await player.stop();

    // Convert alarmTime to DateTime
    DateTime alarmTimeAsDateTime = DateFormat('h:mm a').parse(alarmTime!);

    // Add the set snooze minutes to the alarm time
    setAlarmTime(DateFormat('h:mm a').format(
      alarmTimeAsDateTime.add(
        Duration(minutes: snoozeMinutes),
      ),
    ));

    setState(() {
      // Set playOnce so the alarm doesn't play again
      playOnce = true;
      snoozeOn = true;
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
      snoozeOn = false;
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
    // Get the orientation
    Orientation orientation = MediaQuery.of(context).orientation;
    print(orientation);

    // Get alarmTime from ApplicationState
    String? alarmTime = Provider.of<ApplicationState>(context).alarmTime;

    // Get the snooze minutes from ApplicationState
    int snoozeMinutes = Provider.of<ApplicationState>(context).snoozeMinutes;

    // Get current time
    DateTime currentDate = DateTime.now();

    // Declare variables
    DateTime? alarmDateParsed;
    int snoozeLeft = 0;

    // Alarm is 'On'
    if (alarmTime != 'off') {
      // Split the alarm time into hours and minutes
      List<String> alarmParts = alarmTime!.split(" ");

      // Add a 0 to the hour if it's only 1 digit
      if (alarmParts[0].length == 4) {
        alarmParts[0] = '0${alarmParts[0]}';
      }

      if (alarmParts[1] == 'PM') {
        alarmParts[0] =
            "${int.parse(alarmParts[0].split(":")[0]) + 12}:${alarmParts[0].split(":")[1]}";
      }

      // If currentDate.month is single digit, add a 0 to the front
      String monthString = currentDate.month.toString();
      if (monthString.length == 1) {
        monthString = '0$monthString';
      }

      // If currentDate.day is single digit, add a 0 to the front
      String dayString = currentDate.day.toString();
      if (dayString.length == 1) {
        dayString = '0$dayString';
      }

      // Turn the alarm time into a string with the current date attached
      String alarmDateString =
          '${currentDate.year}-$monthString-$dayString ${alarmParts[0]}:00';

      // Turn the alarm date string into a DateTime
      alarmDateParsed = DateTime.parse(alarmDateString);
    }

    // A stream that emits the current time every second
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        // If the current time is the same as the alarm time, play the alarm
        if (DateFormat('h:mm a').format(DateTime.now()) == alarmTime) {
          playAlarm();
        }

        if (snoozeOn) {
          // Get the difference between the current time and the parseDt in minutes
          snoozeLeft =
              (alarmDateParsed!.difference(DateTime.now()).inMinutes) + 1;
        }

        return Column(
          children: [
            // If the alarm is on, show the alarm time and the snooze minutes
            if (alarmTime != 'off') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    alarmTime!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.snooze,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    '$snoozeMinutes mins',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  if (snoozeOn) ...[
                    Text(
                      ' - $snoozeLeft mins left',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ], //End of if(alarmTime != 'off') ...[

            // Show the snooze button
            if (showSnooze == true) ...[
              if (orientation == Orientation.portrait) ...[
                ElevatedButton(
                  onPressed: snoozeAlarm,
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
                // End of if(showSnooze == true)
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: snoozeAlarm,
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
                      width: 50,
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
                  ],
                )
              ]
            ] else ...[
              // Show the clock
              // First, check the orientation
              if (orientation == Orientation.portrait) ...[
                Text(
                  DateFormat('h:').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('mm').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('a').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                // Orientation is Landscape
              ] else ...[
                Text(
                  DateFormat('h:mm a').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 150,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}
