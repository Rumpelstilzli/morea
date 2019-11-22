import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:morea/services/morea_firestore.dart';
import 'package:morea/morealayout.dart';
import 'package:intl/intl.dart';
import 'cange_teleblitz_abtreten.dart';
import 'cange_teleblitz_antreten.dart';
import 'cange_teleblitz_bemerkung.dart';
import 'cange_teleblitz_mitnehmen.dart';
import 'cange_teleblitz_sender.dart';

class ChangeTeleblitzV2 extends StatefulWidget {
  final String stufe;
  final String formType;
  final MoreaFirebase moreaFire;

  ChangeTeleblitzV2(this.stufe, this.formType, this.moreaFire);

  @override
  State<StatefulWidget> createState() => _ChangeTeleblitzV2State();
}

enum FormType { keineAktivitaet, ferien, normal }

class _ChangeTeleblitzV2State extends State<ChangeTeleblitzV2> {
  String stufe;
  FormType formType;
  

  //Variabeln vom Teleblitz
  String name,
      datum,
      antreten,
      mapAntreten,
      abtreten,
      mapAbtreten,
      bemerkung,
      sender,
      grund,
      endeFerien,
      id,
      slug;

  List<String> mitnehmen;
  bool keineAktivitaet, ferien;
  bool archived = false;
  bool draft = false;
  var oldTeleblitz;

  TeleblitzManager teleblitzManager = TeleblitzManager();

  @override
  void initState() {
    super.initState();
    this.stufe = widget.stufe;
    this.oldTeleblitz = downloadTeleblitz();
    if (widget.formType == "keineAktivitaet") {
      this.formType = FormType.keineAktivitaet;
    } else if (widget.formType == "ferien") {
      this.formType = FormType.ferien;
    } else if (widget.formType == "normal") {
      this.formType = FormType.normal;
    } else {
      print('Error: Nicht der richtige FormType. Gewählter FormType: ' +
          widget.formType);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.oldTeleblitz,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.connectionState == ConnectionState.done){
          switch (formType) {
            case FormType.keineAktivitaet:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Normaler Teleblitz'),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.file_upload),
                  backgroundColor: MoreaColors.violett,
                ),
              );
              break;
            case FormType.ferien:
              return Container();
              break;
            case FormType.normal:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Normaler Teleblitz'),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.file_upload),
                  backgroundColor: MoreaColors.violett,
                  onPressed: () => uploadTeleblitz(),
                ),
                body: LayoutBuilder(
                  builder: (context, viewportConstraints) {
                    return MoreaBackgroundContainer(
                      child: SingleChildScrollView(
                        child: MoreaShadowContainer(
                          constraints: BoxConstraints(
                              minWidth: viewportConstraints.maxWidth),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(20),
                                child:
                                    Text("Biber", style: MoreaTextStyle.title),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Datum',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(datum),
                                onTap: () => _selectDatum(context),
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Beginn',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(antreten),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeAntreten(
                                              this.antreten,
                                              this.mapAntreten,
                                              this.setBeginn)));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Ende',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(abtreten),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeAbtreten(this.abtreten,
                                              this.mapAbtreten, this.setEnde)));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Mitnehmen',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: ListView.builder(
                                  itemCount: mitnehmen.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Text(mitnehmen[index]);
                                  },
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeMitnehmen(this.mitnehmen,
                                              this.setMitnehmen)));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Bemerkung',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(bemerkung),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeBemerkung(this.bemerkung,
                                              this.setBemerkung)));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding:
                                    EdgeInsets.only(right: 15, left: 15),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  )),
                              ListTile(
                                title: Text('Sender',
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(sender),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeSender(
                                              this.sender, this.setSender)));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                                contentPadding: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
              break;
          }
        }
        return null;
      },
    );
  }

  Future<Map> downloadTeleblitz() async {
    var infos = await teleblitzManager.downloadTeleblitz(this.stufe);
    this.name = infos['name'];
    this.datum = infos['datum'];
    antreten = infos['antreten'];
    mapAntreten = infos['google-map'];
    abtreten = infos['abtreten'];
    mapAbtreten = infos['map-abtreten'];
    mitnehmen = infos['mitnehmen-test'];
    bemerkung = infos['bemerkung'];
    sender = infos['name-des-senders'];
    grund = infos['grund'];
    endeFerien = infos['ende-ferien'];
    id = infos['_id'];
    slug = infos['slug'];
    switch (widget.formType) {
      case 'keineAktivitaet':
        keineAktivitaet = true;
        ferien = false;
        break;
      case 'ferien':
        keineAktivitaet = false;
        ferien = true;
        break;
      case 'normal':
        keineAktivitaet = false;
        ferien = false;
        break;
    }
    return infos;
  }

  void uploadTeleblitz() async {
    Map<String, dynamic> newTeleblitz = {
      'name': this.name,
      'datum': this.datum,
      'antreten': this.antreten,
      'google-map': this.mapAntreten,
      'abtreten': this.abtreten,
      'map-abtreten': this.mapAbtreten,
      'mitnehmen-test': this.mitnehmen,
      'bemerkung': this.bemerkung,
      'name-des-senders': this.sender,
      'grund': this.grund,
      'ende-ferien': this.endeFerien,
      'slug': this.slug,
      'ferien': this.ferien,
      'keine-aktivitat': this.keineAktivitaet,
      '_draft': false,
      '_archived': false
    };
    await teleblitzManager.uploadTeleblitz(newTeleblitz, this.id);
    await widget.moreaFire.uploadteleblitz(this.stufe, newTeleblitz);
    Navigator.of(context).pop();
  }

  Future<Null> _selectDatum(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 9999)));
    if (picked != null) {
      setState(() {
        this.datum = DateFormat('EEEE, dd.MM.yyy', 'de').format(picked);
      });
    }
  }

  void setBeginn(String ort, String zeit, String map) {
    this.antreten = ort + ', ' + zeit + ' Uhr';
    this.mapAntreten = map;
  }

  void setEnde(String ort, String zeit, String map) {
    this.abtreten = ort + ', ' + zeit + ' Uhr';
    this.mapAbtreten = map;
  }

  void setMitnehmen(List<String> mitnehmen) {
    this.mitnehmen = mitnehmen;
  }

  void setBemerkung(String bemerkung) {
    this.bemerkung = bemerkung;
  }

  void setSender(String sender) {
    this.sender = sender;
  }
}

