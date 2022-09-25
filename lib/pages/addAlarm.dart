// ignore_for_file: file_names
// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key, this.alarm});

  final String? alarm;

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  // Declare the selectedTime variable
  TimeOfDay selectedTime = const TimeOfDay(hour: 5, minute: 0);

  // Declare a text controller.
  TextEditingController alarmController = TextEditingController(text: '');

  // bool after alarm edited
  bool alarmEdited = false;

  // Function to save the alarm time
  saveAlarm(BuildContext context) async {
    if (widget.alarm != null) {
      deleteAlarm();
    }
    // Get the alarmTimes from applicationState
    List<String> alarmTimes =
        Provider.of<ApplicationState>(context, listen: false).alarmTimes;

    // Get the setAlarmTimes from ApplicationState
    var setAlarmTimes =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTimes;

    // Format the alarmController text to AM/PM
    String formattedTime = DateFormat.jm().format(
      DateTime(
        2021,
        1,
        1,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    // Add alarmController to alarmTimes
    alarmTimes.add(formattedTime);

    // Set the alarmTimes in using the setAlarmTimes function in applicationState
    setAlarmTimes(alarmTimes);
  }

  // If editing alarm, delete 1st, then re-save
  void deleteAlarm() async {
    List<String> alarmTimes =
        Provider.of<ApplicationState>(context, listen: false).alarmTimes;

    // Get the setAlarmTimes from ApplicationState
    var setAlarmTimes =
        Provider.of<ApplicationState>(context, listen: false).setAlarmTimes;

    // Remove the alarm from the list
    alarmTimes.remove(widget.alarm);
    setAlarmTimes(alarmTimes);
  }

  void setEditTime() {
    List<String> alarmParts = widget.alarm!.split(" ");

    // Add a 0 to the hour if it's only 1 digit
    if (alarmParts[0].length == 4) {
      alarmParts[0] = '0${alarmParts[0]}';
    }

    // Add 12 if PM
    if (alarmParts[1] == 'PM') {
      alarmParts[0] =
          "${int.parse(alarmParts[0].split(":")[0]) + 12}:${alarmParts[0].split(":")[1]}";
    }

    setState(() {
      selectedTime = TimeOfDay(
        hour: int.parse(alarmParts[0].split(":")[0]),
        minute: int.parse(alarmParts[0].split(":")[1]),
      );
    });
  }

  // Run setEditTime when the widget is loaded
  @override
  void initState() {
    // Set the selected time to the edited time on load
    if (widget.alarm != null) {
      setEditTime();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Add 0 to minutes if it's only 1 digit
    final minutes = selectedTime.minute.toString().padLeft(2, '0');

    // Check if the alarm is being edited and put that in the text field
    if (alarmEdited == false) {
      alarmController.text = widget.alarm ?? '${selectedTime.hour}:$minutes';
    } else {
      alarmController.text = '${selectedTime.hour}:$minutes';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Alarm')),
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
                : const Text(
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
                      hintText: 'Enter the Alarm Time',
                    ),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      // Set the selectedTime to the newTime
                      setState(() {
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
                      Navigator.pop(context),
                    },
                    child: const Text('Save Alarm'),
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
