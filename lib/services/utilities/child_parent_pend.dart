import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/services/cloud_functions.dart';
import 'package:morea/services/crud.dart';

abstract class BaseChildParendPend{
  Future<String> childGenerateRequestString(Map<String, dynamic> userMap);
}
class ChildParendPend extends BaseChildParendPend{
  MCloudFunctions cloudFunctions = new MCloudFunctions();
  CrudMedthods crud0;
  ChildParendPend({this.crud0});

  Future<String> childGenerateRequestString(Map<String, dynamic> userMap) async {
    return (await cloudFunctions.callFunction(
      cloudFunctions.getcallable("childPendRequest"), param: Map.from({
        userMapPos: userMap[userMapPos],
        userMapUID: userMap[userMapUID],
        mapTimestamp: DateTime.now().toIso8601String()
    }))).toString();
  }
  Future<bool> waitOnUserDataChange(String userID)async{
    return await crud0.waitOnDocumentChanged(pathUser, userID);
  }
  Future<void> deleteRequest(String request)async{
   return await crud0.deletedocument(pathRequest, request);
  }
  Future<void> parentSendsRequestString(String requestStr, userMap)async{
    return (await cloudFunctions.callFunction(
      cloudFunctions.getcallable("parendPendAccept"), param: Map.from({
        userMapPos: userMap[userMapPos],
        userMapUID: userMap[userMapUID],
        pathRequest: requestStr,
        mapTimestamp: DateTime.now().toIso8601String()
      })
    ));
  }

}