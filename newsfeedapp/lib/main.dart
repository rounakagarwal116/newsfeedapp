import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsfeedapp/authentication/signup.dart';
import 'package:newsfeedapp/repository/api.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewsProvider(),
      child: const MainApp(),
    ),
  );

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFCED3DC),
      ),
      home: const SignUp(),
    );
  }
}
