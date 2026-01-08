import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CyberLogApp());
}

/* ================= ROOT APP ================= */

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

/* ================= HOME ================= */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CYBERLOG', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SystemHudScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'OPEN SYSTEM HUD',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= SYSTEM HUD ================= */

class SystemHudScreen extends StatefulWidget {
  const SystemHudScreen({super.key});

  @override
  State<SystemHudScreen> createState() => _SystemHudScreenState();
}

class _SystemHudScreenState extends State<SystemHudScreen> {
  static const MethodChannel _channel =
      MethodChannel('cyberlog/device');

  final Map<String, String> systemInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSystemInfo();
  }

  Future<void> fetchSystemInfo() async {
    try {
      systemInfo['Manufacturer'] =
          (await _channel.invokeMethod('getManufacturer')).toString();

      systemInfo['Brand'] =
          (await _channel.invokeMethod('getBrand')).toString();

      /*systemInfo['Device Code'] =
          (await _channel.invokeMethod('getDeviceCodeName')).toString();*/

      systemInfo['Model'] =
          (await _channel.invokeMethod('getDeviceModel')).toString();

      systemInfo['Android Version'] =
          (await _channel.invokeMethod('getAndroidVersion')).toString();

      systemInfo['SDK Level'] =
          (await _channel.invokeMethod('getSdkLevel')).toString();

      /*systemInfo['Security Patch'] =
          (await _channel.invokeMethod('getSecurityPatch')).toString();

      systemInfo['Build Fingerprint'] =
          (await _channel.invokeMethod('getBuildFingerprint')).toString();*/

      setState(() => isLoading = false);
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Widget hudTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.25),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SYSTEM HUD', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: systemInfo.entries
                    .map((e) => hudTile(e.key, e.value))
                    .toList(),
              ),
            ),
    );
  }
}
