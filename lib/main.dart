import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: AuthService().user)
      ],
      child: MaterialApp(
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
        ],
        routes: {
          '/': (context) => LoginScreen(),
          '/cafeterias': (context) => MyHomePage(),
          '/profile': (context) => Profile(),
          '/meals': (context) => Meals(),
          '/register': (context) => RegisterEmail(),
        },
        theme: ThemeData(
          primarySwatch: Colors.grey,
          bottomAppBarColor: Color.fromRGBO(50, 50, 50, 1),
          accentColor: Color.fromRGBO(50, 50, 50, 1),
          backgroundColor: Color.fromRGBO(230, 230, 230, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
