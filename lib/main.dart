import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            const DashboardBox(title: "Daily Log", color: Color(0xFFFFF3B0)),
            DashboardBox(
              title: "Cyber Tips",
              color: const Color(0xFFB0E57C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CyberTipScreen(),
                  ),
                );
              },
            ),
            const DashboardBox(title: "Device Security", color: Color(0xFFA0E7E5)),
            const DashboardBox(title: "Notes", color: Color(0xFFFFC4C4)),
          ],
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const DashboardBox({
    required this.title,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/* ---------------- CYBER TIP SCREEN ---------------- */

class CyberTipScreen extends StatefulWidget {
  const CyberTipScreen({super.key});

  @override
  State<CyberTipScreen> createState() => _CyberTipScreenState();
}

class _CyberTipScreenState extends State<CyberTipScreen> {
  late Future<String> tip;

  @override
  void initState() {
    super.initState();
    tip = fetchTip();
  }

  Future<String> fetchTip() async {
    final response =
        await http.get(Uri.parse("https://api.adviceslip.com/advice"));
    final data = jsonDecode(response.body);
    return data["slip"]["advice"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cyber Tip"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<String>(
            future: tip,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text("Failed to load tip");
              }

              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.security,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        snapshot.data!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tip = fetchTip();
                          });
                        },
                        child: const Text("New Tip"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
