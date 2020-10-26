import 'dart:async';
//import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:morea/Pages/Grundbausteine/root_page.dart';
import 'package:morea/Widgets/standart/restartWidget.dart';
import 'package:morea/services/auth.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:morea/services/utilities/js/gun.dart';
import 'package:morea/services/utilities/notification.dart';
import 'morealayout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Gundb();
  notificationGetPermission();
  runApp(RestartWidget(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firestore = Firestore();
  //final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Morea',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: MaterialColor(
            MoreaColors.appBarInt, MoreaColors.violettMaterialColor),
        fontFamily: 'Raleway',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [MoreaColors.orange, MoreaColors.bottomAppBar],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: RootPage(
              auth: Auth(),
              firestore: firestore,
            )),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('de', 'CH'),
      ],
      /*navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],*/
    );
  }
}
