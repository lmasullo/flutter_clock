// ignore_for_file: file_names
// Dependencies:
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ApplicationState extends StateNotifier<Map> {
  ApplicationState() : super({});

  // Initialize the local storage
  final LocalStorage localStorage = LocalStorage('snooze');

  // Function to set local storage using a future to eliminate file exception errors
  Future<bool> setLocalItem(localVariable, value) async {
    await localStorage.setItem(localVariable, value);
    return true;
  }

  // Variables
  String? alarmTime = 'Off';
  int? snoozeMinutes = 10;
  String? weatherCity;
  List<String> alarmTimes = [];

  // Function to load shared preferences 'time' key and set _alarmTimes
  // Future<void> init() async {
  // final SharedPreferences alarms = await SharedPreferences.getInstance();
  // _alarmTimes = alarms.getStringList('time') ?? [];
  // _weatherCity = alarms.getString('weatherCity') ?? 'Lampasas';

  // state = {
  //   'alarmTime': _alarmTime,
  //   'snoozeMinutes': _snoozeMinutes,
  //   'alarmTimes': _alarmTimes,
  //   'weatherCity': _weatherCity,
  // };

  // If there are no alarms set, set the default alarm time
  // notifyListeners();
  // }

  void setAlarmTime(String? _alarmTime) async {
    await setLocalItem('alarmTime', _alarmTime!);
    alarmTime = _alarmTime;
    state = {
      'alarmTime': alarmTime,
    };
  }

  setCityName(String? city) async {
    await setLocalItem('weatherCity', city!);
    weatherCity = city;

    print('Setting weather city to $city in applicationState');

    state = {
      'weatherCity': city,
    };
  }

  void setSnoozeMinutes(int _snoozeMinutes) async {
    // print('Setting snooze minutes to $_snoozeMinutes');
    await setLocalItem('snoozeMinutes', _snoozeMinutes);
    snoozeMinutes = _snoozeMinutes;
    state = {
      'snoozeMinutes': snoozeMinutes,
    };
  }

  void setAlarmTimes(List<dynamic> newAlarmTimes) async {
    await setLocalItem('alarmTimes', newAlarmTimes);
    state = {
      'alarmTimes': newAlarmTimes,
    };
    // print('Setting alarm times to $newAlarmTimes');
  }
}

final applicationState = StateNotifierProvider<ApplicationState, Map>((ref) {
  return ApplicationState();
});
