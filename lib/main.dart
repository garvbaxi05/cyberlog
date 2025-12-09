import 'package:flutter/material.dart';

class Log {
  final String action;
  final DateTime timestamp;
  final String status;

  Log({
    required this.action,
    required this.timestamp,
    required this.status,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogScreen(),
    );
  }
}

class LogScreen extends StatelessWidget {
  LogScreen({super.key});

  final List<Log> logs = [
    Log(action: "Action 1", timestamp: DateTime.now(), status: "Done"),
    Log(action: "Action 2", timestamp: DateTime.now(), status: "Pending"),
    Log(action: "Action 3", timestamp: DateTime.now(), status: "Failed"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logs")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: logs.map((log) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${log.action} - ${log.timestamp} - ${log.status}",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
