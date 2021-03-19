import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:morea/Pages/Profil/change_address.dart';
import 'package:morea/Pages/Profil/change_email.dart';
import 'package:morea/Pages/Profil/change_name.dart';
import 'package:morea/Pages/Profil/change_phone_number.dart';
import 'package:morea/Widgets/animated/MoreaLoading.dart';
import 'package:morea/Widgets/standart/buttons.dart';
import 'package:morea/Widgets/standart/moreaTextStyle.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/morealayout.dart';
import 'package:morea/services/cloud_functions.dart';
import 'package:morea/services/group.dart';
import 'package:morea/services/mailchimp_api_manager.dart';
import 'package:morea/services/morea_firestore.dart';
import 'package:morea/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:morea/services/utilities/MiData.dart';

class EditUserProfilePage extends StatefulWidget {
  EditUserProfilePage(
      {this.userID, this.groupID, this.profile, this.moreaFire, this.crud0});

  final String groupID, userID;
  final MoreaFirebase moreaFire;
  final CrudMedthods crud0;
  final Map profile;

  @override
  State<StatefulWidget> createState() => new EditUserPoriflePageState();
}

class EditUserPoriflePageState extends State<EditUserProfilePage>
    with TickerProviderStateMixin {
  MoreaFirebase moreafire;
  CrudMedthods crud0;

  MailChimpAPIManager mailchimpApiManager = MailChimpAPIManager();

  String _email, _pfadinamen = ' ', _vorname, _nachname, _geburtstag, _pos;
  String _adresse,
      _ort,
      _plz,
      _handynummer,
      userId,
      error,
      selectedrolle,
      _geschlecht;
  List<String> _stufe, oldGroup;
  List<Map> _stufenselect = [];
  List<String> _rollenselect = ['Teilnehmer', 'Leiter'];

  MoreaLoading moreaLoading;
  bool loading = true;
  PriviledgeEntry _priviledgeEntry;

  void validateAndSubmit() async {
    try {
      setState(() {
        loading = true;
      });

      Map<String, dynamic> userdata = mapUserData();

      MoreaGroup.editPriviledgeEntry(widget.groupID,
          userID: widget.userID,
          displayName: (userdata[userMapPfadiName] == " ")
              ? userdata[userMapVorName]
              : userdata[userMapPfadiName],
          customInfo: userdata);
      await moreafire
          .goToNewGroup(
              userdata['UID'],
              (userdata[userMapPfadiName] == " ")
                  ? userdata[userMapVorName]
                  : userdata[userMapPfadiName],
              oldGroup,
              _stufe)
          .then((onValue) => setState);
      callFunction(getcallable("updateUserProfile"), param: userdata);
      mailchimpApiManager.updateUserInfo(
          _email, _vorname, _nachname, _geschlecht, _stufe, moreafire);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      print('$e');
      setState(() {
        loading = false;
      });
    }
  }

  void deleteuseraccount() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          'Achtung',
          style: MoreaTextStyle.warningTitle,
        ),
        content: Container(
          child: Text('Du bist dabei einen User zu löschen.'),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('ABBRECHEN'),
              onPressed: () {
                Navigator.pop(context);
              }),
          moreaFlatRedButton('LÖSCHEN', this.delete)
        ],
      ),
    );
  }

  void delete() async {
    setState(() {
      loading = true;
    });
    Navigator.of(context).pop();
    if (_priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
            [userMapEltern] !=
        null) {
      for (var elternUID in _priviledgeEntry
          .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapEltern].keys
          .toList()) {
        var elternMap = (await crud0.getDocument(pathUser, elternUID)).data();
        elternMap[userMapKinder].remove(_priviledgeEntry
            .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapUID]);
        await moreafire.updateUserInformation(elternMap[userMapUID], elternMap);
      }
    }
    if (_priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
            [userMapKinder] !=
        null) {
      for (var childUID in _priviledgeEntry
          .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapKinder].keys
          .toList()) {
        Map childMap = (await crud0.getDocument(pathUser, childUID)).data();
        if (childMap[userMapChildUID] == null) {
          childMap[userMapEltern].remove(_priviledgeEntry
              .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapUID]);
          await moreafire.updateUserInformation(childMap[userMapUID], childMap);
        } else {
          if (childMap[userMapEltern].length == 1) {
            await callFunction(getcallable('deleteUserMap'),
                param: {'UID': childUID, 'groupID': childMap[userMapGroupIDs]});
          } else {
            childMap[userMapEltern].remove(_priviledgeEntry
                .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapUID]);
            await moreafire.updateUserInformation(childUID, childMap);
          }
        }
      }
    }
    if (_priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
            ['UID'] ==
        null) {
      _priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]['UID'] =
          _priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
              ['childUID'];
    }
    /*
    if (customInfo[userMapGroupIDs] != null) {
      await callFunction(getcallable('deleteUserMap'), param: {
        'UID': customInfo['UID'],
        'groupID': customInfo[userMapGroupIDs],
      });
    } else if (customInfo[userMapSubscribedGroups] != null) {
      if (customInfo[userMapSubscribedGroups].length == 1) {
        await callFunction(getcallable('deleteUserMap'), param: {
          'UID': customInfo['UID'],
          'groupID': customInfo[userMapSubscribedGroups][0],
        });
      } else {
        for (int i = customInfo[userMapSubscribedGroups].length - 1;
            i < 1;
            i--) {
          await callFunction(getcallable('desubFromGroup'), param: {
            'UID': customInfo[userMapUID],
            'groupID': customInfo[userMapSubscribedGroups][i],
          });
        }
        await callFunction(getcallable('deleteUserMap'), param: {
          'UID': customInfo['UID'],
          'groupID': customInfo[userMapSubscribedGroups][0],
    */
    if (_priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
            [userMapGroupIDs] !=
        null) {
      if (_priviledgeEntry
              .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapGroupIDs]
              .length ==
          1) {
        await callFunction(getcallable('deleteUserMap'), param: {
          'UID': _priviledgeEntry
              .rawPriviledge[groupMapPriviledgeEntryCustomInfo]['UID'],
          'groupID':
              _priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
                  [userMapGroupIDs][0],
        });
      } else {
        for (int i = _priviledgeEntry
                    .rawPriviledge[groupMapPriviledgeEntryCustomInfo]
                        [userMapGroupIDs]
                    .length -
                1;
            i < 1;
            i--) {
          await callFunction(getcallable('leafeGroup'), param: {
            'UID': _priviledgeEntry
                .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapUID],
            'groupID': _priviledgeEntry
                    .rawPriviledge[groupMapPriviledgeEntryCustomInfo]
                [userMapGroupIDs][i],
          });
        }
        await callFunction(getcallable('deleteUserMap'), param: {
          'UID': _priviledgeEntry
              .rawPriviledge[groupMapPriviledgeEntryCustomInfo]['UID'],
          'groupID':
              _priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo]
                  [userMapGroupIDs][0],
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Error',
                  style: MoreaTextStyle.warningTitle,
                ),
                content: RichText(
                  text: TextSpan(
                    text:
                        'Etwas ist schiefgelaufen. Der Account konnte nicht gelöscht werden. Bitte schreibe eine E-Mail an: it@morea.ch',
                    style: MoreaTextStyle.normal,
                  ),
                ),
                actions: <Widget>[
                  moreaFlatButton('OK', () => Navigator.of(context).pop()),
                ],
              ));
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Map mapUserData() {
    Map<String, dynamic> userInfo =
        _priviledgeEntry.rawPriviledge[groupMapPriviledgeEntryCustomInfo];
    userInfo[userMapPfadiName] = this._pfadinamen;
    userInfo[userMapVorName] = this._vorname;
    userInfo[userMapNachName] = this._nachname;
    userInfo[userMapAdresse] = this._adresse;
    userInfo[userMapPLZ] = this._plz;
    userInfo[userMapOrt] = this._ort;
    userInfo[userMapEmail] = this._email;
    userInfo[userMapHandynummer] = this._handynummer;
    userInfo[userMapGeschlecht] = this._geschlecht;
    userInfo[userMapAlter] = this._geburtstag;
    userInfo[userMapGroupIDs] = _stufe;
    userInfo[userMapPos] = _pos;
    return userInfo;
  }

  @override
  void initState() {
    moreaLoading = MoreaLoading(this);
    this._priviledgeEntry = new PriviledgeEntry(data: widget.profile);
    selectedrolle = this._priviledgeEntry.roleType;
    moreafire = widget.moreaFire;
    crud0 = widget.crud0;

    //oldGroup = customInfo[userMapGroupIDs];
    oldGroup = List<String>.from(this
        ._priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapGroupIDs]);
    initStrings();
    initSubgoup();
    loading = false;
    super.initState();
  }

  @override
  void dispose() {
    moreaLoading.dispose();
    super.dispose();
  }

  initSubgoup() async {
    Map<String, dynamic> data =
        (await crud0.getDocument(pathGroups, moreaGroupID)).data();
    print(
        "test" + data[groupMapGroupOption][groupMapGroupLowerClass].toString());
    this._stufenselect = <Map>[];
    data[groupMapGroupOption][groupMapGroupLowerClass].forEach((k, value) =>
        this._stufenselect.add({
          userMapGroupIDs: value['groupID'],
          groupMapgroupNickName: value['groupNickName']
        }));
    setState(() {});
  }

  void initStrings() {
    this._vorname = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapVorName];
    this._nachname = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapNachName];
    this._pfadinamen = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapPfadiName];
    this._adresse = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapAdresse];
    this._plz = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapPLZ];
    this._ort = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapOrt];
    this._email = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapEmail];
    this._handynummer = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapHandynummer];
    this._geschlecht = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapGeschlecht];
    this._geburtstag = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapGeburtstag];
    this._stufe = List<String>.from(_priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapGroupIDs]);
    this._pos = _priviledgeEntry
        .rawPriviledge[groupMapPriviledgeEntryCustomInfo][userMapPos];
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: Colors.white,
        child: moreaLoading.loading(),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(_priviledgeEntry
              .rawPriviledge[groupMapPriviledgeEntryCustomInfo]['Vorname']),
        ),
        body: MoreaBackgroundContainer(
            child: SingleChildScrollView(
          child: MoreaShadowContainer(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildInputs() + buildSubmitButtons()),
          ),
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: MoreaColors.violett,
          onPressed: () => validateAndSubmit(),
        ),
      );
    }
  }

  List<Widget> buildInputs() {
    return [
      Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Profil ändern',
          style: MoreaTextStyle.title,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'Name',
          style: MoreaTextStyle.lable,
        ),
        subtitle: Text(_pfadinamen == null
            ? '$_vorname $_nachname'
            : '$_vorname $_nachname v/o $_pfadinamen'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeName(_vorname, _nachname, _pfadinamen, changeName))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'Adresse',
          style: MoreaTextStyle.lable,
        ),
        subtitle: Text('$_adresse, $_plz $_ort'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeAddress(_adresse, _plz, _ort, changeAdress))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'E-Mail-Adresse',
          style: MoreaTextStyle.lable,
        ),
        subtitle: _email == null ? null : Text(_email),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeEmail(_email, changeEmail))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'Handynummer',
          style: MoreaTextStyle.lable,
        ),
        subtitle: _handynummer == null ? null : Text(_handynummer),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangePhoneNumber(_handynummer, changePhoneNumber))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'Geschlecht',
          style: MoreaTextStyle.lable,
        ),
        subtitle: Text(_geschlecht),
        onTap: () => _selectGeschlecht(),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      ListTile(
        title: Text(
          'Geburtstag',
          style: MoreaTextStyle.lable,
        ),
        subtitle: _geburtstag == null ? Text('') : Text(_geburtstag),
        onTap: () async {
          await DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: DatePickerTheme(
                  doneStyle: TextStyle(
                      color: MoreaColors.violett,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              minTime: DateTime.now().add(new Duration(days: -365 * 100)),
              maxTime: DateTime.now().add(new Duration(days: -365 * 3)),
              onConfirm: (date) {
            _geburtstag = DateFormat('dd.MM.yyy', 'de').format(date).toString();
          }, currentTime: DateTime.now(), locale: LocaleType.de);

          setState(() {});
        },
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MoreaDivider(),
      ),
      (_pos == "Mutter" ||
              _pos == 'Vater' ||
              _pos == 'Erziehungsberechtigter' ||
              _pos == 'Erziehungsberechtigte')
          ? Container()
          : ListTile(
              title: Text(
                'Stufe',
                style: MoreaTextStyle.lable,
              ),
              subtitle: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _stufe.length,
                  itemBuilder: (context, index) {
                    return Text(convMiDatatoWebflow(_stufe[index]));
                  }),
              onTap: () => _selectStufe(),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
      (_pos == "Mutter" ||
              _pos == 'Vater' ||
              _pos == 'Erziehungsberechtigter' ||
              _pos == 'Erziehungsberechtigte')
          ? Container()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: MoreaDivider(),
            ),
      ListTile(
        title: Text(
          'Rolle',
          style: MoreaTextStyle.lable,
        ),
        subtitle: Text(_pos),
        onTap: () => _selectRolle(),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      Center(
          child: moreaFlatRedButton('PERSON LÖSCHEN', this.deleteuseraccount)),
      SizedBox(
        height: 15,
      )
    ];
  }

  void changeName(String vorname, String nachname, String pfadiname) {
    this._vorname = vorname;
    this._nachname = nachname;
    this._pfadinamen = pfadiname;
  }

  void changeAdress(String adresse, String plz, String ort) {
    this._adresse = adresse;
    this._plz = plz;
    this._ort = ort;
  }

  void changeEmail(String email) {
    this._email = email;
  }

  void changePhoneNumber(String handynummer) {
    this._handynummer = handynummer;
  }

  void _selectGeschlecht() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Geschlecht ändern'),
            content: DropdownButton<String>(
                items: [
                  DropdownMenuItem(value: "Weiblich", child: Text('weiblich')),
                  DropdownMenuItem(value: 'Männlich', child: Text('männlich'))
                ],
                hint: Text(_geschlecht),
                onChanged: (newVal) {
                  _geschlecht = newVal;
                  this.setState(() {});
                  Navigator.of(context).pop();
                }),
            actions: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 16,
                ),
                label: Text(
                  "Abbrechen",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MoreaColors.violett),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
              )
            ],
          );
        });
  }

  void _selectStufe() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Stufe ändern'),
            content: DropdownButton<String>(
                items: _stufenselect.map((Map group) {
                  return new DropdownMenuItem<String>(
                    value: group[userMapGroupIDs],
                    child: new Text(group[groupMapgroupNickName]),
                  );
                }).toList(),
                hint: Text(convMiDatatoWebflow(_stufe[0])),
                onChanged: (newVal) {
                  _stufe = [newVal];
                  this.setState(() {});
                  Navigator.of(context).pop();
                }),
            actions: <Widget>[
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    "Abbrechen",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MoreaColors.violett),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))))))
            ],
          );
        });
  }

  void _selectRolle() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Rolle ändern'),
            content: DropdownButton<String>(
                items: _rollenselect.map((String val) {
                  return new DropdownMenuItem<String>(
                    value: val,
                    child: new Text(val),
                  );
                }).toList(),
                hint: Text(_pos),
                onChanged: (newVal) {
                  _pos = newVal;
                  this.setState(() {});
                  Navigator.of(context).pop();
                }),
            actions: <Widget>[
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    "Abbrechen",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MoreaColors.violett),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))))))
            ],
          );
        });
  }
}
