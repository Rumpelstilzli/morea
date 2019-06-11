import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:morea/services/url_launcher.dart';
import 'dart:convert';
import 'auth.dart';
import 'morea_firestore.dart';
import 'package:flutter_html/flutter_html.dart';

abstract class BaseTeleblitz {
  Widget anzeigen(String _stufe);
}

class Teleblitz implements BaseTeleblitz {
  MoreaFirebase moreafire = new MoreaFirebase();
  bool block = false;

  String _formatDate(String date) {
    if (date != '') {
      String rawDate = date.split('T')[0];
      List<String> dates = rawDate.split('-');
      String formatedDate = dates[2] + '.' + dates[1] + '.' + dates[0];
      return formatedDate;
    } else {
      return '';
    }
  }

  Future<Info> getInfos(String filter) async {
    var jsonData;
    var data;
    var info = new Info();
    String stufe = filter;

    if (stufe != '@') {
      if (await moreafire.refreshteleblitz(stufe) == true) {
        data = await http.get(
            "https://api.webflow.com/collections/5be4a9a6dbcc0a24d7cb0ee9/items?api_version=1.0.0&access_token=d9097840d357b02bd934ba7d9c52c595e6940273e940816a35062fe99e69a2de");
        jsonData = json.decode(data.body);
        Map<String, dynamic> telblitz;

        for (var u in jsonData["items"]) {
          if (u["name"] == stufe) {
            info.setTitel(u["name"]);
            info.setDatum(u["datum"]);
            info.setAntreten(u["antreten"]);
            info.setAntretenMaps(u['google-map']);
            info.setAbtreten(u["abtreten"]);
            info.setAbtretenMaps(u['map-abtreten']);
            info.setBemerkung(u["bemerkung"]);
            info.setSender(u["name-des-senders"]);
            info.setMitnehmen(u['mitnehmen-test']);
            info.setkeineAktivitat(u['keine-aktivitat'].toString());
            info.setGrund(u['grund']);
            info.setFerien(u['ferien'].toString());
            info.setEndeFerien(_formatDate(u['ende-ferien']));
            telblitz = {
              'datum': info.datum,
              'keine-aktivitat': info.keineaktivitat,
              'antreten': info.antreten,
              'google-map': info.antretenMap,
              'abtreten': info.abtreten,
              'map-abtreten': info.abtretenMap,
              'bemerkung': info.bemerkung,
              'name-des-senders': info.sender,
              'mitnehmen-test': info.mitnehmen,
              'grund': info.grund,
              'ferien': info.ferien,
              'ende-ferien': info.endeferien,
            };
            moreafire.uploadteleblitz(stufe, telblitz);
          }
        }
      } else {
        await moreafire.getteleblitz(stufe).then((result) {
          info.setTitel(stufe);
          info.setDatum(result.data["datum"]);
          info.setAntreten(result.data["antreten"]);
          info.setAntretenMaps(result.data["google-map"]);
          info.setAbtreten(result.data["abtreten"]);
          info.setAbtretenMaps(result.data["map-abtreten"]);
          info.setBemerkung(result.data["bemerkung"]);
          info.setSender(result.data["name-des-senders"]);
          info.setMitnehmen(result.data['mitnehmen-test']);
          info.setkeineAktivitat(result.data['keine-aktivitat']);
          info.setGrund(result.data['grund']);
          info.setFerien(result.data['ferien']);
          info.setEndeFerien(result.data['ende-ferien']);
        });
      }
      return info;
    }
  }

