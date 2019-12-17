import 'package:flutter/cupertino.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/services/auth.dart';
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
    var someData = (await cloudFunctions.callFunction(
      cloudFunctions.getcallable("childPendRequest"), param: Map.from({
        userMapPos: userMap[userMapPos],
        userMapUID: userMap[userMapUID],
        mapTimestamp: DateTime.now().toIso8601String()
    }))).data;
    return someData.toString();
  }
  Future<bool> waitOnUserDataChange(String userID)async{
    return await crud0.waitOnDocumentChanged(pathUser, userID);
  }
  Future<void> deleteRequest(String request)async{
   return await crud0.deletedocument(pathRequest, request);
  }
  Future<void> parentSendsRequestString(String requestStr, Map<String,dynamic>userMap)async{
    return (await cloudFunctions.callFunction(
      cloudFunctions.getcallable("parendPendAccept"), param: Map.from({
        userMapPos: userMap[userMapPos],
        userMapUID: userMap[userMapUID],
        pathRequest: requestStr,
        mapTimestamp: DateTime.now().toIso8601String()
      })
    ));
  }
  Future<String> parentCreatesChild(String _childEmail, _childPasswort)async{
    //TODO
  }
  Future<void> createChildAndPendIt(String _childEmail, String _childPasswort, Map<String,dynamic> childData, Map<String, dynamic> parentData, BuildContext context)async{
    Auth childAuth = new Auth();
    try{
    //String childUID = await 
    String childUID  = await childAuth.createUserWithEmailAndPassword(_childEmail, _childPasswort);
    childData[userMapUID] = childUID;
    await childAuth.createUserInformation(childData);
    String requestStr = await this.childGenerateRequestString(childData);
    childAuth.signOut();
    return parentSendsRequestString(requestStr, parentData); 
    }catch(error){
      AuthProblems problem = childAuth.checkForAuthErrors(context, error);
      childAuth.displayAuthError(problem, context);
      return null;
    }
  }

}