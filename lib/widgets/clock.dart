// Dependencies
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clock/state/applicationState.dart';

// Widgets
import 'package:flutter_clock/widgets/weather.dart';

class Clock extends ConsumerStatefulWidget {
  const Clock({super.key});

  @override
  ConsumerState<Clock> createState() => _ClockState();
}

class _ClockState extends ConsumerState<Clock> {
  // Set variables
  final player = AudioPlayer();
  bool? showSnooze;
  bool snoozeOn = false;
  int snoozeLeft = 0;
  String alarmTime = 'Off';
  int? snoozeMinutes;
  DateTime? currentTime;
  String? currentTimeString;

  // Initialize the local storage
  final LocalStorage localStorage = LocalStorage('snooze');

  convertAlarmTime(alarm) {
    // Get the last 2 characters (AM or PM) and strip them off
    String amPm = alarm.substring(alarm.length - 2);
    print('amPm: $amPm');
    // Get the first characters up to the AM or PM
    String alarmTimeTemp = alarm.substring(0, alarm.length - 2);
    print('alarmTimeTemp: $alarmTimeTemp');

    // Combine the alarmTime with the AM or PM
    return '$alarmTimeTemp $amPm';
  }

  // Function to play alarm sound
  void playAlarm() async {
    print('In playAlarm');

    // Get state of player
    final playerState = player.playerState.playing;
    print('playerState: $playerState');

    // Only play if playerState playing = false
    if (playerState == false) {
      // Play the audio source
      // await Future.delayed(const Duration(seconds: 1));
      setState(() {
        print('Setting showSnooze to true');
        showSnooze = true;
      });
      // Set the audio source
      await player.setAsset('assets/sounds/thanksgiving.mp4');
      await player.play();
    }
  }

