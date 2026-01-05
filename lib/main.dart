import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const CyberPermissionApp());
}

class CyberPermissionApp extends StatelessWidget {
  const CyberPermissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CyberHome(),
    );
  }
}

class CyberHome extends StatefulWidget {
  const CyberHome({super.key});

  @override
  State<CyberHome> createState() => _CyberHomeState();
}

class _CyberHomeState extends State<CyberHome> {
  File? image;
  String internetStatus = "Checking internet...";
  List<FileSystemEntity> storageItems = [];
  bool showStorage = false;

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetStatus = "Internet Connected";
        });
      }
    } catch (_) {
      setState(() {
        internetStatus = "No Internet Connection";
      });
    }
  }

  Future<void> openCamera() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) return;

    await Future.delayed(const Duration(milliseconds: 300));

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final saved = await File(picked.path).copy(
      '${dir.path}/secure_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    setState(() {
      image = saved;
    });
  }

  Future<void> loadStorage() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) return;

    final dir = Directory('/storage/emulated/0');
    final items = dir.listSync();

    setState(() {
      storageItems = items;
      showStorage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        centerTitle: true,
        title: const Text(
          "CYBER PERMISSION APP",
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cyberBox(),
              child: Row(
                children: [
                  const Icon(Icons.public, color: Colors.cyanAccent),
                  const SizedBox(width: 12),
                  Text(
                    internetStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: cyberBox(),
                child: showStorage
                    ? ListView.builder(
                        itemCount: storageItems.length,
                        itemBuilder: (context, index) {
                          final item = storageItems[index];
                          final name = item.path.split('/').last;
                          final isDir =
                              FileSystemEntity.isDirectorySync(item.path);

                          return ListTile(
                            leading: Icon(
                              isDir
                                  ? Icons.folder
                                  : Icons.insert_drive_file,
                              color: Colors.cyanAccent,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: image == null
                            ? const Text(
                                "NO IMAGE CAPTURED",
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  letterSpacing: 1.5,
                                ),
                              )
                            : Image.file(image!),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: openCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text("OPEN CAMERA"),
              style: cyberButton(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: checkInternet,
              icon: const Icon(Icons.refresh),
              label: const Text("CHECK INTERNET"),
              style: cyberButton(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: loadStorage,
              icon: const Icon(Icons.folder),
              label: const Text("OPEN STORAGE"),
              style: cyberButton(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration cyberBox() {
    return BoxDecoration(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.cyanAccent),
    );
  }

  ButtonStyle cyberButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.cyanAccent,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
