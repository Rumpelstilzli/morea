import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morea/Pages/Personenverzeichniss/view_userprofile_page.dart';
import 'package:morea/Widgets/animated/MoreaLoading.dart';
import 'package:morea/Widgets/standart/moreaTextStyle.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/morealayout.dart';
import 'package:morea/services/crud.dart';
import 'package:morea/services/group.dart';
import 'package:morea/services/morea_firestore.dart';
import 'package:morea/services/utilities/MiData.dart';

class PersonenVerzeichnisState extends StatefulWidget {
  PersonenVerzeichnisState({this.moreaFire, this.crud0});

  final MoreaFirebase moreaFire;
  final CrudMedthods crud0;

  @override
  State<StatefulWidget> createState() => PersonenVerzeichnisStatePage();
}

class PersonenVerzeichnisStatePage extends State<PersonenVerzeichnisState>
    with TickerProviderStateMixin {
  MoreaLoading moreaLoading;

  @override
  void initState() {
    super.initState();
    moreaLoading = new MoreaLoading(this);
  }

  @override
  void dispose() {
    moreaLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.moreaFire.getGroupIDs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Personen'),
          bottom: TabBar(
            tabs: <Widget>[
              ...widget.moreaFire.getGroupIDs.map((groupID) => Tab(
                    text: convMiDatatoWebflow(groupID),
                  ))
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ...widget.moreaFire.getGroupIDs.map((groupID) => personen(groupID))
          ],
        ),
      ),
    );
  }

  Widget personen(String groupID) {
    return FutureBuilder(
        future: getMembers(widget.crud0, groupID),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> groupSnap) {
          if (!groupSnap.hasData) return moreaLoading.loading();
          if (groupSnap.data.docs.length > 0) {
            return MoreaBackgroundContainer(
                child: SingleChildScrollView(
              child: MoreaShadowContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        widget.moreaFire.getMapGroupData[groupID].groupNickName,
                        style: MoreaTextStyle.title,
                      ),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groupSnap.data.docs.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          title: new Text(
                            groupSnap.data.docs[index]
                                .data()[groupMapDisplayName],
                            style: MoreaTextStyle.lable,
                          ),
                          onTap: () => navigatetoprofile(
                              groupSnap.data.docs[index].data(),
                              groupID,
                              groupSnap.data.docs[index].id),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        );
                      },
                      separatorBuilder: (context, int index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: MoreaDivider());
                      },
                    ),
                    Container(
                      height: 20,
                    )
                  ],
                ),
              ),
            ));
          }
          return Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Niemand ist für diese Stufe Registriert",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        });
  }

  navigatetoprofile(
      Map<String, dynamic> customInfo, String groupID, String userID) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new ViewUserProfilePage(
            userID, groupID, customInfo, widget.moreaFire, widget.crud0)));
  }
}
