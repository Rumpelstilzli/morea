import 'package:morea/morea_strings.dart';
import 'package:morea/services/Teleblitz/telbz_firestore.dart';
import 'package:morea/services/utilities/dwi_format.dart';
import 'auth.dart';
import 'crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart' as random;

abstract class BaseMoreaFirebase {
  String get getDisplayName;
  String get getPfandiName;
  String get getGroupID;
  String get getVorName;
  String get getNachName;
  String get getPos;
  String get getEventID;
  List<String> get getSubscribedGroups;
  Map<String,dynamic> get getGroupMap;
  Map<String,dynamic> get getUserMap;
  Map<String,dynamic> get getMessagingGroups;
  Map<String,Map<String,String>> get getChildMap;

  Future<void> createUserInformation(Map userInfo);
  Future<void> updateUserInformation(String userUID, Map userInfo);
  Future<DocumentSnapshot> getUserInformation(String userUID);
  Stream<QuerySnapshot> getChildren();
  Future<void> pendParent(
  String childUID, String parentUID, String parentName);
  Stream<DocumentSnapshot> streamPendingParents(String childUID);
  Future<void> setChildToParent(
  String childUID, String parentUID, String childName);
  Future<void> uploaddevtocken(
  var messagingGroups, String token, String userUID);
  Stream<QuerySnapshot> getMessages(String groupnr);
  Future<void> setMessageRead(String userUID, String messageID, String groupnr);
  String upLoadChildRequest(String childUID);
}

class MoreaFirebase extends BaseMoreaFirebase {
  CrudMedthods crud0;
  Auth auth0 = new Auth();
  DWIFormat dwiformat = new DWIFormat();
  TeleblizFirestore tbz;
  Map<String,dynamic> _userMap, _groupMap;
  Map<String, Map<String,String>> _subscribedGroupsMap, _childMap;
  String _displayName, _pfadiName, _groupID, _vorName, _nachName, _pos, _eventID;
  Map<String,dynamic> _messagingGroups;
  List<String> _subscribedGroups = new List<String>();
  Firestore firestore;

  MoreaFirebase(Firestore firestore, {List groupIDs}){
    this.firestore = firestore;
    crud0 = new CrudMedthods(firestore);
    if(groupIDs != null)
    tbz = new TeleblizFirestore(firestore , groupIDs);
  }
  String get getDisplayName => _displayName;
  String get getPfandiName => _pfadiName;
  String get getGroupID => _groupID;
  String get getVorName => _vorName;
  String get getNachName => _nachName;
  String get getPos => _pos;
  
  String get getEventID => _eventID;
  List<String> get getSubscribedGroups => _subscribedGroups;
  Map<String,dynamic> get getGroupMap => _groupMap;
  Map<String,dynamic> get getUserMap => _userMap;
  Map<String,dynamic> get getMessagingGroups => _messagingGroups;
  Map<String,Map<String,String>> get getChildMap => _childMap;

  Future<void> getData(String userID)async{
    _userMap = Map<String,dynamic>.from((await crud0.getDocument(pathUser, userID)).data);
    //init userMap
    _pfadiName = _userMap[userMapPfadiName];
    _groupID = _userMap[userMapgroupID];
    _vorName = _userMap[userMapVorName];
    _nachName = _userMap[userMapNachName];
    _pos = _userMap[userMapPos];
    _messagingGroups = Map<String,dynamic>.from(_userMap[userMapMessagingGroups]??[]);
    _subscribedGroups = List<String>.from(_userMap[userMapSubscribedGroups]?? []);
    if(_pfadiName == '')
      _displayName = _vorName;
    else
      _displayName = _pfadiName;
    if((_pos == userMapLeiter)||(_pos == userMapTeilnehmer)){
    //init groupMap
    _groupMap = (await crud0.getDocument(pathGroups, _userMap[userMapgroupID])).data;
    _eventID = _groupMap[groupMapEventID];
    }else{
      if(_userMap.containsKey(userMapKinder)){
        Map<String,String> kinderMap =  Map<String,String>.from( _userMap[userMapKinder]);
        _childMap = await createChildMap(kinderMap);
      }
    }
  }
  Future<Map<String,Map<String,String>>> createChildMap(Map<String,String> childs)async{
    Map<String,Map<String,String>> childMap = new Map();
    childs.forEach((vorname, childUID)async{
      Map<String,dynamic> childUserDat = (await crud0.getDocument(pathUser, childUID)).data;
      childMap[childUserDat[userMapgroupID]] = {vorname:childUID};
    });
    return childMap;
  }
  Future<void> initTeleblitz(){
    List<String> groupIDs = new List<String>();
    groupIDs.addAll(_subscribedGroups);
    groupIDs.add(_groupID);
    tbz = new TeleblizFirestore(firestore ,groupIDs);
  }

  Future<void> createUserInformation(Map userInfo) async {
    String userUID = await auth0.currentUser();
    await crud0.setData(pathUser, userUID, userInfo);
    return null;
  }

  Future<void> updateUserInformation(
    String userUID,
    Map userInfo,
  ) async {
    userUID = dwiformat.simplestring(userUID);
    await crud0.setData(pathUser, userUID, userInfo);
    return null;
  }

