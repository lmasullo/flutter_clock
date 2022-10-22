// Dependencies
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

// Pages
import '../pages/addAlarm.dart';

class Alarms extends StatefulWidget {
  const Alarms({Key? key}) : super(key: key);

  @override
  AlarmsState createState() => AlarmsState();
}

class AlarmsState extends State<Alarms> {
  // Set the shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the alarmTime from ApplicationState
    String? currentAlarm = Provider.of<ApplicationState>(context).alarmTime;

    // Get the alarmTimes from applicationState
    List<String> alarmTimes = Provider.of<ApplicationState>(context).alarmTimes;

    print('alarmTimes current $alarmTimes');

    // Convert 4:06 PM to 24 time
    String convertTime(String time) {
      // Get the characters to the left of :
      String hour = time.substring(0, time.indexOf(':'));
      // String hour = time.substring(0, 2);
      print('hour $hour');

      // Get the 2 characters to the right of :
      String minutes =
          time.substring(time.indexOf(':') + 1, time.indexOf(':') + 3);

      // String minute = time.substring(3, 5);
      print('minutes $minutes');
      // String amPm = time.substring(5, 7);
      // print('amPm $amPm');

      // Get the last 2 characters
      String amPm = time.substring(time.length - 2);
      print('amPm $amPm');

      int hourInt = int.parse(hour);
      int minuteInt = int.parse(minutes);

      if (amPm == 'PM') {
        hourInt += 12;
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
      // Get just the date from now
      // DateTime date = DateTime(now.year, now.month, now.day);

      print('$date $hourString:$minuteString');

      return '$date $hourString:$minuteString';
      // return '4:06 PM';
    }

    convertTime('1:06 AM');

    // // Map over alarmTimes and change the time to a valid dateTime
    // List<DateTime> alarmTimesDateTime = alarmTimes
    //     .map((e) => DateTime.parse('2021-01-01 $e'))
    //     .toList(growable: false);

    // print('alarmTimesDateTime $alarmTimesDateTime');

    // // Convert the array of alarmTimes to an array of DateTime objects
    // List<DateTime> times = alarmTimes.map((e) => DateTime.parse(e)).toList();
    // print('times current $times');

    // Get setAlarmTime from ApplicationState
    var setAlarmTime = Provider.of<ApplicationState>(context).setAlarmTime;

    void deleteAlarm(String alarmTime) async {
      final SharedPreferences alarms = await _prefs;

      alarmTimes.remove(alarmTime);

      await alarms.setStringList('time', alarmTimes);

      setState(() {
        alarmTimes = alarms.getStringList('time')!;
      });
    }

    return Column(
      children: [
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
                  alarmTime,
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
                  if (index == 0) {
                    setAlarmTime('off');
                  } else {
                    setAlarmTime(alarmTime);
                  }
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteAlarm(alarmTimes[index]);
                },
              ),
              onTap:
                  // Go to AddAlarm
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAlarm(alarm: alarmTimes[index])),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
