 import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/Invoices.dart';
import 'package:simple_edge_detection_example/scan.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [Invoices(), Scan()];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
             icon: new Icon(Icons.file_copy_sharp),
             label: "Home",
           ),
           BottomNavigationBarItem(
             icon: new Icon(Icons.scanner),
             label: "Scan"
           ),
         ],
       ),
       appBar: AppBar(
         title: Text("Home"),
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
}