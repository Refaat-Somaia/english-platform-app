import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionTracker {
  DateTime? _sessionStart;

  void startSession() {
    _sessionStart = DateTime.now();
  }

  Map<String, dynamic> endSession() {
    DateTime end = DateTime.now();
    int durationInMinutes = end.difference(_sessionStart!).inMinutes;

    return {
      'timestamp': _sessionStart!,
      'duration': durationInMinutes,
    };
  }

  Future<void> saveSessionLog(Map<String, dynamic> newSession) async {
    final prefs = await SharedPreferences.getInstance();
    await _checkAndResetWeeklyLogs(prefs);

    List<String> existingLogs = prefs.getStringList('sessionLogs') ?? [];
    List<Map<String, dynamic>> logs = existingLogs.map((logStr) {
      final json = jsonDecode(logStr);
      return {
        'timestamp': DateTime.parse(json['timestamp']),
        'duration': json['duration'],
      };
    }).toList();

    DateTime today = DateTime.now();
    DateTime todayStart = DateTime(today.year, today.month, today.day);

    bool updated = false;
    for (int i = 0; i < logs.length; i++) {
      DateTime logDate = logs[i]['timestamp'];
      DateTime logDayStart = DateTime(logDate.year, logDate.month, logDate.day);

      if (logDayStart == todayStart) {
        logs[i]['duration'] += newSession['duration'];
        updated = true;
        break;
      }
    }

    if (!updated) {
      logs.add({
        'timestamp': newSession['timestamp'],
        'duration': newSession['duration'],
      });
    }

    List<String> updatedLogs = logs.map((log) {
      return jsonEncode({
        'timestamp': log['timestamp'].toIso8601String(),
        'duration': log['duration'],
      });
    }).toList();

    await prefs.setStringList('sessionLogs', updatedLogs);
  }

  Future<List<Map<String, dynamic>>> loadSessionLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedLogs = prefs.getStringList('sessionLogs') ?? [];

    return storedLogs.map((logStr) {
      final json = jsonDecode(logStr);
      return {
        'timestamp': DateTime.parse(json['timestamp']),
        'duration': json['duration'],
      };
    }).toList();
  }

  Future<void> clearAllSessionLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionLogs');
  }

  Future<void> _checkAndResetWeeklyLogs(SharedPreferences prefs) async {
    String? storedWeekStartStr = prefs.getString('weekStart');
    DateTime currentWeekStart = _getStartOfCurrentWeek();

    if (storedWeekStartStr != null) {
      DateTime storedWeekStart = DateTime.parse(storedWeekStartStr);

      if (currentWeekStart.isAfter(storedWeekStart)) {
        await prefs.remove('sessionLogs');
        await prefs.setString('weekStart', currentWeekStart.toIso8601String());
      }
    } else {
      await prefs.setString('weekStart', currentWeekStart.toIso8601String());
    }
  }

  DateTime _getStartOfCurrentWeek() {
    DateTime now = DateTime.now();
    int daysSinceSaturday = now.weekday % 7;
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysSinceSaturday));
  }
}
