import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    LogService.addLog("CRASH: $error");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1F),
        primaryColor: Colors.cyanAccent,
      ),
      home: const LoginPage(),
    );
  }
}

/* ================= AUTH ================= */

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  static Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}

/* ================= LOG SERVICE ================= */

class LogService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addLog(String text) async {
    final time = DateTime.now().toString().substring(11, 19);
    final log = "[$time] $text";

    final user = AuthService.currentUser;

    if (user != null) {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("device_logs")
          .add({
        "text": log,
        "time": Timestamp.now(),
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final logs = prefs.getStringList("local_device_logs") ?? [];
      logs.insert(0, log);
      await prefs.setStringList("local_device_logs", logs);
    }
  }

  static Future<List<String>> getLocalLogs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("local_device_logs") ?? [];
  }

  static Future<void> deleteLocalLog(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList("local_device_logs") ?? [];
    logs.removeAt(index);
    await prefs.setStringList("local_device_logs", logs);
  }
}

/* ================= LOGIN PAGE ================= */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String error = "";

  Future<void> _login() async {
    try {
      await AuthService.signIn(email.text, password.text);
      _goHome();
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  Future<void> _signup() async {
    try {
      await AuthService.signUp(email.text, password.text);
      _goHome();
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _skip() => _goHome();

  InputDecoration cyberField(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.cyanAccent),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pinkAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CYBERLOG",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 30),
              TextField(controller: email, decoration: cyberField("Email")),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                decoration: cyberField("Password"),
              ),
              const SizedBox(height: 12),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: cyberButton(),
                onPressed: _login,
                child: const Text("LOGIN"),
              ),
              ElevatedButton(
                style: cyberButton(),
                onPressed: _signup,
                child: const Text("SIGN UP"),
              ),
              TextButton(
                onPressed: _skip,
                child: const Text(
                  "CONTINUE WITHOUT LOGIN",
                  style: TextStyle(color: Colors.cyanAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= HOME PAGE ================= */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batterySub;
  StreamSubscription<List<ConnectivityResult>>? _netSub;

  @override
  void initState() {
    super.initState();

    LogService.addLog("App Launched");

    _battery.batteryState.then((state) {
      LogService.addLog("Battery State: $state");
    });

    _batterySub = _battery.onBatteryStateChanged.listen((state) {
      LogService.addLog("Battery Changed: $state");
    });

    _netSub = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> r) {
      LogService.addLog("Network: $r");
    });

    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;

    LogService.addLog("Device: ${android.model}");
    LogService.addLog("Brand: ${android.brand}");
    LogService.addLog("Android: ${android.version.release}");
    LogService.addLog("Hardware: ${android.hardware}");
  }

  @override
  void dispose() {
    _batterySub?.cancel();
    _netSub?.cancel();
    super.dispose();
  }

  void _logoutOrLogin() async {
    if (AuthService.currentUser != null) {
      await AuthService.signOut();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "CYBERLOG TERMINAL",
          style: TextStyle(color: Colors.cyanAccent),
        ),
        actions: [
          IconButton(
            icon: Icon(
              user != null ? Icons.logout : Icons.login,
              color: Colors.pinkAccent,
            ),
            onPressed: _logoutOrLogin,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            user != null
                ? "STATUS: CLOUD MODE"
                : "STATUS: LOCAL MODE",
            style: const TextStyle(
              color: Colors.greenAccent,
              letterSpacing: 2,
            ),
          ),
          const Divider(color: Colors.cyanAccent),

          Expanded(
            child: user != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .collection("device_logs")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          return cyberTile(
                            docs[i]["text"],
                            () => docs[i].reference.delete(),
                          );
                        },
                      );
                    },
                  )
                : FutureBuilder<List<String>>(
                    future: LogService.getLocalLogs(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final logs = snapshot.data!;

                      return ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, i) {
                          return cyberTile(
                            logs[i],
                            () async {
                              await LogService.deleteLocalLog(i);
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                  ),
      )],
      ),
    );
  }
}

/* ================= UI HELPERS ================= */

ButtonStyle cyberButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.cyanAccent,
    side: const BorderSide(color: Colors.cyanAccent),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

Widget cyberTile(String text, VoidCallback onDelete) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.cyanAccent),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.pinkAccent),
          onPressed: onDelete,
        )
      ],
    ),
  );
}
