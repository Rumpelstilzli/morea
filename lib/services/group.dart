import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/services/cloud_functions.dart';
import 'package:morea/services/crud.dart';
import 'package:morea/services/user.dart';
import 'package:morea/services/utilities/blockedUserChecker.dart';

/*
Use-Case:
  This Class is the backend to all group related actions.
  
Developed:
  David Wild - 2.08.20

Description:
  initialisation:
    stream groupID
    crud0
  
  Functions:
    streamGroupMap
     - readGroupMap
    createGroup
    joinGroup
    adminGroup 
*/

Future<QuerySnapshot> getMembers(CrudMedthods crud0, String groupID) async {
  return crud0.getCollection('$pathGroups/$groupID/$pathPriviledge');
}

abstract class BaseMoreGroup {
  void streamGroupMap(Stream<String> groupID);
  void readGroupMap(
      Map<String, dynamic> groupMap, String groupID, String userID);

  Future<void> inviteUsers(List<String> luserIDs);
  //TODO functions
  //TODO fix groupMap doc structure
}

class MoreaGroup extends BaseMoreGroup {
  //Objects
  CrudMedthods crud0;
  //Attributes
  Stream<String> smGroupID;
  Stream<DocumentSnapshot> _sDSGroupMap;
  List<String> homeFeed;
  PriviledgeEntry priviledge;
  Map<String, RoleEntry> roles;

  MoreaGroup({this.smGroupID, this.crud0}) {
    streamGroupMap(smGroupID);
  }
  void streamGroupMap(Stream<String> smGroupID) async {
    await for (String groupID in smGroupID) {
      _sDSGroupMap = crud0.streamDocument(pathGroups, groupID);

      await for (DocumentSnapshot dSGroupMap in _sDSGroupMap)
        readGroupMap(dSGroupMap.data(), groupID, User.id);
    }
  }

  Future<Map<String, dynamic>> getUserPriviledge(
      String groupID, String userID) async {
    return Map<String, dynamic>.from((await crud0.getDocument(
            '$pathGroups/$groupID/$pathPriviledge', userID))
        .data());
  }

  void readGroupMap(Map<String, dynamic> groupMap, groupID, userID) async {
    //turnOn/OFF groupMapTest
    if (true) {
      if (groupMap.containsKey(groupMapHomeFeed))
        this.homeFeed = groupMap[groupMapHomeFeed];
      else
        throw "$groupMapHomeFeed has to be non-null";

      if (groupMap.containsKey(groupMapRoles))
        groupMap[groupMapRoles].map((String key, dynamic value) => this
            .roles[key] = RoleEntry(data: Map<String, dynamic>.from(value)));
      else
        throw "$groupMapRoles has to be non-null";
      Map<String, dynamic> groupUserData =
          await getUserPriviledge(groupID, userID);
      this.priviledge = PriviledgeEntry(data: groupUserData);
      priviledge.readRole(globalConfigRoles, this.roles);
    }
  }

  Future<void> inviteUsers(List<String> userIDs) {}

  // Calls a Firebase Function witch removes the priviledge Entry of a user.
  static Future<void> leafe(String userID, String groupID) {
    return callFunction(getcallable("leafeGroup"),
        param: Map<String, dynamic>.from({"UID": userID, "groupID": groupID}));
  }

  // Calls a Firebase Function, witch adds user to group
  static Future<void> join(String groupID,
      {String userID, String displayName, Map<String, dynamic> customInfo}) {
    return callFunction(getcallable("joinGroup"),
        param: Map<String, dynamic>.from({
          "groupID": groupID,
          userMapUID: (userID != null) ? userID : User.id,
          groupMapDisplayName:
              (displayName != null) ? displayName : User.userName,
          groupMapPriviledgeEntryCustomInfo: customInfo
        }));
  }

  static Future<void> editPriviledgeEntry(String groupID,
      {String userID, String displayName, Map<String, dynamic> customInfo}) {
    return callFunction(getcallable("updatePriviledgeEntry"),
        param: Map<String, dynamic>.from({
          "groupID": groupID,
          userMapUID: (userID != null) ? userID : User.id,
          groupMapDisplayName:
              (displayName != null) ? displayName : User.userName,
          groupMapPriviledgeEntryCustomInfo: customInfo
        }));
  }

  // Creates a group TODO: implement
  static Future<void> create(Map<String, dynamic> groupMap) {}
}

class PriviledgeEntry extends RoleEntry {
  String displayName;
  String roleType;
  String roleLocation;
  List<String> groupJoinDate;
  Map<String, dynamic> customInfo;
  Map<String, dynamic> rawPriviledge;
  RoleEntry role;
  PriviledgeEntry({CrudMedthods crud0, Map data}) {
    if (data != null) this.readPriviledgeEntry(Map<String, dynamic>.from(data));
  }

  void readPriviledgeEntry(Map<String, dynamic> data) {
    this.displayName = data[groupMapDisplayName];
    this.roleType = data[groupMapPriviledgeEntryType];
    this.groupJoinDate = List<String>.from(data[groupMapGroupJoinDate]);
    this.roleLocation = data[groupMapPriviledgeEntryLocation];
    this.rawPriviledge = data;
  }

  void readRole(Map<String, RoleEntry> global, Map<String, RoleEntry> local) {
    if (this.roleLocation == 'local') {
      if (local.containsKey(this.roleType)) {
        if (local[groupMapPriviledgeEntryCustomInfo] != null)
          local[this.roleType].customInfoTypes.forEach((key, value) {
            this.customInfo[key] =
                rawPriviledge[groupMapPriviledgeEntryCustomInfo][key];
          });
        this.role = local[this.roleType];
      } else
        print("In Role location: ${this.roleLocation} is not defined $local");
    } else if (this.roleLocation == 'global') {
      if (global.containsKey(this.roleType)) {
        if (global[this.roleType].customInfoTypes != null)
          global[this.roleType].customInfoTypes.forEach((key, value) {
            this.customInfo[key] =
                rawPriviledge[groupMapPriviledgeEntryCustomInfo][key];
          });
        this.role = global[this.roleType];
        print(this.role);
      } else
        print("In Role location: ${this.roleType} is not defined in $global");
    }
  }
}

class RoleEntry {
  //General Priviledge: 0 no w/r, 1 no w but r access, 2  w/r access, 3 w/r acces able to change general for all users.
  int groupPriviledge = 0;
  Map<String, dynamic> customInfoTypes;
  String roleName;

  bool seeMembers;
  bool seeMembersDetail;
  int teleblitzPriviledge;

  RoleEntry({Map<String, dynamic> data}) {
    if (data != null) this.read(data);
  }
  void read(Map<String, dynamic> data) {
    if (data.containsKey(groupMapgroupPriviledge))
      this.groupPriviledge = data[groupMapgroupPriviledge];
    if (data.containsKey(groupMapRolesCustomInfoTypes))
      this.customInfoTypes = data[groupMapRolesCustomInfoTypes];
    this.roleName = data[groupMapRolesRoleName];
    this.seeMembers = data[groupMapPriviledgeEntrySeeMembers];
    this.seeMembersDetail = data[groupMapPriviledgeEntrySeeMembersDetails];
    if (data[eventTeleblitzPriviledge] is int)
      this.teleblitzPriviledge = data[eventTeleblitzPriviledge];
    else if (data[eventTeleblitzPriviledge] is String)
      this.teleblitzPriviledge = int.parse(data[eventTeleblitzPriviledge]);
    else
      throw "Runtype: ${data[eventTeleblitzPriviledge].runtimeType} for teleblitzPriviledge is not supported";
    print(this.teleblitzPriviledge);
  }
}
