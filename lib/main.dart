import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const CyberLogApp());
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberLog',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050B14),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
        ),
        useMaterial3: true,
      ),
      home: const SecurityDashboard(),
    );
  }
}

class SecurityDashboard extends StatefulWidget {
  const SecurityDashboard({super.key});

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {
  bool screenLockEnabled = true;
  bool rootedOrEmulator = false;

  List<String> dangerousPermissions = [];
  List<String> securityLogs = [];

  int deviceScore = 30;
  int permissionScore = 40;
  int awarenessScore = 20;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
    ].request();

    List<String> granted = [];

    statuses.forEach((permission, status) {
      if (status.isGranted) {
        final name = permission.toString().split('.').last;
        granted.add(name);
        securityLogs.add("$name permission granted");
      }
    });

    setState(() {
      dangerousPermissions = granted;
      permissionScore = 40 - (granted.length * 8);
      if (permissionScore < 0) permissionScore = 0;
    });
  }

  int get totalScore => deviceScore + permissionScore + awarenessScore;

  Color scoreColor() {
    if (totalScore >= 80) return Colors.greenAccent;
    if (totalScore >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  List<String> recommendations() {
    List<String> tips = [];

    if (!screenLockEnabled) {
      tips.add("Enable screen lock to protect your device");
    }
    if (dangerousPermissions.isNotEmpty) {
      tips.add("Review granted dangerous permissions");
    }
    if (rootedOrEmulator) {
      tips.add("Avoid using rooted or emulated devices");
    }
    if (tips.isEmpty) {
      tips.add("Your security posture is strong");
    }

    return tips;
  }

  Widget cyberCard(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.15),
            Colors.purpleAccent.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.cyanAccent, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget scoreCard(String title, int score, int max) {
    return cyberCard(
      ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        subtitle: LinearProgressIndicator(
          value: score / max,
          color: Colors.cyanAccent,
          backgroundColor: Colors.white12,
        ),
        trailing: Text(
          "$score / $max",
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget owaspStatusTile(String title, bool isSecure) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Icon(
        isSecure ? Icons.check_circle : Icons.warning_amber_rounded,
        color: isSecure ? Colors.greenAccent : Colors.orangeAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SECURITY",
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          cyberCard(
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "SYSTEM SECURITY INDEX",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.cyanAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: CircularProgressIndicator(
                          value: totalScore / 100,
                          strokeWidth: 10,
                          color: scoreColor(),
                          backgroundColor: Colors.white12,
                        ),
                      ),
                      Text(
                        "$totalScore",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: scoreColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    totalScore >= 80
                        ? "STATUS: SECURE"
                        : "STATUS: VULNERABLE",
                    style: const TextStyle(
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "MODULE ANALYSIS",
            style: TextStyle(
              fontSize: 18,
              color: Colors.purpleAccent,
              letterSpacing: 1.3,
            ),
          ),

          const SizedBox(height: 10),
          scoreCard("Device Protection", deviceScore, 40),
          const SizedBox(height: 10),
          scoreCard("Permissions", permissionScore, 40),
          const SizedBox(height: 10),
          scoreCard("Security Awareness", awarenessScore, 20),

          const SizedBox(height: 20),

          cyberCard(
            ExpansionTile(
              leading: const Icon(Icons.lightbulb, color: Colors.cyanAccent),
              title: const Text("AI SECURITY RECOMMENDATIONS"),
              children: recommendations()
                  .map(
                    (tip) => ListTile(
                      leading: const Icon(Icons.arrow_right,
                          color: Colors.purpleAccent),
                      title: Text(tip),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          cyberCard(
            ExpansionTile(
              leading: const Icon(Icons.history, color: Colors.cyanAccent),
              title: const Text("SECURITY TIMELINE"),
              children: securityLogs.isEmpty
                  ? const [
                      ListTile(title: Text("No security events logged"))
                    ]
                  : securityLogs
                      .map(
                        (log) => ListTile(
                          leading: const Icon(Icons.event,
                              color: Colors.purpleAccent),
                          title: Text(log),
                        ),
                      )
                      .toList(),
            ),
          ),

          const SizedBox(height: 12),

          cyberCard(
            ExpansionTile(
              leading: const Icon(Icons.security, color: Colors.cyanAccent),
              title: const Text("OWASP THREAT MATRIX"),
              children: [
                owaspStatusTile(
                  "M3 – Insecure Authentication",
                  screenLockEnabled,
                ),
                owaspStatusTile(
                  "M5 – Insecure Communication",
                  !dangerousPermissions.contains("location"),
                ),
                owaspStatusTile(
                  "M9 – Insecure Data Storage",
                  dangerousPermissions.isEmpty,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text("OPEN APP SETTINGS"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(letterSpacing: 1.2),
            ),
            onPressed: openAppSettings,
          ),
        ],
      ),
    );
  }
}
