// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

// Widgets
import '../widgets/alarms.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // Get setAlarmTime from ApplicationState
    var setAlarmTime =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTime;

    // Get the snoozeMinutes from the state
    int snoozeMinutes =
        Provider.of<ApplicationState>(context, listen: false).snoozeMinutes;

    // Get the setSnoozeMinutes from ApplicationState
    var setSnoozeMinutes =
        Provider.of<ApplicationState>(context, listen: false).setSnoozeMinutes;

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
                setSnoozeMinutes(value.toInt());
              },
            ),

            const SizedBox(height: 20),

            // Widget to show alarms and add new alarms
            const Alarms(),

            // Button to setAlarmTime to now
            ElevatedButton(
              onPressed: () {
                setAlarmTime(DateFormat('h:mm a').format(DateTime.now()));
              },
              child: const Text('Now'),
            ),
          ],
        ),
      ),
    );
  }
}
