// Dependencies
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clock/state/applicationState.dart';

// Pages
import 'package:flutter_clock/main.dart';

// Widgets
import 'package:flutter_clock/widgets/alarms.dart';
import 'package:flutter_clock/widgets/cities.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  // Set variables
  // Initialize the local storage
  // final LocalStorage localStorage = LocalStorage('snooze');
  final player = AudioPlayer();
  bool playing = false;
  int? snoozeMinutes;
  int? snoozeMinutesState;
  String? weatherCity;
  TextEditingController cityNameController = TextEditingController();

  // Function to play alarm sound
  void playAlarm() async {
    // Set the audio source
    await player.setAsset('assets/sounds/thanksgiving.mp4');
    // Play the audio source
    await player.play();
  }

  // Function to stop the alarm
  void stopAlarm() async {
    // Set the audio source
    await player.setAsset('assets/sounds/thanksgiving.mp4');
    // Play the audio source
    await player.stop();
  }

  // Define a function to update the data, comes from cities
  void rebuild() {
    // Updating the widget
    print('Updating the widget with');
    // setState(() {});
    getWeatherLocal();
  }

  void getWeatherLocal() async {
    String? weatherCityLocal = localStorage.getItem('weatherCity');

    setState(() {
      print('set weather: $weatherCityLocal');
      cityNameController = TextEditingController(
        text: weatherCityLocal,
      );
    });
  }

  // Function to set local storage using a future to eliminate file exception errors
  Future<bool> setLocalItem(localVariable, value) async {
    localStorage.setItem(localVariable, value);
    return true;
  }

  @override
  void initState() {
    super.initState();
    print('initState in settings');
    getWeatherLocal();
  }

  setSnoozeMinutesLocal() async {
    int? snoozeLocal = localStorage.getItem('snoozeMinutes') as int?;

    print('snoozeLocal: $snoozeLocal');

    // Wait for the widget to load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (snoozeLocal == null) {
          ref.read(applicationState.notifier).setSnoozeMinutes(9);
        } else {
          ref.read(applicationState.notifier).setSnoozeMinutes(snoozeLocal);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('building settings...');

    snoozeMinutes = ref.watch(applicationState.notifier).snoozeMinutes;
    if (snoozeMinutes == null) {
      setSnoozeMinutesLocal();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: BackButton(
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                          title: 'Snooze',
                        )),
              );
            }),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text('alarmTime: $alarmTime'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Alarms',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
            ),
            Text('(version 1.18.0)',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary)),
            const SizedBox(height: 20),
            Text(
              'Set Snooze Minutes: $snoozeMinutes',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            // A slider to set the snooze minutes
            Slider(
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.surface,
              thumbColor: Theme.of(context).colorScheme.onPrimary,
              value: snoozeMinutes == null ? 1 : snoozeMinutes!.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: snoozeMinutes.toString(),
              onChanged: (double value) async {
                setState(() {
                  ref
                      .read(applicationState.notifier)
                      .setSnoozeMinutes(value.toInt());
                });
              },
            ),

            Cities(onDataChange: rebuild),

            const SizedBox(
              height: 20,
            ),

            const Text('Weather City Name (can change the country code)'),

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
                        labelText: 'Weather City Name',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => setState(() {
                // If playing is true, then stop the alarm
                if (playing) {
                  playing = false;
                  stopAlarm();
                } else {
                  playing = true;
                  playAlarm();
                }
              }),
              child:
                  playing ? const Text('Stop Alarm') : const Text('Play Alarm'),
            ),

            const SizedBox(height: 20),

            // Widget to show alarms and add new alarms
            const Alarms(),
          ],
        ),
      ),
    );
  }
}
