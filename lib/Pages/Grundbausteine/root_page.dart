import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morea/Pages/Agenda/Agenda_page.dart';
import 'package:morea/Pages/Grundbausteine/blockedByAppVersion_page.dart';
import 'package:morea/Pages/Grundbausteine/blockedByDevToken_page.dart';
import 'package:morea/Pages/Grundbausteine/login_page.dart';
import 'package:morea/Pages/Nachrichten/messages_page.dart';
import 'package:morea/Pages/Profil/profil.dart';
import 'package:morea/Pages/Teleblitz/home_page.dart';
import 'package:morea/Widgets/animated/MoreaLoading.dart';
import 'package:morea/morea_strings.dart' as prefix0;
import 'package:morea/services/auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:morea/services/morea_firestore.dart';
import 'package:morea/services/utilities/blockedUserChecker.dart';
import 'package:showcaseview/showcaseview.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.firestore});

  final BaseAuth auth;
  final Firestore firestore;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  loading,
  notSignedIn,
  blockedByAppVersion,
  blockedByDevToken,
  homePage,
  messagePage,
  agendaPage,
  profilePage
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  Auth auth = Auth();
  AuthStatus authStatus = AuthStatus.loading;
  MoreaFirebase moreaFire;
  Map<String, Function> navigationMap;
  MoreaLoading moreaLoading;

  @override
  void initState() {
    super.initState();
    moreaLoading = MoreaLoading(this);
    initializeDateFormatting();
    authStatusInit();

    //für Navigation in den verschiedenen Pages
    navigationMap = {
      prefix0.signedIn: this.signedIn,
      prefix0.signedOut: this.signedOut,
      prefix0.toHomePage: this.homePage,
      prefix0.toMessagePage: this.messagePage,
      prefix0.toAgendaPage: this.agendaPage,
      prefix0.toProfilePage: this.profilePage,
    };
  }

  @override
  void dispose() {
    moreaLoading.dispose();
    super.dispose();
  }

  Future<void> initMoreaFire() async {
    this.moreaFire = new MoreaFirebase(widget.firestore);
    await this.moreaFire.getData(await auth.currentUser());
    await this.moreaFire.initTeleblitz();
    authStatus = AuthStatus.homePage;
    setState(() {});
    return true;
  }

  Future authStatusInit() async {
    authStatus = await check4BlockedAuthStatus(
        await auth.currentUser(), widget.firestore);
    if (authStatus == AuthStatus.loading) {
      initMoreaFire();
    }
    setState(() {});
  }

  //initializes MoreaFirebase and downloads User Data with getData()

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: auth,
          onSignedIn: this.signedIn,
        );
        break;

      case AuthStatus.homePage:
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) => HomePage(
              auth: auth,
              firestore: widget.firestore,
              navigationMap: navigationMap,
              moreafire: moreaFire,
            ),
          ),
        );
        break;
      case AuthStatus.blockedByAppVersion:
        return new BlockedByAppVersion();
        break;

      case AuthStatus.blockedByDevToken:
        return new BlockedByDevToken();
        break;

      case AuthStatus.messagePage:
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) => MessagesPage(
              auth: auth,
              moreaFire: moreaFire,
              navigationMap: this.navigationMap,
              firestore: widget.firestore,
            ),
          ),
        );
        break;

      case AuthStatus.agendaPage:
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) => AgendaState(
              auth: auth,
              navigationMap: navigationMap,
              moreaFire: moreaFire,
              firestore: widget.firestore,
            ),
          ),
        );
        break;

      case AuthStatus.profilePage:
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) => Profile(
              auth: auth,
              moreaFire: moreaFire,
              navigationMap: navigationMap,
              firestore: widget.firestore,
            ),
          ),
        );
        break;
      case AuthStatus.loading:
        return Scaffold(
            appBar: AppBar(
              title: Text('Teleblitz'),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: moreaLoading.loading(),
                ),
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                          Text(" Logout",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey))
                        ],
                      ),
                      onPressed: () => signedOut(),
                    ))
              ],
            ));
        break;
      default:
        return Container(
          child: moreaLoading.loading(),
          color: Colors.white,
        );
    }
  }

  //Functions for the Navigation
  //Switches authStatus and rebuilds RootPage

  void signedIn() async {
    await initMoreaFire();
    setState(() {
      authStatus = AuthStatus.homePage;
    });
  }

  void homePage({dispose}) {
    if (!(authStatus == AuthStatus.homePage)) {
      if (dispose != null) {
        dispose();
      }
      try {
        setState(() {
          authStatus = AuthStatus.homePage;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void messagePage({dispose}) {
    if (!(authStatus == AuthStatus.messagePage)) {
      if (dispose != null) {
        dispose();
      }
      setState(() {
        authStatus = AuthStatus.messagePage;
      });
    }
  }

  void agendaPage({dispose}) {
    if (!(authStatus == AuthStatus.agendaPage)) {
      setState(() {
        authStatus = AuthStatus.agendaPage;
      });
    }
  }

  void profilePage({dispose}) {
    if (!(authStatus == AuthStatus.profilePage)) {
      setState(() {
        authStatus = AuthStatus.profilePage;
      });
    }
  }

  void signedOut() {
    moreaFire = null;
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
}
