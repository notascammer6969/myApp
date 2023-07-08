import 'package:flutter/material.dart';
import 'package:youapp_test/screens/authentication.dart';
import 'package:youapp_test/screens/profile.dart';
import 'package:youapp_test/shared/session_management.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionManager = SessionManager();
  await sessionManager.init();

  runApp(
    ChangeNotifierProvider<SessionManager>.value(
      value: sessionManager,
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: (sessionManager.isLoggedIn() && sessionManager.getUsername() != null) ?
        Profile() : const Authentication(),
    );
  }
}
