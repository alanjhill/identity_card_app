import 'package:flutter/material.dart';
import 'package:identity_card_app/pages/identity_card_page.dart';
import 'package:identity_card_app/utils/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: IdentityCardPage(),
    );
  }
}
