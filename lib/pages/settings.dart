// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

// Pages
import '../pages/addAlarm.dart';

// Widgets
import '../widgets/alarms.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Get setAlarmTime from ApplicationState
  void setAlarmTime(BuildContext context, String? alarmTime) {
    Provider.of<ApplicationState>(context, listen: false)
        .setAlarmTime(alarmTime);
  }

  @override
  Widget build(BuildContext context) {
    // Get the snoozeMinutes from the state
    int snoozeMinutes =
        Provider.of<ApplicationState>(context, listen: false).snoozeMinutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Alarms', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 20),
            Text(
              'Set Snooze Minutes: $snoozeMinutes',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            // A slider to set the snooze minutes
            Slider(
              value: snoozeMinutes.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: Provider.of<ApplicationState>(context)
                  .snoozeMinutes
                  .toString(),
              onChanged: (double value) {
                Provider.of<ApplicationState>(context, listen: false)
                    .setSnoozeMinutes(value.toInt());
              },
            ),

            const SizedBox(height: 20),

            const Alarms(),

            // Button to setAlarmTime to now
            ElevatedButton(
              onPressed: () {
                setAlarmTime(
                    context, DateFormat('h:mm').format(DateTime.now()));

                // Create a random string for the alarm id
                // String idGenerator() {
                //   final now = DateTime.now();
                //   return now.microsecondsSinceEpoch.toString();
                // }
              },
              child: const Text('Now'),
            ),
          ],
        ),
      ),
    );
  }
}
