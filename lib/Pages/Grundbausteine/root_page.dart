import 'package:flutter/material.dart';
import 'package:morea/Pages/Grundbausteine/login_page.dart';
import 'package:morea/Pages/Teleblitz/home_page.dart';
import 'package:morea/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RootPage extends StatefulWidget {
  RootPage() {
    this.auth = Auth();
  }

  BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: signedIn,
        );

      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSigedOut: signedOut,
        );
    }
  }
}
