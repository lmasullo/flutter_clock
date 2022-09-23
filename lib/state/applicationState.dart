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

  void setAlarmTimes(List<String> alarmTimes) {
    _alarmTimes = alarmTimes;
    notifyListeners();
  }

  @override
  notifyListeners();
}