  Widget anzeigen(String _stufe) {
    try {
      return new FutureBuilder(
          future: getInfos(_stufe),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                    child: Container(
                  padding: EdgeInsets.all(120),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text('Loading...'),
                      ),
                      Expanded(child: new CircularProgressIndicator())
                    ],
                  ),
                )),
              );
            } else {
              if (snapshot.data.keineaktivitat == 'true') {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      snapshot.data.getTitel(),
                      snapshot.data.getKeineAktivitat(),
                      snapshot.data.getDatum(),
                      snapshot.data.getGrund()
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        offset: Offset(3, 3),
                        blurRadius: 40)
                  ]),
                );
              } else if (snapshot.data.ferien == 'true') {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      snapshot.data.getTitel(),
                      snapshot.data.getKeineAktivitat(),
                      snapshot.data.getFerien(),
                      snapshot.data.getEndeFerien(),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        offset: Offset(3, 3),
                        blurRadius: 40)
                  ]),
                );
              }
              return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      snapshot.data.getTitel(),
                      snapshot.data.getDatum(),
                      snapshot.data.getAntreten(),
                      snapshot.data.getAbtreten(),
                      snapshot.data.getMitnehmen(),
                      snapshot.data.getBemerkung(),
                      snapshot.data.getSender(),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(3, 3),
                          blurRadius: 40)
                    ],
                  ));
            }
          });
    } catch (e) {
      print(e);
      return Center(
        child: Text(
          'Internet?',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }
}

class Info {
//  static Info _instance;
//
//  factory Info() => _instance ??= new Info._();
//
//  Info._();

  Urllauncher urllauncher = new Urllauncher();

  String titel;
  String antreten;
  String antretenMap;
  String abtreten;
  String abtretenMap;
  String datum;
  String bemerkung;
  String sender;
  String mitnehmen;
  String keineaktivitat;
  String grund;
  String ferien;
  String endeferien;
  double _sizeleft = 110;

  void setTitel(String titel) {
    this.titel = titel;
  }

  void setAntreten(String antreten) {
    this.antreten = antreten;
  }

  void setAntretenMaps(String antretenMaps) {
    this.antretenMap = antretenMaps;
  }

  void setAbtreten(String abtreten) {
    this.abtreten = abtreten;
  }

  void setAbtretenMaps(String abtretenMaps) {
    this.abtretenMap = abtretenMaps;
  }

  void setDatum(String datum) {
    this.datum = datum;
  }

  void setBemerkung(String bemerkung) {
    this.bemerkung = bemerkung;
  }

  void setSender(String sender) {
    this.sender = sender;
  }

  void setMitnehmen(mitnehmen) {
    this.mitnehmen = mitnehmen;
  }

  void setkeineAktivitat(String aktv) {
    this.keineaktivitat = aktv;
  }

  void setGrund(String grund) {
    this.grund = grund;
  }

  void setFerien(String ferien) {
    this.ferien = ferien;
  }

  void setEndeFerien(String endeferien) {
    this.endeferien = endeferien;
  }

  Container getTitel() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      alignment: Alignment.topLeft,
      child: Text(this.titel,
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff7a62ff),
              shadows: <Shadow>[
                Shadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 6),
                    blurRadius: 12),
              ])),
    );
  }

  Container getKeineAktivitat() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          children: <Widget>[
            SizedBox(
              child: Text(
                'Keine Aktivität',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: SizedBox(),
            )
          ],
        ));
  }

  Container getAntreten() {
    if ((keineaktivitat == 'false') || (this?.antreten?.isNotEmpty ?? false)) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: this._sizeleft,
                child: Text("Antreten", style: this._getStyleLeft())),
            Expanded(
              child: InkWell(
                child: Text(
                  this.antreten,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 255),
                      decoration: TextDecoration.underline),
                ),
                onTap: () {
                  urllauncher.openlinkMaps(this.antretenMap);
                },
              ),
            )
          ],
        ),
        /*child: Center(
        child: Text(this.antreten, style: TextStyle(fontSize: 18)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),*/
      );
    }
  }

  Container getAbtreten() {
    if ((keineaktivitat == false) || (this?.abtreten?.isNotEmpty ?? false)) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: this._sizeleft,
                child: Text("Abtreten", style: this._getStyleLeft())),
            Expanded(
                child: InkWell(
              child: Text(
                this.abtreten,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 255),
                    decoration: TextDecoration.underline),
              ),
              onTap: () {
                urllauncher.openlinkMaps(this.abtretenMap);
              },
            ))
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            children: <Widget>[
              SizedBox(),
              Expanded(
                child: SizedBox(),
              )
            ],
          ));
    }
  }

  Container getDatum() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: this._sizeleft,
              child: Text("Datum", style: this._getStyleLeft())),
          Expanded(
              child: Text(
            this.datum,
            style: this._getStyleRight(),
          ))
        ],
      ),
    );
  }

  Container getBemerkung() {
    if ((keineaktivitat == false) || (this?.bemerkung?.isNotEmpty ?? false)) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: this._sizeleft,
                        child: Text("Bemerkung:", style: this._getStyleLeft())),
                    /*Expanded(
                  child: Text(
                this.bemerkung,
                style: this._getStyleRight(),
              ))*/
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      this.bemerkung,
                      style: this._getStyleRight(),
                    ))
                  ],
                ),
              ),
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            children: <Widget>[
              SizedBox(),
              Expanded(
                child: SizedBox(),
              )
            ],
          ));
    }
  }

  Container getSender() {
    if ((keineaktivitat == false) || (this?.sender?.isNotEmpty ?? false)) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  width: this._sizeleft,
                  child: Text("", style: this._getStyleLeft())),
              Expanded(
                  child: Text(
                this.sender,
                style: this._getStyleRight(),
              ))
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            children: <Widget>[
              SizedBox(),
              Expanded(
                child: SizedBox(),
              )
            ],
          ));
    }
  }

  Container getMitnehmen() {
    if ((keineaktivitat == false) || (this?.antreten?.isNotEmpty ?? false)) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: this._sizeleft,
                        child: Text("Mitnehmen:", style: this._getStyleLeft())),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Html(
                    data: this.mitnehmen,
                    defaultTextStyle: _getStyleRight(),
                  ))
                ],
              ),
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            children: <Widget>[
              SizedBox(),
              Expanded(
                child: SizedBox(),
              )
            ],
          ));
    }
  }

  Container getGrund() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: this._sizeleft,
                      child: Text("Grund:", style: this._getStyleLeft())),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Html(
                  data: this.grund,
                  defaultTextStyle: _getStyleRight(),
                ))
              ],
            ),
          ],
        ));
  }

  Container getFerien() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: this._sizeleft,
                      child: Text("Grund:", style: this._getStyleLeft())),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Text(
                  "Die Aktivität fällt leider wegen der Schulferien aus.",
                  style: this._getStyleRight(),
                ))
              ],
            ),
          ],
        ));
  }

  Container getEndeFerien() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: this._sizeleft,
                      child: Text("Ende Ferien:", style: this._getStyleLeft())),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Html(
                  data: this.endeferien,
                  defaultTextStyle: _getStyleRight(),
                ))
              ],
            ),
          ],
        ));
  }

  TextStyle _getStyleLeft() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _getStyleRight() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
  }
}
