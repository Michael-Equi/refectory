import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Firebase Analytics
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
      ],
      routes: {
        '/': (context) => LoginScreen(),
        '/topics': (context) => MyHomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
