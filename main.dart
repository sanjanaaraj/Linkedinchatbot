import 'package:flutter/material.dart';
import 'chatbot_login.dart';
import 'package:flutter_application_1/fyp_home.dart';
import 'chat_bot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return //ChangeNotifierProvider(
        //create: (context) => categoryprovider(),child:
        MaterialApp(
      home: const YourLoginPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Color.fromARGB(255, 53, 126, 109)),
       
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
