import 'package:flutter/material.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/services/agenda.dart' as prefix0;
import 'package:morea/services/crud.dart';
import 'package:morea/services/utilities/dwi_format.dart';
import 'Agenda_Eventadd_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_Lager_page.dart';
import 'view_Event_page.dart';
import 'package:morea/services/morea_firestore.dart';

class AgendaState extends StatefulWidget {
  AgendaState({this.firestore, this.moreaFire, this.onSignedOut});
  final MoreaFirebase moreaFire;
  final Firestore firestore;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _AgendaStatePage();
}

class _AgendaStatePage extends State<AgendaState> {
  MoreaFirebase moreafire;
  DWIFormat dwiformat = new DWIFormat();
  CrudMedthods crud0;
  prefix0.Agenda agenda;
  String pos = 'Teilnehmer';
  Stream<List> sLagenda;
  Map stufen ={
    'Biber':false,
    'Pios':false,
    'Nahani (Meitli)':false,
    'Drason (Buebe)':false,
    'Wombat (Wölfe)':false,
  };
  Map kontakt = {'Email': '', 'Pfadiname': ''};
  List mitnehmen = ['Pfadihämpt'];

  Map<String, dynamic> quickfix = {
    'Eventname': '',
    'Datum': 'Datum wählen',
    'Datum bis': 'Datum wählen',
    'Anfangszeit': 'von',
    'Anfangsort': '',
    'Schlussort': '',
    'Schlusszeit': 'bis',
    'Stufen': '',
    'Beschreiben': '',
    'Kontakt': '',
    'Mitnehmen': '',
    'Lagername': ''
  };
 
    

 Stream<List> _getAgenda(groupID){
   return agenda.getAgendaOverview(groupID);
 
 }

  altevernichten(_agedaTitledatum,groupID, Map<String, dynamic> event){
    
    DateTime _agdatum = DateTime.parse(_agedaTitledatum);
    DateTime now = DateTime.now();

    if(_agdatum.difference(now).inDays< 0){
      agenda.deleteAgendaEvent(event);
    }
  }

  bool istLeiter() {
    if (pos == 'Leiter') {
      return true;
    } else {
      return false;
    }
  }

  routetoAddevent() {
    if (istLeiter()) {
      Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => EventAddPage(eventinfo: quickfix, agendaModus: AgendaModus.beides, firestore: widget.firestore,)));
    }
  }

  @override
  void initState() {
    moreafire = widget.moreaFire;
    
    agenda = new prefix0.Agenda(widget.firestore);

    //_getAgenda("3776");
    quickfix['Stufen'] = stufen;
    quickfix['Kontakt'] = kontakt;
    quickfix['Mitnehmen']= mitnehmen;
    pos= moreafire.getUserMap['Pos'];

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(istLeiter()){
      return new Container(
        child: new Scaffold(
      appBar: new AppBar(
        title: new Text('Agenda'),
        backgroundColor: Color(0xff7a62ff),
      ),
      body: Agenda(moreafire.getUserMap[userMapgroupID]),
      floatingActionButton: Opacity(
        opacity: istLeiter() ? 1.0 : 0.0 ,
        child: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor:  Color(0xff7a62ff),
          onPressed: () => routetoAddevent()),
      ),
    ));
    }else{
      return new Container(
        child: new Scaffold(
      appBar: new AppBar(
        title: new Text('Agenda'),
        backgroundColor: Color(0xff7a62ff),
      ),
      body: Agenda(moreafire.getUserMap[userMapgroupID]),
    ));
    }
  }
  viewLager(BuildContext context, Map<String,dynamic> agendaTitle)async{
    Map<String, dynamic> info = (await agenda.getAgendaTitle(agendaTitle[groupMapEventID])).data;
    Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new ViewLagerPageState(info: info, pos:moreafire.getUserMap['Pos'])));
  }
  viewEvent(BuildContext context, Map<String,dynamic> agendaTitle)async{
    Map<String, dynamic> info = (await agenda.getAgendaTitle(agendaTitle[groupMapEventID])).data;
    Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new ViewEventPageState(info: info ,pos: moreafire.getUserMap['Pos'], 
                                  )));
  }

  Widget Agenda(String groupID) {
    return StreamBuilder(
        stream: _getAgenda(groupID).asBroadcastStream(),
        builder: (context, AsyncSnapshot<List> slagenda) {
          if (!slagenda.hasData) return Center(child:Text('Laden... einen Moment bitte', style: TextStyle(fontSize: 20),));
          if(slagenda.data.length==0)return Center(child:Text('Keine Events/Lager eingetragen', style: TextStyle(fontSize: 20),));
          return ListView.builder(
              itemCount: slagenda.data.length,
              itemBuilder: (context, int index) {
                final Map<String, dynamic> _info = Map<String, dynamic>.from(slagenda.data[index]);
                altevernichten(_info['Datum'], groupID, _info);
                
                if(_info['Event']){
                    return new ListTile(
                    title: Container(
                        height: 50.0,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center, //
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black, width: 2),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          boxShadow:  [
                          BoxShadow(
                
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(3, 3),
                          blurRadius: 40)
                          ],
                        ),
                        child: new Row(
                          children: <Widget>[
                            Expanded(flex: 3, child: new Text(_info['Datum'].toString())),
                            Expanded(
                              flex: 5,
                              child: new Text(_info['Eventname'].toString()),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox()
                            )
                          ],
                        )),
                        onTap: () => viewEvent(context, _info) 
                        );
                }else if(_info['Lager']){
                   return new ListTile(
                    title: Container(
                        height: 50.0,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center, //
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black, width: 2),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        child: new Row(
                          children: <Widget>[
                            Expanded(flex: 3, child: new Text(_info['Datum'].toString())),
                            Expanded(
                              flex: 5,
                              child: new Text(_info['Lagername'].toString()),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center, //
                                decoration: new BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                child: new Text('Lager'),
                              ),
                            )
                          ],
                        )),
                        onTap: () => viewLager(context, _info)
                        );
                }else{
                  return SizedBox();
                }
               
              });
        });
  }

  void _signedOut() async {
    try {
      if(Navigator.of(context).canPop()){
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      }
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
