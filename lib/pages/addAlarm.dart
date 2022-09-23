// Dependencies
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  // Declare a text controller.
  TextEditingController alarmController = TextEditingController(text: '');

  // Function to save the alarm time
  saveAlarm(BuildContext context) async {
    print('Save alarm pressed');

    // Get the setAlarmTimes from ApplicationState
    var setAlarmTimes =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTimes;

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences alarms = await _prefs;
    List<String>? _alarmTimes = alarms.getStringList('time');
    print('Alarms: $_alarmTimes');
    // Add alarmController to _alarmTimes
    _alarmTimes!.add(alarmController.text);
    // await alarms.setStringList('time', _alarmTimes);
    // Set the alarmTimes in ApplicationState
    //print('Alarms: ${_alarmTimes.toString()}');
    setAlarmTimes(_alarmTimes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Add an Alarm',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),

            // Form to add an alarm time
            Form(
              child: Column(
                children: [
                  // A text field to enter the alarm time
                  TextFormField(
                    controller: alarmController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Alarm Time',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an alarm time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // A button to add the alarm time
                  ElevatedButton(
                    onPressed: () => {
                      saveAlarm(context),
                      // Back
                      Navigator.pop(context),
                    },
                    child: const Text('Add Alarm'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