  void stopAlarm() async {
    print('In stopAlarm');
    // Stop the audio source
    await player.stop();
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Set the alarm time to 'off'
      ref.read(applicationState.notifier).setAlarmTime('Off');

      // Turn off the snooze
      showSnooze = false;
    });
  }

  // Function to snooze the alarm
  void snoozeAlarm() async {
    print('In snoozeAlarm');
    //   // Get the alarm time from the state
    //   // String? alarmTimeSnooze = ref.read(applicationState.notifier).alarmTime;

    // Convert alarmTime to DateTime
    if (alarmTime != 'Off') {
      print('alarmTime in Snooze: $alarmTime');
      // Get the last 2 characters (AM or PM) and strip them off
      // String amPm = alarmTime.substring(alarmTime.length - 2);
      // print('amPm: $amPm');
      // Get the first characters up to the AM or PM
      // alarmTime = alarmTime.substring(0, alarmTime.length - 2);
      // print('alarmTime: $alarmTime');

      // Combine the alarmTime with the AM or PM
      // alarmTime = '$alarmTime $amPm';

      // Convert from the condensed time 1:00PM to 1:00 PM
      alarmTime = await convertAlarmTime(alarmTime);
      print('alarmTime after conversion: $alarmTime');

      DateTime alarmTimeAsDateTime = DateFormat('h:mm a').parse(alarmTime);
      print('alarmTimeAsDateTime: $alarmTimeAsDateTime');

      // Add the set snooze minutes to the alarm time
      ref.read(applicationState.notifier).setAlarmTime(
            DateFormat('h:mm a').format(alarmTimeAsDateTime.add(
              Duration(minutes: snoozeMinutes!),
            )),
          );
      // await Future.delayed(const Duration(seconds: 1));
      // Get the new alarm time
      // String alarmTime2 = ref.read(applicationState.notifier).alarmTime!;
      // print('New alarmTime: $alarmTime2');
    }

    // Stop the audio source
    await player.stop();
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Set the alarm time to 'off'
      ref.read(applicationState.notifier).setAlarmTime('Off');

      // Turn off the snooze
      showSnooze = false;
      snoozeOn = true;
      snoozeLeft = snoozeMinutes!;
    });
  }

  // void startTimer(alarm) {
  // print('In startTimer');
  // // if (_timer != null) {
  // //   _timer!.cancel();
  // // }
  // Timer.periodic(const Duration(seconds: 5), (timer) {
  //   // print('Timer in Clock');
  //   // alarmTime = ref.watch(applicationState.notifier).alarmTime;

  //   print('alarmTime in clock: $alarm');
  //   // Get current time
  //   // currentTime = DateTime.now();
  //   // Convert to a String
  //   currentTimeString = DateFormat('h:mm a').format(currentTime!);
  //   // currentTimeString = '9:15 PM';
  //   print('currentTimeString: $currentTimeString');

  //   // Compare currentTimeString to alarmTime
  //   if (alarmTime != null) {
  //     if (currentTimeString == alarm) {
  //       print('Play Alarm!!!!!! ');
  //       // playAlarm();
  //     }
  //   }

  //   // Alarm is 'On'
  //   // if (alarmTime != 'Off' && alarmTime != null) {
  //   // print(DateFormat('h:mm a').format(currentTime));
  //   // print('alarmTime in clock: $alarmTime');

  //   // if (DateFormat('h:mm a').format(currentTime!).toString() ==
  //   // alarmTime.toString()) {
  //   // print('Play Alarm!!!!!! ');
  //   // playAlarm();
  //   // }
  //   // }
  // });
  // }

  // void stopTimer() async {
  //   // Delay for 1 second
  //   Future.delayed(const Duration(milliseconds: 250), () async {
  //     print('In stopTimer');
  //     if (_timer != null) {
  //       // ref.read(applicationState.notifier).setAlarmTime('Off');
  //       _timer!.cancel();
  //     }
  //   });
  // }

  void calculateSnoozeLeft() async {
    print('In calculateSnoozeLeft: $alarmTime');
    alarmTime = await convertAlarmTime(alarmTime);
    print('In calculateSnoozeLeft 2: $alarmTime');

    DateTime alarmTimeAsDateTime = DateFormat('h:mm a').parse(alarmTime);
    print('alarmTimeAsDateTime: $alarmTimeAsDateTime');

    // Get just the time from DateTime.now()
    String currentTimeString = DateFormat('h:mm a').format(DateTime.now());
    print('currentTimeString: $currentTimeString');

    // Look at the current time, not date and compare it to the alarm time
    int snoozeLeftTemp = (alarmTimeAsDateTime
        .difference(DateFormat('h:mm a').parse(currentTimeString))
        .inMinutes);
    print('snoozeLeftTemp: $snoozeLeftTemp');
    setState(() {
      snoozeLeft = snoozeLeftTemp;
      // print('snoozeLeft: $snoozeLeft');
    });
  }

  @override
  void initState() {
    super.initState();
    print('initState in Clock');
    // Get the alarm time from local storage
  }

  @override
  Widget build(BuildContext context) {
    print('Building Clock...');
    // Get the orientation
    Orientation orientation = MediaQuery.of(context).orientation;

    // Get the snooze minutes from ApplicationState
    snoozeMinutes = ref.watch(applicationState.notifier).snoozeMinutes;

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          // print('StreamBuilder in clock');

          alarmTime = ref.watch(applicationState.notifier).alarmTime!;
          // print('alarmTime in Clock: $alarmTime');

          // Get the last 2 characters of alarmTime
          if (alarmTime != 'Off') {
            // Get the last 2 characters (AM or PM
            String amPm = alarmTime.substring(alarmTime.length - 2);
            print('amPm: $amPm');

            // Get the first characters up to the space
            alarmTime = alarmTime.substring(0, alarmTime.length - 3);

            // Add alarmTime to the last 2 characters
            alarmTime = '$alarmTime$amPm';

            print('alarmTime: $alarmTime');

            // alarmTime = alarmTime!.replaceAll('', '');
            // print('alarmTime length: ${alarmTime!.length}');
            // Check if there are any spaces in the alarmTime
            // if (alarmTime!.length > 8) {
            //   // Strip all the blank spaces
            //   alarmTime = alarmTime!.replaceAll(' ', '');
            // }

            // print('alarmTime in Clock: $alarmTime');
            // alarmTime = '8:00 AM';
            currentTime = DateTime.now();
            currentTimeString = DateFormat('h:mm a').format(currentTime!);
            // Strip all the blank spaces
            currentTimeString = currentTimeString!.replaceAll(' ', '');
            // currentTimeString = '8:00 AM';
            print('currentTimeString: $currentTimeString');

            // Compare currentTimeString to alarmTime
            // if (alarmTime != null) {
            if (currentTimeString! == alarmTime) {
              print('Play Alarm!!!!!! ');
              playAlarm();
            }
          }

          if (snoozeOn) {
            // Get the difference between the current time and the alarm time in minutes
            calculateSnoozeLeft();
          }

          // Future.delayed(const Duration(seconds: 1));

          // startTimer('9:18 PM');

          // alarmTime = ref.watch(applicationState.notifier).alarmTime;
          // print('alarmTime in Clock: $alarmTime');
          // int? snoozeMinutes = ref.watch(applicationState.notifier).snoozeMinutes;
          // alarmTime = localStorage.getItem('alarmTime');
          // if (alarmTime == null) {
          //   alarmTime = 'Off';
          // }
          // if (alarmTime != 'Off' && alarmTime != null) {
          //   startTimer(alarmTime!);
          // } else {
          //   print('Stop Timer');
          //   // Stop the timer

          //   stopTimer();
          // }

          // Pause for 1 second
          // Future.delayed(const Duration(seconds: 1));

          // Get the snooze minutes from ApplicationState
          // int? snoozeMinutes;
          // snoozeMinutes = localStorage.getItem('snoozeMinutes');
          // snoozeMinutes ??= ref.watch(applicationState.notifier).snoozeMinutes;

          // Get current time
          // DateTime currentDate = DateTime.now();

          // int snoozeLeft = 0;

          // alarmTime = ref.watch(applicationState.notifier).alarmTime;
          // Convert alarmTime to DateTime
          // if (alarmTime != 'off') {
          //   DateTime alarmDateParsed = DateTime.parse(alarmTime!);
          //   print('alarmTimeAsDateTime: $alarmDateParsed');
          // }

          // Alarm is 'On'
          // if (alarmTime != 'off') {
          // // print('alarmTime on Clock: $alarmTime');
          // // Cut off the last 2 characters to get AM or PM
          // // String alarmAmPm = alarmTime!.substring(alarmTime.length - 2);
          // // print('alarmAmPm: $alarmAmPm');
          // // Get the time from the first characters
          // alarmTime = alarmTime!.substring(0, alarmTime.length - 3);
          // // print('alarmTime: $alarmTime');

          // // Split it into hours and minutes
          // List<String> alarmParts = alarmTime.split(':');
          // // print('alarmParts: $alarmParts');
          // // print('alarmParts 0: ${alarmParts[0]}');
          // // print('alarmParts 1: ${alarmParts[1]}');

          // // Add a 0 to the hour if it's only 1 digit
          // if (alarmParts[0].length == 1) {
          //   alarmParts[0] = '0${alarmParts[0]}';
          // }

          // if (alarmParts[1] == 'PM') {
          //   alarmParts[0] =
          //       "${int.parse(alarmParts[0]) + 12}:${alarmParts[0].split(":")[1]}";
          // }

          // // If currentDate.month is single digit, add a 0 to the front
          // String monthString = currentDate.month.toString();
          // if (monthString.length == 1) {
          //   monthString = '0$monthString';
          // }

          // // If currentDate.day is single digit, add a 0 to the front
          // String dayString = currentDate.day.toString();
          // if (dayString.length == 1) {
          //   dayString = '0$dayString';
          // }

          // // Turn the alarm time into a string with the current date attached
          // String alarmDateString =
          //     '${currentDate.year}-$monthString-$dayString ${alarmParts[0]}:00';

          // // Turn the alarm date string into a DateTime
          // alarmDateParsed = DateTime.parse(alarmDateString);
          // }

          // A stream that emits the current time every second
          // return

          // StreamBuilder(
          //   stream: Stream.periodic(const Duration(seconds: 5)),
          //   builder: (context, snapshot) {
          //     print('Streambuilder in clock');

          // If the current time is the same as the alarm time, play the alarm
          // print('alarm time 2: $alarmTime2');
          // print('current time: ${DateFormat('h:mm a').format(DateTime.now())}');

          // Convert alarmTime2 to DateTime
          // DateTime alarmTime3 = DateFormat('h:mm a').parse(alarmTime2!);
          // Convert DateFormat('h:mm a').format(DateTime.now()) to a string
          // String currentTime =
          //     DateFormat('h:mm a').format(DateTime.now()).toString();
          // print('currentTime in stream: $currentTime');

          // Convert widget.alarmTime into 24 hour time base on AM/PM

          // Convert 12:15 PM to 24 hour time

          // print(DateTime.now());

          // String test = '2024-03-25 12:15';

          // Get the AM/PM (last two characters) of widget.alarmTime
          // var newString = widget.alarmTime.substring(-2);
          // print('alarm time: ${widget.alarmTime}');

          // if (widget.alarmTime != 'off') {
          //   String alarmTime =
          //       widget.alarmTime.substring(0, widget.alarmTime.length - 3);
          //   // print('alarm time: $alarmTime');
          //   String amPm = widget.alarmTime.substring(widget.alarmTime.length - 2);
          //   // print('new string: ${amPm}');
          //   // Convert the widget.alarmTime to 24 hour time base on the AM/PM that is amPm
          //   if (amPm == 'PM') {
          //     List<String> alarmParts = alarmTime.split(':');
          //     // print('alarmParts: $alarmParts');
          //     // print('alarmParts 0: ${alarmParts[0]}');
          //     // print('alarmParts 1: ${alarmParts[1]}');
          //     alarmTime = "${int.parse(alarmParts[0]) + 12}:${alarmParts[1]}";
          //     // print('alarmTime: $alarmTime');
          //   }

          // print(DateFormat('mm-dd-yyy').format(DateTime.now()).toString());

          // Declare parsed alarmTine
          // DateTime alarmDateParsed = DateTime.parse(test);

          // print('currentTime: $currentTime');
          // print('parsed alarmTime: $alarmDateParsed');
          //}

          // String? alarmTime = ref.read(applicationState.notifier).alarmTime;
          // print('alarmTime on Clock: $alarmTime');

          // print('alarmTime in stream: ${widget.alarmTime}');

          // String test1 = '12:00 AM';
          // String test2 = '12:00 AM';

          // print('Alarm3: $alarmTime3');

          // print('Alarm2 length: ${alarmTime2!.length}');
          // print('Alarm3 length: ${alarmTime3.length}');
          // if (currentTime == widget.alarmTime) {
          //   print('Play Alarm!!!!!! ');
          //   // playAlarm();
          // }

          // if (snoozeOn) {
          //   // Get the difference between the current time and the parseDt in minutes
          //   snoozeLeft =
          //       (alarmDateParsed!.difference(DateTime.now()).inMinutes) + 1;
          // }

          // Wait for widget to build

          //

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   // rebuild();
          // });

          return SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                // If the alarm is on, show the alarm time and the snooze minutes
                Text('showSnooze: $showSnooze'),
                // Button to start the alarm
                ElevatedButton(
                  onPressed: () {
                    playAlarm();
                  },
                  child: Text('Start Alarm'),
                ),

                // Button to stop the alarm
                ElevatedButton(
                  onPressed: () {
                    stopAlarm();
                  },
                  child: Text('Stop Alarm'),
                ),
                if (alarmTime != 'off') ...[
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
                        snoozeOn
                            ? '$snoozeLeft mins left'
                            : '$snoozeMinutes mins',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],

                // if (snoozeOn) ...[
                //   Text(
                //     '$snoozeLeft mins left',
                //     style: TextStyle(
                //       color: Theme.of(context).colorScheme.surface,
                //       fontSize: 18,
                //     ),
                //   ),
                // ], //End of if(alarmTime != 'off') ...[

                // Show the snooze button
                if (showSnooze == true) ...[
                  // if (orientation == Orientation.portrait) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        snoozeAlarm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        minimumSize: const Size(300, 200),
                      ),
                      child: Text(
                        'Snooze',
                        style: TextStyle(
                          fontSize: 50,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      stopAlarm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      minimumSize: const Size(300, 200),
                    ),
                    child: Text(
                      'Stop',
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  // End of if(showSnooze == true)
                  //   ] else ...[
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         ElevatedButton(
                  //           onPressed: (){
                  //             // snoozeAlarm
                  //             },
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor:
                  //                 Theme.of(context).colorScheme.onPrimary,
                  //             minimumSize: const Size(300, 200),
                  //           ),
                  //           child: Text(
                  //             'Snooze',
                  //             style: TextStyle(
                  //               fontSize: 50,
                  //               color: Theme.of(context).colorScheme.onPrimary,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(
                  //           width: 50,
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: (){
                  //             // stopAlarm
                  //           },
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor:
                  //                 Theme.of(context).colorScheme.surface,
                  //             minimumSize: const Size(300, 200),
                  //           ),
                  //           child: Text(
                  //             'Stop',
                  //             style: TextStyle(
                  //               fontSize: 50,
                  //               color: Theme.of(context).colorScheme.onPrimary,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     )
                  //   ]
                  // ] else ...[
                ] else ...[
                  // Show the clock
                  // No Snooze
                  // First, check the orientation
                  // !Portrait
                  if (orientation == Orientation.portrait) ...[
                    Text(
                      DateFormat('h:').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 175,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('mm').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 175,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('a').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 50,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // !Weather widget
                    const Weather(
                      rebuild: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),

                    // Orientation is Landscape
                  ] else ...[
                    Text(
                      DateFormat('h:mm a').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 125,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d, yyyy')
                              .format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child:
                                // !Weather widget
                                Weather(
                              rebuild: true,
                            )),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          );
        });
  }
}
