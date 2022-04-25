import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ivan_infotech/profile_view/profile_view.dart';
import 'login/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Ivan Infotech",
      home: LoginView(),
    );
  }
}
