// Dependencies
// import 'dart:async';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // List<String> alarmTimes = ['12:00', '13:00', '14:00'];

  // void _loadAlarms() async {
  //   print('Loading alarms $alarmTimes');
  //   final SharedPreferences alarms = await _prefs;

  //   print(alarms.getStringList('time'));
  //   setState(() {
  //     alarmTimes = alarms.getStringList('time') ?? [];
  //     print('Loading alarms $alarmTimes');
  //   });
  // }

  // Future<void> _addAlarm() async {
  //   print('Add alarm pressed');

  //   final SharedPreferences alarms = await _prefs;

  //   // Save an list of strings to 'alarms' key.
  //   await alarms.setStringList('time', <String>['10:00', '11:00', '12:00']);

  //   print('Alarms: ${alarms.getStringList('time')}');

  //   setState(() {
  //     alarmTimes = alarms.getStringList('time')!;
  //     print('Items: ${alarmTimes.toString()}');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    // Get the alarmTime from ApplicationState
    String? currentAlarm = Provider.of<ApplicationState>(context).alarmTime;

    // Get the alarmTimes from applicationState
    List<String> alarmTimes = Provider.of<ApplicationState>(context).alarmTimes;

    // Get setAlarmTime from ApplicationState
    var setAlarmTime = Provider.of<ApplicationState>(context).setAlarmTime;

    void deleteAlarm(String alarmTime) async {
      print('Delete alarm pressed');
      final SharedPreferences alarms = await _prefs;
      print('Alarm time: $alarmTime');

      alarmTimes.remove(alarmTime);

      await alarms.setStringList('time', alarmTimes);

      setState(() {
        alarmTimes = alarms.getStringList('time')!;
      });
    }

    return Column(
      children: [
        Center(
          child: ListView.builder(
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
                      print('Switched to No');
                      setAlarmTime('off');
                    } else {
                      print('Switched to Yes');
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
              );
            },
          ),
        ),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),

        // ElevatedButton(
        //   onPressed: _addAlarm,
        //   child: const Text('Add Dummy Alarm'),
        // ),

        // A button to add an alarm
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAlarm(),
              ),
            );
          },
          child: const Text('Add Alarm'),
        ),
      ],
    );
  }
}
