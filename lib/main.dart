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
  bool isLoading = false;
  String statusMessage = "Tunnel Déconnecté";
  final List<String> logs = [];

  @override
  void initState() {
    super.initState();
    _initializeV2Ray();
  }

  void _initializeV2Ray() {
    v2ray = V2ray(
      onStatusChanged: (status) {
        setState(() {
          isConnected = status.state == "CONNECTED";
          statusMessage = isConnected ? "Tunnel Actif ✓" : "Tunnel Déconnecté";
          _addLog("État changé: ${status.state}");
        });
      },
    );
    v2ray.initialize(
      notificationIconResourceType: "mipmap",
      notificationIconResourceName: "ic_launcher",
    );
    _addLog("V2Ray initialisé");
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().split('T')[1];
    setState(() {
      logs.add("[$timestamp] $message");
      if (logs.length > 50) {
        logs.removeAt(0);
      }
    });
  }

  Future<void> toggleConnection() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (isConnected) {
        _addLog("Arrêt du tunnel...");
        await v2ray.stopV2Ray();
        setState(() {
          isConnected = false;
          statusMessage = "Tunnel arrêté";
        });
        _addLog("Tunnel arrêté avec succès");
      } else {
        _addLog("Chargement de la config...");
        String configString = await rootBundle.loadString('assets/config.json');
        _addLog("Config chargée, demande de permission...");

        if (await v2ray.requestPermission()) {
          _addLog("Permission accordée, démarrage du tunnel...");
          await v2ray.startV2Ray(
            remark: "Octopus - Allemagne (Movitel)",
            config: configString,
            blockedApps: null,
            bypassSubnets: null,
            proxyOnly: false,
          );
          _addLog("Tunnel démarré avec succès");
        } else {
          _addLog("⚠️ Permission refusée");
          if (mounted) {
            _showErrorSnackBar("Permission VPN refusée par le système");
          }
        }
      }
    } on PlatformException catch (e) {
      _addLog("❌ Erreur plateforme: ${e.message}");
      if (mounted) {
        _showErrorSnackBar("Erreur: ${e.message}");
      }
    } catch (e) {
      _addLog("❌ Erreur: $e");
      if (mounted) {
        _showErrorSnackBar("Erreur config: $e");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearLogs() {
    setState(() {
      logs.clear();
    });
    _addLog("Logs effacés");
  }

  @override
  void dispose() {
    // Nettoyage propre du V2Ray
    v2ray.stopV2Ray().catchError((e) {
      debugPrint("Erreur lors de l'arrêt du V2Ray: $e");
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("MUJOS - Octopus Core"),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section Status
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // État du tunnel
                  Text(
                    statusMessage,
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Indicateur visuel
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      border: Border.all(
                        color: isConnected ? Colors.green : Colors.red,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isConnected ? Icons.shield_locked : Icons.shield,
                        size: 50,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Bouton principal
                  ElevatedButton(
                    onPressed: isLoading ? null : toggleConnection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isConnected ? Colors.red : Colors.blueAccent,
                      disabledBackgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            isConnected ? "ARRÊTER" : "DÉMARRER",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isLoading ? "En cours..." : "",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section Logs
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "📋 Logs",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: _clearLogs,
                        tooltip: "Effacer les logs",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          logs[logs.length - 1 - index],
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
