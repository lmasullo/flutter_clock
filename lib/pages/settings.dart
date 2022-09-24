// Dependencies
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFF9E9393),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAlarm(),
            ),
          );
        },
        tooltip: 'Settings',
        child: const Icon(Icons.add),
      ),
    );
  }
}
