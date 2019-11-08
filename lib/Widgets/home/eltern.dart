import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:morea/services/utilities/MiData.dart';

Widget elternView(
  {@required Stream stream,
    @required List<String> subscribedGroups,
    @required Function navigation,
    @required Function(String, AsyncSnapshot) teleblitzAnzeigen,
    @required Widget Function(String) anmeldebutton}
){
  return DefaultTabController(
            length: subscribedGroups.length,
            child: Scaffold(
              appBar: new AppBar(
                title: new Text('Teleblitz'),
                backgroundColor: Color(0xff7a62ff),
                bottom: TabBar(tabs:  getTabList(subscribedGroups)),
              ),
              drawer: new Drawer(
                child: new ListView(children: navigation()),
              ),
              body: TabBarView(children: getTeleblizWidgetList(subscribedGroups, stream, teleblitzAnzeigen, anmeldebutton)),
            ));
}
List<Widget> getTeleblizWidgetList(
  List<String> subscribedGroups, Stream stream, Function(String, AsyncSnapshot) teleblitzAnzeigen, Function anmeldebutton) {
   List<Widget> listTeleblitzWidget = new List<Widget>();
   for (String groupID in subscribedGroups) {
     listTeleblitzWidget.add(getLayoutBuilderWidget(groupID, stream, teleblitzAnzeigen, anmeldebutton));
   }
  return listTeleblitzWidget;
}

Widget getLayoutBuilderWidget(
    String groupID, Stream stream, Function(String, AsyncSnapshot) teleblitzAnzeigen, Function(String) anmeldebutton) {
  return StreamBuilder(
    stream: stream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return SingleChildScrollView(
                child: Column(
              key: ObjectKey(teleblitzAnzeigen(groupID, snapshot)),
              children: <Widget>[
                teleblitzAnzeigen(groupID, snapshot),
                anmeldebutton(groupID)
              ],
            ),
      );
    },
  );
}
List<Widget> getTabList(List<String> subscribedGroups) {
  List<Widget> tabList = [];
  for (String groupID in subscribedGroups) {
    tabList.add(new Tab(
      text: convMiDatatoWebflow(groupID),
    ));
  }
  return tabList;
}
