// ignore_for_file: file_names
// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clock/state/applicationState.dart';

// Pages
import 'package:flutter_clock/pages/settings.dart';

class AddAlarm extends ConsumerStatefulWidget {
  const AddAlarm({super.key, this.alarm, required this.alarmTimes});

  final List<dynamic> alarmTimes;
  final String? alarm;
  @override
  ConsumerState<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends ConsumerState<AddAlarm> {
  // Variables
  // Initialize the local storage
  final LocalStorage localStorage = LocalStorage('snooze');

  TimeOfDay selectedTime = const TimeOfDay(hour: 5, minute: 0);

  // Declare a text controller.
  TextEditingController alarmController = TextEditingController(text: '');

  // bool after alarm edited
  bool alarmEdited = false;

  // Function to set local storage using a future to eliminate file exception errors
  Future<bool> setLocalItem(localVariable, value) async {
    await localStorage.setItem(localVariable, value);
    return true;
  }

  // Function to save the alarm time
  saveAlarm(BuildContext context) async {
    if (widget.alarm != null) {
      print('deleting alarm before saving');
      deleteAlarm();
    }

    // Format the alarmController text to AM/PM
    String formattedTime = DateFormat.jm().format(
      DateTime(
        2024,
        1,
        1,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    // Add alarmController to alarmTimes
    widget.alarmTimes.add(formattedTime);

    // Set the alarmTimes in using the setAlarmTimes function in applicationState
    ref.read(applicationState.notifier).setAlarmTimes(widget.alarmTimes);
    // Save to local storage
    setLocalItem('alarmTimes', widget.alarmTimes);
  }

  // If editing alarm, delete 1st, then re-save
  void deleteAlarm() async {
    // Remove the alarm from the list
    widget.alarmTimes.remove(widget.alarm);

    // SAve the alarmTimes to local storage
    setLocalItem('alarmTimes', widget.alarmTimes);

    // Set the alarmTimes in using the setAlarmTimes function in applicationState
    ref.read(applicationState.notifier).setAlarmTimes(widget.alarmTimes);
  }

  void setEditTime() {
    // Get the length of the alarm time, and then split off the last 2 characters and the first characters - 3
    List<String> alarmParts = [
      widget.alarm!.substring(0, widget.alarm!.length - 3),
      widget.alarm!.substring(widget.alarm!.length - 2),
    ];

    // Add a 0 to the hour if it's only 1 digit
    if (alarmParts[0].length == 4) {
      alarmParts[0] = '0${alarmParts[0]}';
    }

    // Add 12 if PM
    if (alarmParts[1] == 'PM') {
      alarmParts[0] =
          "${int.parse(alarmParts[0].split(":")[0]) + 12}:${alarmParts[0].split(":")[1]}";
    }

    // Wait for the widget to load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedTime = TimeOfDay(
          hour: int.parse(alarmParts[0].split(":")[0]),
          minute: int.parse(alarmParts[0].split(":")[1]),
        );
      });
    });
  }

  // Run setEditTime when the widget is loaded
  @override
  void initState() {
    super.initState();
    // Set the selected time to the edited time on load
    if (widget.alarm != null) {
      setEditTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add 0 to minutes if it's only 1 digit
    final minutes = selectedTime.minute.toString().padLeft(2, '0');

    // Check if the alarm is being edited and put that in the text field
    if (widget.alarm != null && alarmEdited == false) {
      alarmController.text = widget.alarm ?? '${selectedTime.hour}:$minutes';
    } else {
      alarmController.text = '${selectedTime.hour}:$minutes';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Add/Edit Alarm',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        leading: BackButton(
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            widget.alarm != null
                ? const Text(
                    'Edit Alarm',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  )
                : Text(
                    'Add an Alarm',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                      hintText: 'Enter the Alarm Time',
                    ),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      // Set the selectedTime to the newTime
                      setState(() {
                        print('After change alarm: $newTime');
                        selectedTime = newTime!;

                        if (widget.alarm != null) {
                          alarmEdited = true;
                        }
                      });
                    },
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
                      // Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Settings(),
                        ),
                      ),
                    },
                    child: Text(
                      'Save Alarm',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
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
