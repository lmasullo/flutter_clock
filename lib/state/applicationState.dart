// Dependencies:
import 'package:flutter/material.dart';

class ApplicationState with ChangeNotifier {
  String? _alarmTime = 'off';
  String? get alarmTime => _alarmTime;

  int _snoozeMinutes = 10;
  int get snoozeMinutes => _snoozeMinutes;

  void setAlarmTime(String? alarmTime) {
    _alarmTime = alarmTime;
    notifyListeners();
  }

  void setSnoozeMinutes(int snoozeMinutes) {
    _snoozeMinutes = snoozeMinutes;
    notifyListeners();
  }

  @override
  notifyListeners();
}
