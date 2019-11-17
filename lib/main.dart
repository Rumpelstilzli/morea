// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morea/Pages/Grundbausteine/root_page.dart';
import 'package:morea/services/auth.dart';
import 'package:morea/Pages/Teleblitz/home_page.dart';
import 'Pages/Grundbausteine/login_page.dart';
import 'morealayout.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'Pfadi Morea',
    options: const FirebaseOptions(
      googleAppID: '1:1015173140187:android:4993eb8c17b8d3ae',
      gcmSenderID: '1015173140187',
      apiKey: 'AIzaSyCJSh9nTShvpyFecH9vHfrlo9g9YyKLzKc',
      projectID: 'pfadi-morea-fa354',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(
    MaterialApp(
        title: 'Morea App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Raleway',
            primarySwatch: MaterialColor(
                MoreaColors.appBarInt, MoreaColors.violettMaterialColor)),
        home: MyApp(firestore: firestore)),
  );
}

class MyApp extends StatelessWidget {
  MyApp({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: MaterialColor(
            MoreaColors.appBarInt, MoreaColors.violettMaterialColor),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
      },
    );
  }
}
