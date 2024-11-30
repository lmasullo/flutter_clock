// Dependencies
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toggle_switch/toggle_switch.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clock/state/applicationState.dart';

// Pages
import 'package:flutter_clock/pages/addAlarm.dart';

class Alarms extends ConsumerStatefulWidget {
  const Alarms({super.key});

  // final Function(String) onDataChange;

  @override
  ConsumerState<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends ConsumerState<Alarms> {
  // Variables
  List<dynamic> alarmTimes = [];

  // Function to set local storage using a future to eliminate file exception errors
  Future<bool> setLocalItem(localVariable, value) async {
    localStorage.setItem(localVariable, value);
    return true;
  }

  // Function to get local alarms on init state from local storage
  getLocalAlarms() async {
    List<dynamic>? alarmTimesLocal =
        localStorage.getItem('alarmTimes') as List?;
    if (alarmTimesLocal != null) {
      setState(() {
        // Get from state if not in local storage
        ref.read(applicationState.notifier).setAlarmTimes(alarmTimesLocal);
        alarmTimes = alarmTimesLocal;
      });
    }
  }

  void deleteAlarm(String alarmTime) async {
    // Remove
    alarmTimes.remove(alarmTime);
    setState(() {
      // Update state
      ref.read(applicationState.notifier).setAlarmTimes(alarmTimes);
      // Set local storage
      setLocalItem('alarmTimes', alarmTimes);
    });
    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Alarm Deleted!",
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocalAlarms();
  }

  @override
  Widget build(BuildContext context) {
    // print('building alarms...');
    // Get the alarmTime from ApplicationState
    String? currentAlarm = ref.watch(applicationState.notifier).alarmTime;

    // Convert  to 24 time
    DateTime convertTime(String time) {
      // Get the characters to the left of :
      String hour = time.substring(0, time.indexOf(':'));

      // Get the 2 characters to the right of :
      String minutes =
          time.substring(time.indexOf(':') + 1, time.indexOf(':') + 3);

      // Get the last 2 characters
      String amPm = time.substring(time.length - 2);
      // print('amPm $amPm');

      int hourInt = int.parse(hour);
      int minuteInt = int.parse(minutes);

      if (amPm == 'PM') {
        hourInt += 12;
      }

      if (hourInt == 24) {
        hourInt = 12;
      }

      String hourString = hourInt.toString();
      String minuteString = minuteInt.toString();

      if (hourInt < 10) {
        hourString = '0$hourString';
      }

      if (minuteInt < 10) {
        minuteString = '0$minuteString';
      }

      // Get today's date
      DateTime now = DateTime.now();
      // Get just the first 10 characters
      String date = now.toString().substring(0, 10);

      return DateTime.parse('$date $hourString:$minuteString');
    }

    // Sort the alarmTimes
    alarmTimes.sort((a, b) => convertTime(a).compareTo(convertTime(b)));

    return Column(
      children: [
        FloatingActionButton(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAlarm(alarmTimes: alarmTimes),
              ),
            );
          },
          tooltip: 'Add an Alarm',
          child: const Icon(Icons.add),
        ),
        if (alarmTimes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text('No Alarms Set'),
            ),
          ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: alarmTimes.length,
          itemBuilder: (BuildContext context, int index) {
            String? alarmTime = alarmTimes[index];

            return ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  alarmTime!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              leading: ToggleSwitch(
                minWidth: 50.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.red[800]!],
                  [Colors.green[800]!],
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: currentAlarm == alarmTime ? 1 : 0,
                totalSwitches: 2,
                labels: const ['Off', 'On'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    if (index == 0) {
                      ref.read(applicationState.notifier).setAlarmTime('Off');
                      // widget.onDataChange('Update Settings!');
                    } else {
                      ref
                          .read(applicationState.notifier)
                          .setAlarmTime(alarmTime);
                    }
                  });
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteAlarm(alarmTimes[index]);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAlarm(
                            alarmTimes: alarmTimes,
                            alarm: alarmTime,
                          )),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
