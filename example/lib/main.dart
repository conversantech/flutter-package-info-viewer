import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_package_info_viewer/flutter_package_info_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Info Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  BuildInfo? _realBuildInfo;

  @override
  void initState() {
    super.initState();
    _loadBuildInfo();
  }

  Future<void> _loadBuildInfo() async {
    try {
      final String response =
          await rootBundle.loadString('assets/build-info.json');
      final data = await json.decode(response);
      setState(() {
        _realBuildInfo = BuildInfo.fromJson(data);
      });
    } catch (e) {
      debugPrint('No build-info.json found, using mock data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simulated pubspec data
    final mockPubspec = {
      'dependencies': {
        'flutter': 'sdk',
        'package_info_plus': '^8.0.0',
        'device_info_plus': '^10.1.0',
        'share_plus': '^12.0.2',
      },
      'dev_dependencies': {
        'flutter_test': 'sdk',
        'flutter_lints': '^4.0.0',
      }
    };

    // Use real build info if loaded, otherwise fallback to mock
    final displayBuildInfo = _realBuildInfo ??
        BuildInfo(
          commitHash: 'a1b2c3d4e5f6',
          branch: 'main',
          author: 'Harshit Ranpara',
          buildDate: DateTime.now().toString().split('.')[0],
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Package Info Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap the debug button to see app info',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            DebugButton(
              floating: false,
              onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PackageInfoViewer(
                    pubspec: mockPubspec,
                    buildInfo: displayBuildInfo,
                    environmentName: 'STAGING',
                    configValues: const {
                      'API_URL': 'https://api.staging.com',
                      'STRIPE_KEY': 'sk_test_51Mz...',
                    },
                    primaryColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: DebugButton(
        onPress: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageInfoViewer(
              pubspec: mockPubspec,
              buildInfo: displayBuildInfo,
              environmentName: 'STAGING',
              configValues: const {
                'API_URL': 'https://api.staging.com',
                'STRIPE_KEY': 'sk_test_51Mz...',
              },
            ),
          ),
        ),
      ),
    );
  }
}
