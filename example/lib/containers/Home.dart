 import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/Application.dart';
import 'package:simple_edge_detection_example/constants/contant.dart';
import 'package:simple_edge_detection_example/containers/Dashboard.dart';
import 'package:simple_edge_detection_example/containers/ImageModeContainer.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';
import 'Invoices.dart';
import 'ResultView.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [Dashboard(), Invoices(), ImageModeContainer()];
  final List<String> _titles = ["Dashboard", "Invoices", "Scan Invoice"];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Get any messages which caused the application to open from
    // a terminated state.
    listenToNotifications();
    Provider.of<InvoiceProvider>(context, listen: false).fetchFromLocal();

  }


  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future onSelectNotification(String payload) async {

    //convert payload json to notification model object
    Map notificationModelMap = jsonDecode(payload);
    print(notificationModelMap);

  }


  final Application _application = Application();
  void listenToNotifications() async {

    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _application.showNotification(message);
      _onMessageReceived(message);
    });

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();


    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      print(notificationAppLaunchDetails.payload);
    }



    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null ) {
      print("Received initial notification message...");
      print(initialMessage);
      _onMessageReceived(initialMessage);
    }


    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage?.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //       arguments: ChatArguments(initialMessage));
    // }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message);
      // if (message.data['type'] == 'chat') {
      //   Navigator.pushNamed(context, '/chat',
      //       arguments: ChatArguments(message));
      // }

      _onMessageReceived(message);

    });


  }


  void _onMessageReceived(RemoteMessage message) {
    if (message.data.containsKey("invoiceName")){
      String invoiceName = message.data["invoiceName"];
      MyInvoice _invoice = InvoiceProvider.getInvoiceByName(invoiceName);
      if (_invoice!=null)
        Helpers.navigateTo(context, ResultView(_invoice));
      else Helpers.showToast("Error fetching invoice details..");
    }
  }




  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 2,
     child: Scaffold(
       bottomNavigationBar: BottomNavigationBar(
         currentIndex: _currentIndex, //
         onTap: onTabTapped,// this will be set when a new tab is tapped
         items: [
           BottomNavigationBarItem(
             icon: new Icon(Icons.home_rounded),
             label: "Dashboard",
           ),
           BottomNavigationBarItem(icon: new Icon(Icons.file_copy_rounded), label : "Scanned Invoices"),
           BottomNavigationBarItem(
             icon: new Icon(Icons.scanner),
             label: "Scan"
           ),

         ],
       ),
       appBar: AppBar(
         title: Text(_titles[_currentIndex]),
           actions: [
             PopupMenuButton<String>(
               onSelected: choiceAction,
               itemBuilder: (BuildContext context){
                 return Constants.choices.map((String choice){
                   return PopupMenuItem<String>(
                     value: choice,
                     child: Text(choice),);
                 })
                     .toList();
               }
               ,),
           ],
         // bottom: TabBar(
         //   tabs: [
         //     Tab(
         //       icon: Icon(Icons.file_copy_sharp),
         //     ),
         //     Tab(
         //       icon: Icon(Icons.scanner),
         //     )
         //   ],
         // ),
       ),
       body: _children[_currentIndex]
     ),
   );
  }

  void choiceAction(String choice){
    if(choice == Constants.profile){
      Helpers.showToast("To be implemented!");
    }
    else if(choice == Constants.scanned){
      Helpers.navigateTo(context, Invoices(withAppBar: true,title: "Invoices",));
    }

    else if(choice == Constants.export){
      Helpers.navigateTo(context, Invoices(withAppBar: true,title: "Export",export: true,));
    }
    else {
      Helpers.showToast("To be implemented!");
    }
  }
}