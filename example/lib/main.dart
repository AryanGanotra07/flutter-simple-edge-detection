import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/Application.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simple_edge_detection_example/utils/CustomTheme.dart';
import 'containers/Home.dart';



Application application = Application();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await application.initPlatform();
  runApp(EdgeDetectionApp());
}


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print("Handling a background message: ${message.messageId}");
// }







class EdgeDetectionApp extends StatefulWidget {
  @override
  _EdgeDetectionAppState createState() => _EdgeDetectionAppState();
}

class _EdgeDetectionAppState extends State<EdgeDetectionApp> {

  @override
  void initState(){
    super.initState();
    // createChannel();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InvoiceProvider>(
          create: (_) => InvoiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Invoice Parser',
        theme: CustomTheme.getTheme,
        home: Home(),
      ),
    );
  }
}
