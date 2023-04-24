import 'package:flutter/material.dart';
import 'TopNavigationBar.dart';
import 'SideNavigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ashesi Social Network',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Side Navigation Bar'),
        // ),
        // body: TopNavBar(),
        body: SideNavigationBar(),
      ),
    );
  }
}
