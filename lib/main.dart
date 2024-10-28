import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Padma Marketing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var locationStatus = await Permission.location.request();
    var cameraStatus = await Permission.camera.request();

    if (!locationStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Location permission is required for geolocation.")),
      );
    }

    if (!cameraStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Camera permission is required for webcam access.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Padma Marketing"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse("https://marketing.padmaclinic.net")),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          geolocationEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: true,
            retain: true,
          );
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },
        // onPermissionRequest: (controller, origin, resources) async {
        //   return PermissionResponse(
        //     resources: resources,
        //     action: PermissionResponseAction.GRANT,
        //   );
        // },
      ),
    );
  }
}