  Future<DocumentSnapshot> getUserInformation(String userUID) async {
    return await crud0.getDocument(pathUser, userUID);
  }
  Future<Map<String,dynamic>> getGroupInformation(groupID)async =>
     Map<String,dynamic>.from((await crud0.getDocument(pathGroups, groupID)).data);
    
  Stream<QuerySnapshot> getChildren() {
    return crud0.streamCollection(pathUser);
  }

  //Funktioniert das wück?
  Future<void> pendParent(
      String childUID, String parentUID, String parentName) async {
    Map<String, dynamic> parentMap = {};
    var old = await getUserInformation(childUID);

    if ((old.data['Eltern-pending'] != null) &&
        (old.data['Eltern-pending'].length != 0)) {
      parentMap = Map<String, dynamic>.from(old.data['Eltern-pending']);
    }
    if (parentMap[parentName] == null) {
      parentMap[parentName] = parentUID;
      Map newUserData = old.data;
      newUserData['Eltern-pending'] = parentMap;
      updateUserInformation(childUID, newUserData);
    }
  }

  Stream<DocumentSnapshot> streamPendingParents(String childUID) {
    return crud0.streamDocument(pathUser, childUID);
  }

  Future<void> setChildToParent(
      String childUID, String parentUID, String childName) async {
    Map<String, dynamic> childMap = {};
    var old = await getUserInformation(parentUID);

    if ((old.data['Kinder'] != null) && (old.data['Kinder'].length != 0)) {
      childMap = Map<String, dynamic>.from(old.data['Kinder']);
    }
    if (childMap[childName] == null) {
      childMap[childName] = childUID;
      Map newUserData = old.data;
      newUserData['Kinder'] = childMap;
      updateUserInformation(parentUID, newUserData);
    }
  }

  Future<void> uebunganmelden(
      String eventID, String userUID, String anmeldeUID, String anmeldeStatus) async {
        crud0.runTransaction("$pathEvents/$eventID/Anmeldungen", anmeldeUID, Map<String, dynamic>.from({
      "AnmeldeStatus":  anmeldeStatus,
      "AnmedeUID":      anmeldeUID,
      "UID":            userUID,
      "Timestamp":      DateTime.now()
    }));
    return null;
  }

  Future<void> uploadteleblitz(String groupID, Map data) async{
    String eventID =  groupID +  data['datum'].toString().replaceAll('Samstag, ', '');
    Map<String, List> akteleblitz = {
      groupMapHomeFeed: [eventID]
    };  
    await tbz.uploadTelbzAkt(groupID, akteleblitz);
    return await tbz.uploadTelbz(eventID, data);
  }
  Future<String> createEventID()async{
    String eventID;
    do {
      eventID = random.randomNumeric(9);
    } while (await tbz.eventIDExists(eventID));
    return eventID;
  }

  Future<Map> getteleblitz(String eventID) async {
    if (eventID != null) {
      return await tbz.getTelbz(eventID);
    } else {
      return null;
    }
  }

  Future<bool> refreshteleblitz(String eventID) async {
    DateTime letztesaktdat;
    Map telbz = await tbz.getTelbz(eventID);

    if (telbz != null) {
      letztesaktdat = DateTime.parse(telbz['Timestamp']);
    } else {
      letztesaktdat = DateTime.parse('2019-03-07T13:30:16.388642');
    }
    if ( DateTime.now().difference(letztesaktdat).inMinutes > 1) {
      return true;
    }
    return false;
  }


  Stream<QuerySnapshot> getAgenda(String groupnr) {
    return crud0.streamOrderCollection('groups/$groupnr/Agenda', 'Order');
  }

  Future<void> uploadtoAgenda(String groupnr, String name, Map data) async {
    name = dwiformat.simplestring(name);
    crud0.runTransaction('groups/$groupnr/Agenda', name, data);
    return null;
  }

//TODO Macht immer son error
  Future<void> uploaddevtocken(
      var messagingGroups, String token, String userUID) async {
    Map<String, dynamic> tokendata = {'devtoken': token};
    if(messagingGroups != null)
    for (var u in messagingGroups.keys) {
      if (messagingGroups[u]) {
        await crud0.setData('groups/$u/Devices', userUID, tokendata);
      }
    }
    return null;
  }

  String upLoadChildRequest(String childUID) {
    Map<String, String> data = {
      'purpose': 'child-pend-request',
      'child-UID': childUID,
      'timestamp': DateTime.now().toIso8601String()
    };
    String qrCodeString = random.randomAlphaNumeric(78);
    crud0.setData('user/requests/pend', qrCodeString, data);
    return qrCodeString;
  }

  Stream<QuerySnapshot> getMessages(String groupnr) {
    return crud0.streamCollection('/groups/$groupnr/messages');
  }

  Future<void> uploadMessage(groupnr, Map data) async {
    await crud0.setDataMessage('groups/$groupnr/messages', data);
    return null;
  }

  Future<void> setMessageRead(
      String userUID, String messageID, String groupnr) async {
    userUID = dwiformat.simplestring(userUID);
    var oldMessage =
        await crud0.getMessage('/groups/$groupnr/messages', messageID);
    oldMessage.data['read'][userUID] = true;
    await crud0.updateMessage(
        'groups/$groupnr/messages', messageID, oldMessage.data);
    return null;
  }
}
