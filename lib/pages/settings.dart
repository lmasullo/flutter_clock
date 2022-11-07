// Dependencies
import 'package:flutter/material.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

// Pages
import '../pages/addAlarm.dart';

// Widgets
import '../widgets/alarms.dart';
import '../widgets/cities.dart';

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

    final cityNameController = TextEditingController(
        text: Provider.of<ApplicationState>(context).weatherCity);

    // Get the setCityName from ApplicationState
    var setCityName =
        Provider.of<ApplicationState>(context, listen: false).setCityName;

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
            const Text('(version 1.16)', style: TextStyle(fontSize: 18)),
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

            // const SizedBox(height: 20),

            const Cities(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // A text field to set the city name
                  Expanded(
                    child: TextField(
                      controller: cityNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            'Weather City Name (can change the country code)',
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        setCityName(cityNameController.text);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "City Name Saved!",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.orange,
                          duration: Duration(milliseconds: 1500),
                        ));
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
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