class TeleblitzManager {
  TeleblitzManager();

  Future<Map> downloadTeleblitz(String stufe) async {
    var jsonDecode;
    var jsonString;
    jsonString = await http.get(
        "https://api.webflow.com/collections/5be4a9a6dbcc0a24d7cb0ee9/items?api_version=1.0.0&access_token=d9097840d357b02bd934ba7d9c52c595e6940273e940816a35062fe99e69a2de");
    jsonDecode = json.decode(jsonString.body);
    Map infos;
    for (var u in jsonDecode['items']) {
      if (u["name"] == stufe) {
        infos = u;
      }
    }
    String newDate = _formatDate(infos['ende-ferien']);
    infos['ende-ferien'] = newDate;
    infos['mitnehmen-test'] = _formatMitnehmen(infos['mitnehmen-test']);
    return infos;
  }

  String _formatDate(String date) {
    if (date != '') {
      String rawDate = date.split('T')[0];
      List<String> dates = rawDate.split('-');
      String formatedDate = dates[2] + '.' + dates[1] + '.' + dates[0];
      return formatedDate;
    } else {
      return '29.10.2019';
    }
  }

  List _formatMitnehmen(String mitnehmen) {
    List newMitnehmen = mitnehmen
        .replaceFirst("<ul>", "")
        .replaceFirst('<' + '/' + 'ul>', "")
        .replaceAll("</li><li>", ";")
        .replaceFirst("<li>", "")
        .replaceFirst("</li>", "")
        .split(';');
    return newMitnehmen;
  }

  void uploadTeleblitz(Map newTeleblitz, String id) {
    String formatedMitnehmen = '<ul>';
    for(String u in newTeleblitz['mitnehmen-test']){
      formatedMitnehmen = formatedMitnehmen + '<li>' + u + '</li>';
    }
    formatedMitnehmen = formatedMitnehmen + '</ul>';
    newTeleblitz['mitnehmen-test'] = formatedMitnehmen;
    var result = newTeleblitz['ende-ferien'].split('.');
    newTeleblitz['ende-ferien'] = result[2] + '-' + result[1] + '-' + result[0] + 'T00:00:00.000Z';
    var jsonMap = {"fields": newTeleblitz};
    String jsonStr = jsonEncode(jsonMap);
    Map<String, String> header = Map();
    header["Authorization"] =
    "Bearer d9097840d357b02bd934ba7d9c52c595e6940273e940816a35062fe99e69a2de";
    header["accept-version"] = "1.0.0";
    header["Content-Type"] = "application/json";
    http
        .put(
      "https://api.webflow.com/collections/5be4a9a6dbcc0a24d7cb0ee9/items/" +
          id +
          "?live=true",
      headers: header,
      body: jsonStr,
    )
        .then((result) {
      print(result.statusCode);
      print(result.body);
    });
  }
}