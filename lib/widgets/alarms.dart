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
