import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
      ],
      child: const CyberLogApp(),
    ),
  );
}

class SettingsProvider extends ChangeNotifier {
  bool darkMode = false;

  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }
}

class UserLog {
  final String action;
  final DateTime time;

  UserLog(this.action, this.time);
}

class LogProvider extends ChangeNotifier {
  final List<UserLog> logs = [];

  void addLog(String action) {
    logs.add(UserLog(action, DateTime.now()));
    notifyListeners();
  }
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberLog',
      theme: settings.darkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final logs = context.watch<LogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CyberLog"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                subtitle: const Text("Reduce eye strain"),
                value: settings.darkMode,
                onChanged: (value) {
                  settings.toggleDarkMode(value);
                  logs.addLog(
                    value ? "Dark mode enabled" : "Dark mode disabled",
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                logs.addLog("User added a cyber note");
              },
              icon: const Icon(Icons.add),
              label: const Text("Add User Log"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: logs.logs.isEmpty
                  ? const Center(
                      child: Text(
                        "No activity recorded yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.logs.length,
                      itemBuilder: (context, index) {
                        final log = logs.logs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(log.action),
                            subtitle: Text(
                              "${log.time.hour.toString().padLeft(2, '0')}:${log.time.minute.toString().padLeft(2, '0')} • "
                              "${log.time.day}/${log.time.month}/${log.time.year}",
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
