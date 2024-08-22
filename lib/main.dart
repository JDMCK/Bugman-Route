import 'package:flutter/material.dart';
import 'package:bugman_route/screens/authLoad.dart';
import 'package:bugman_route/screens/home.dart';
import 'package:bugman_route/screens/pmScreen.dart';
import 'package:bugman_route/helper/sheetsAPI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetsAPI.init();

  runApp(MaterialApp(
      title: 'Bugman Route',
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber.shade600,
          )
          // light theme settings
          ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber.shade600,
          )
          // dark theme settings
          ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => AuthLoad(),
        '/home': (context) => Home(),
        '/pmScreen': (context) => PMScreen(),
      }));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}