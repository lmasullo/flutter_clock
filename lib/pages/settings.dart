// Dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// State
// import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

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

  // Close the stream on dispose
  // @override
  // void dispose() {
  //   print('Dispose used');
  //   alarmStream.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Get the snoozeMinutes from the state
    int snoozeMinutes =
        Provider.of<ApplicationState>(context, listen: false).snoozeMinutes;

    // final db = Localstore.instance;

    // Create a Stream of alarm times from localstore
    // Stream alarmStream = db.collection('alarms').stream;

    // print('alarmStream: ${alarmStream.toString()}');
    // Put the alarm times into a list
    // getAlarms2() async {
    //   List alarmList = [];
    //   alarmStream.listen((event) {
    //     alarmList.add(event);
    //   });
    //   print('alarmList: ${alarmList.toString()}');
    // }

    // getAlarms2();

    // Get the alarms from localstore
    // Future getAlarms() async {
    //   var alarms = await db.collection('alarms').get();
    //   print('Alarms: $alarms');
    //   return alarms;
    // }

    // getAlarms();

    // Function to get the alarms from localstore
    // Object getAlarmTimes() {
    // List alarmTimes = [];
    // subscription =
    //     db.collection('alarms').stream.listen((Map<String, dynamic> data) {
    //   // print('data: ${data.keys}');
    //   // print('data: ${data.values}');
    //   // print(data.);

    //   // Create a list of the alarm times
    //   // alarmTimes = data.values.toList();
    // });

    // // print('data: ${alarmTimes}');

    // return subscription;

    // }

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
            Text('Set Snooze Minutes: $snoozeMinutes'),

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

            // Display the alarm list
            // StreamBuilder(
            //   stream: alarmStream,
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       print('data length: ${snapshot.data.length}');
            //       print('data: ${snapshot.data}');
            //       print('data keys: ${snapshot.data.keys}');
            //       print('data values: ${snapshot.data.values}');
            //       // print('data: ${snapshot.data.values.toList()}');

            //       // Create a list of the alarm times
            //       List alarmTimes = snapshot.data.values.toList();

            //       print('data: ${alarmTimes.length}');

            //       return ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: alarmTimes.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           return ListTile(
            //             title: Text(alarmTimes[index]),
            //             trailing: IconButton(
            //               icon: const Icon(Icons.delete),
            //               onPressed: () {
            //                 // Delete the alarm from localstore
            //                 db
            //                     .collection('alarms')
            //                     .doc(alarmTimes[index])
            //                     .delete();
            //               },
            //             ),
            //           );
            //         },
            //       );
            //     } else {
            //       return const Text('No alarms set');
            //     }
            //   },
            // ),

            // Button to setAlarmTime to now
            ElevatedButton(
              onPressed: () {
                setAlarmTime(
                    context, DateFormat('h:mm').format(DateTime.now()));

                // Create a random string for the alarm id
                String idGenerator() {
                  final now = DateTime.now();
                  return now.microsecondsSinceEpoch.toString();
                }

                // db
                //     .collection('alarms')
                //     .doc(idGenerator())
                //     .set({'time': DateFormat('h:mm').format(DateTime.now())});
              },
              child: const Text('Now'),
            ),
          ],
        ),
      ),
    );
  }
}
