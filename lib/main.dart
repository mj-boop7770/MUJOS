import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TunnelScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TunnelScreen extends StatefulWidget {
  const TunnelScreen({Key? key}) : super(key: key);

  @override
  State<TunnelScreen> createState() => _TunnelScreenState();
}

class _TunnelScreenState extends State<TunnelScreen> {
  late V2ray v2ray;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    v2ray = V2ray(
      onStatusChanged: (status) {
        setState(() {
          isConnected = status.state == "CONNECTED";
        });
      },
    );
    v2ray.initialize(
      notificationIconResourceType: "mipmap",
      notificationIconResourceName: "ic_launcher",
    );
  }

  void toggleConnection() async {
    if (isConnected) {
      await v2ray.stopV2Ray();
      return;
    }
    try {
      String configString = await rootBundle.loadString('assets/config.json');
      if (await v2ray.requestPermission()) {
        await v2ray.startV2Ray(
          remark: "Mon Tunnel Perso",
          config: configString,
          blockedApps: null,
          bypassSubnets: null,
          proxyOnly: false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur config : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnected ? "Tunnel Actif" : "Tunnel Déconnecté",
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.red : Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: Text(
                isConnected ? "STOP" : "START",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
