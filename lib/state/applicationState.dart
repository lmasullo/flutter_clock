// ignore_for_file: file_names
// Dependencies:
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationState with ChangeNotifier {
  ApplicationState() {
    init();
  }

  String? _alarmTime = 'off';
  String? get alarmTime => _alarmTime;

  int _snoozeMinutes = 10;
  int get snoozeMinutes => _snoozeMinutes;

  List<String> _alarmTimes = [];
  List<String> get alarmTimes => _alarmTimes;

  // Function to load shared preferences 'time' key and set _alarmTimes
  Future<void> init() async {
    final SharedPreferences alarms = await SharedPreferences.getInstance();
    _alarmTimes = alarms.getStringList('time') ?? [];
    print('Alarms in App State: ${_alarmTimes.toString()}');
    notifyListeners();
  }

  void setAlarmTime(String? alarmTime) {
    _alarmTime = alarmTime;
    notifyListeners();
  }

  void setSnoozeMinutes(int snoozeMinutes) {
    _snoozeMinutes = snoozeMinutes;
    notifyListeners();
  }

  void setAlarmTimes(List<String> newAlarmTimes) async {
    final SharedPreferences alarms = await SharedPreferences.getInstance();
    await alarms.setStringList('time', newAlarmTimes);
    _alarmTimes = alarms.getStringList('time') ?? [];
    notifyListeners();
  }

  @override
  notifyListeners();
}
