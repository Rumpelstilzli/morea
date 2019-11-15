import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morea/Widgets/standart/info.dart';
import 'package:morea/morea_strings.dart';
import 'package:morea/services/agenda.dart';
import 'package:morea/services/morea_firestore.dart';
import 'package:morea/services/crud.dart';
import 'package:morea/services/utilities/MiData.dart';
import 'package:morea/services/utilities/dwi_format.dart';



class EventAddPage extends StatefulWidget{
  EventAddPage({this.eventinfo, this.agendaModus, this.firestore, this.agenda});
  var eventinfo;
  AgendaModus agendaModus;
  final Firestore firestore;
  final Agenda agenda;

  @override
  State<StatefulWidget> createState() => EventAddPageState();
}
enum AgendaModus {
  lager,
  event,
  beides
}


class EventAddPageState extends State<EventAddPage>{
  MoreaFirebase moreafire;
  DWIFormat dwiFormat= new DWIFormat();
  CrudMedthods crud0;
  Agenda agenda;

 int value = 2;
 List<String> mitnehemen= ['Pfadihämpt'];
 final _addkey    = new GlobalKey<FormState>();
 final _changekey = new GlobalKey<FormState>();
 final _addEvent  = new GlobalKey<FormState>();
 final _addLager  = new GlobalKey<FormState>();

 String eventname = ' ', datum = 'Datum wählen', anfangzeit = 'Zeit wählen', anfangort = ' ', schlusszeit = 'Zeit wählen', schlussort = ' ', beschreibung = ' ', pfadiname = ' ', email = ' ';
 String lagername = ' ', datumvon = 'Datum wählen', datumbis = 'Datum wählen', lagerort = ' ';
 int order;
 List<Map<dynamic, dynamic>> subgroups;

 


 Map<String, dynamic> event, lager;
 Map<String, bool> goupCheckbox = new Map<String, bool> ();

  Map<String, bool> stufen ={
    'Biber' : false,
    'Wombat (Wölfe)' : false,
    'Nahani (Meitli)' : false,
    'Drason (Buebe)' : false,
    'Pios' : false,
};


 _addItem() {
   if(validateAndSave(_addkey)) {
     setState(() {
       value = value + 1;
     });
   }
 }
 bool validateAndSave(_key) {
   final form = _key.currentState;
   if (form.validate()) {
     form.save();
     return true;
   } else {
     return false;
   }
 }
 void groupCheckboxinit(List<Map> subgroups){
   for(Map groupMap in subgroups){
     this.goupCheckbox[groupMap[userMapgroupID]] = false;
   }
 }
 void eventHinzufuegen(_key){
   if(validateAndSave(_key)){
     Map<String, String> kontakt ={
       'Pfadiname' : pfadiname,
       'Email' : email
     };

     this.goupCheckbox.removeWhere((k,v) => v == false);
     event = {
       'Order': order,
       'Lager': false,
       'Event' : true,
       'Eventname': eventname,
       'Datum': datum,
       'Anfangszeit' : anfangzeit,
       'Anfangsort' : anfangort,
       'Schlusszeit' : schlusszeit,
       'Schlussort' : schlussort,
       'groupIDs' : this.goupCheckbox.keys.toList(),
       'Beschreibung': beschreibung,
       'Kontakt' :kontakt,
       'Mitnehmen' : mitnehemen
     };
     
     agenda.uploadtoAgenda(widget.eventinfo, event);
     
     showDialog(context: context, 
     child: new AlertDialog(
       title: new Text("Event wurde hinzugefügt"),
     )
     );
   }
 }

 void lagerHinzufuegen(_key){
   if(validateAndSave(_key)){
     Map<String, String> kontakt ={
       'Pfadiname' : pfadiname,
       'Email' : email
     };

     this.goupCheckbox.removeWhere((k,v) => v == false);
     lager = {
       'Order': order,
       'Lager': true,
       'Event' : false,
       'Lagername' : lagername,
       'Datum' : datumvon,
       'Datum bis' : datumbis,
       'Lagerort' : lagerort,
       'Anfangszeit' : anfangzeit,
       'Anfangsort' : anfangort,
       'Schlusszeit' : schlusszeit,
       'Schlussort' : schlussort,
       'groupIDs' : this.goupCheckbox.keys.toList(),
       'Beschreibung': beschreibung,
       'Kontakt' : kontakt,
       'Mitnehmen' : mitnehemen,
     };
     
     agenda.uploadtoAgenda(widget.eventinfo, lager);
     Navigator.pop(context);
   }
 }
 Future<Null> _selectDatum(BuildContext context)async{
   DateTime now = DateTime.now();
   final DateTime picked = await showDatePicker(
  context: context,
  initialDate: now,
  firstDate: now,
  lastDate: now.add(new Duration(days: 9999)),
);
if (picked != null && picked != DateTime.parse(datum))
   setState(() {
    datum = DateFormat('yyyy-MM-dd').format(picked);
    order = int.parse(DateFormat('yyyyMMdd').format(picked));
   });
 }
 Future<Null> _selectDatumvon(BuildContext context)async{
    DateTime now = DateTime.now();
   final DateTime picked = await showDatePicker(
  context: context,
  initialDate: now,
  firstDate: now,
  lastDate: now.add(new Duration(days: 9999)),
);
if (picked != null && picked != DateTime.parse(datumvon))
   setState(() {
    datumvon = DateFormat('yyyy-MM-dd').format(picked);
    order = int.parse(DateFormat('yyyyMMdd').format(picked));
   });
 }

 Future<Null> _selectDatumbis(BuildContext context)async{
   DateTime now = DateTime.now();
   final DateTime picked2 = await showDatePicker(
  context: context,
  initialDate: now,
  firstDate: now,
  lastDate: now.add(new Duration(days: 9999)));
  if (picked2 != null && picked2 != datumbis)
   setState(() {
    datumbis = DateFormat('yyyy-MM-dd').format(picked2);
   });
 }
 Future<Null> _selectAnfangszeit(BuildContext context)async{
   final TimeOfDay picked = await showTimePicker(
     initialTime: TimeOfDay.now(),
     context: context
   );
   if (picked != null && picked != anfangzeit)
   setState(() {
     anfangzeit = picked.hour.toString() + ':' + picked.minute.toString();
   });
 }
 Future<Null> _selectSchlusszeit(BuildContext context)async{
   final TimeOfDay picked = await showTimePicker(
     initialTime: TimeOfDay.now(),
     context: context
   );
   if (picked != null && picked != schlusszeit)
   setState(() {
     schlusszeit = picked.hour.toString() + ':' + picked.minute.toString();
   });
 }
 void lagerdelete()async{
   bool delete = false;
   await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            child: Text('Lager wirklich löschen?'),
          ),
          actions: <Widget>[
            new RaisedButton(
                child:  Text('Löschen', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  delete=true;
                  
                  Navigator.pop(context);
                }),
          ],
        ),
      
    );
    if(delete){
      //TODO alternative
      String name = dwiFormat.simplestring(widget.eventinfo['Datum']+widget.eventinfo['Lagername']);
      crud0.deletedocument('Stufen/Biber/Agenda', name);
      crud0.deletedocument('Stufen/WombatWlfe/Agenda', name);
      crud0.deletedocument('Stufen/NahaniMeitli/Agenda', name);
      crud0.deletedocument('Stufen/DrasonBuebe/Agenda', name);
      crud0.deletedocument('Stufen/Pios/Agenda', name);
      Navigator.pop(context);
    }
 }
 void eventdelete()async{
   bool delete = false;
   await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            child: Text('Event wirklich löschen?'),
          ),
          actions: <Widget>[
            new RaisedButton(
                child:  Text('Löschen', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  delete=true;
                  
                  Navigator.pop(context);
                }),
          ],
        ),
      
    );
    if(delete){
      //agenda.deleteAgendaEvent(groupID, eventID)
      String name = dwiFormat.simplestring(widget.eventinfo['Datum']+widget.eventinfo['Eventname']);
      crud0.deletedocument('Stufen/Biber/Agenda', name);
      crud0.deletedocument('Stufen/WombatWlfe/Agenda', name);
      crud0.deletedocument('Stufen/NahaniMeitli/Agenda', name);
      crud0.deletedocument('Stufen/DrasonBuebe/Agenda', name);
      crud0.deletedocument('Stufen/Pios/Agenda', name);
      Navigator.pop(context);
    }
 }
//TODO pass Abteilunggoup to this page
initSubgoup()async{
  Map<String,dynamic> data = (await crud0.getDocument(pathGroups, "1165")).data;
  this.subgroups = new List<Map<dynamic, dynamic>>.from(data[groupMapSubgroup]);
  this.groupCheckboxinit(this.subgroups);
  setState(() {
    
  });

}
  @override
  void initState() {
    datumvon    = widget.eventinfo['Datum'];
    datumbis    = widget.eventinfo['Datum bis'];
    datum       = widget.eventinfo['Datum'];

    anfangzeit  = widget.eventinfo['Anfangszeit'];
    schlusszeit = widget.eventinfo['Schlusszeit'];

    stufen      = Map.from(widget.eventinfo['Stufen']);
    mitnehemen  = List<String>.from(widget.eventinfo['Mitnehmen']);
    order       = widget.eventinfo['Order'];
    moreafire = new MoreaFirebase(widget.firestore);
    crud0 = new CrudMedthods(widget.firestore);
    agenda = new Agenda(widget.firestore);
    initSubgoup();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.agendaModus) {
      case AgendaModus.beides:
       return this.subgroups.isEmpty? moreaLoadingIndicator():
         DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text('zur Agenda hinzufügen'),
          backgroundColor: Color(0xff7a62ff),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Event'
              ),
              Tab(
                text:'Lager'
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            eventWidget(),
            lagerWidget()
          ],
        ),
      ),
    );
        break;
      case AgendaModus.event:
       return this.subgroups.isEmpty? moreaLoadingIndicator():
         Scaffold(
          appBar: new AppBar(
            title: Text(widget.eventinfo['Eventname'] + ' bearbeiten'),
            backgroundColor: Color(0xff7a62ff),
          ),
          body: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              eventWidget()
                               
                            ],
                          )
                        )
                      ),
                    );
                  },
                ),
          );
        
          break;
      case AgendaModus.lager:
       return this.subgroups.isEmpty? moreaLoadingIndicator():
       Scaffold(
        appBar: new AppBar(
          title: new Text(widget.eventinfo['Lagername'] + ' bearbeiten'),
          backgroundColor: Color(0xff7a62ff),
        ),
        body: lagerWidget()
        );
        break;

    }
    
  }
  void changemitnehmen(int index){
   String zwischensp;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => new Form(
        key: _changekey,
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(hintText: mitnehemen[index]),
                  onSaved: (value) => mitnehemen[index] = value,
                ),
              )
            ],
          ),
          actions: <Widget>[
            new RaisedButton(
                child: new Text('OK',style: TextStyle(color: Colors.white),),
                onPressed: () {
                  validateAndSave(_changekey);
                  Navigator.pop(context);
                }),
          ],
        ),
      )
    );
  }

  Widget lagerWidget(){
    return Container(
     child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Form(
                  key: _addLager,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Lagername'),
                              ),
                              Expanded(
                                flex: 7,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Lagername'],
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => lagername = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Datum von'),
                              ),
                              Expanded(
                                flex: 7,
                                child: RaisedButton(
                                  onPressed: () => _selectDatumvon(context),
                                  child: Text(datumvon),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Datum bis'),
                              ),
                              Expanded(
                                flex: 7,
                                child: RaisedButton(
                                  onPressed: () => _selectDatumbis(context),
                                  child: Text(datumbis),
                                )
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Lager Ort'),
                              ),
                              Expanded(
                                flex: 7,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Lagerort'],
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: false,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => lagerort = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Anfang'),
                              ),
                              Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () => _selectAnfangszeit(context),
                                  child: Text(anfangzeit),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Anfangsort'],
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: false,
                                      hintText: 'Ort'
                                  ),
                                  onSaved: (value) => anfangort = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Schluss'),
                              ),
                              Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () => _selectSchlusszeit(context),
                                  child: Text(schlusszeit),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Schlussort'],
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: false,
                                      hintText: 'Ort'
                                  ),
                                  onSaved: (value) => schlussort = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          height: (60 * goupCheckbox.length).toDouble(),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Betrifft'),
                              ),
                              Expanded(
                                  flex: 7,
                                  child: new ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: subgroups.map((Map<dynamic,dynamic> group){
                                      print("group: "+ group.toString());
                                      return new CheckboxListTile(
                                        title: new Text(group[groupMapgroupNickName]),
                                        value: goupCheckbox[group[userMapgroupID]],
                                          onChanged: (bool value){
                                            setState(() {
                                              goupCheckbox[group[userMapgroupID]] = value;
                                            });
                                          },
                                      );
                                    }).toList()
                                  )
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Beschreibung'),
                              ),
                              Expanded(
                                flex: 7,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Beschreibung'],
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: false,
                                  ),
                                  maxLines: 10,
                                  onSaved: (value) => beschreibung = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Kontakt'),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Kontakt']['Pfadiname'],
                                  decoration: new InputDecoration(
                                    hintText: 'Pfadiname',
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => pfadiname = value,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: new TextFormField(
                                   initialValue: widget.eventinfo['Kontakt']['Email'],
                                  decoration: new InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => email = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                        height: 400,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 20*mitnehemen.length.toDouble(),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Text('Mitnehmen'),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: ListView.builder(
                                          itemCount: this.mitnehemen.length,
                                          itemBuilder: (context, index) => this._buildRow(index)),
                                    )
                                  ],
                                ),
                              ),
                              Form(
                                key: _addkey,
                                  child: Container(
                                    child:  Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: new TextFormField(
                                              decoration: new InputDecoration(
                                                border: OutlineInputBorder(),
                                                filled: false,
                                              ),
                                              onSaved: (value) => mitnehemen.add(value)
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: new RaisedButton(
                                            child: new Text('Add',style: new TextStyle(fontSize: 15)),
                                            onPressed: () => _addItem(),
                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                            color: Color(0xff7a62ff),
                                            textColor: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: new RaisedButton(
                                  child: new Text('Speichern',style: TextStyle(fontSize: 25)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  color: Color(0xff7a62ff),
                                  textColor: Colors.white,
                                  onPressed: () => lagerHinzufuegen(_addLager),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: new FlatButton(
                                  child: new Text('Lager löschen',style: TextStyle(fontSize: 25, color: Colors.red)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: () => lagerdelete(),
                                ),
                              )
                            ],
                          ),
                      ),
                    ],
                  )
              )
              )
          );
        }
      )
      );
  }

  Widget eventWidget(){
    return new Container(
      height: 700,
     child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Form(
                  key: _addEvent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Event Name'),
                              ),
                              Expanded(
                                flex: 7,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Eventname'],
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => eventname = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Datum'),
                              ),
                              Expanded(
                                flex: 7,
                                child: RaisedButton(
                                  onPressed: () => _selectDatum(context),
                                  child: Text(datum),
                                )
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Anfang'),
                              ),
                              Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () => _selectAnfangszeit(context),
                                  child: Text(anfangzeit),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Anfangsort'],
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: false,
                                      hintText: 'Ort'
                                  ),
                                  onSaved: (value) => anfangort = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Schluss'),
                              ),
                              Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () => _selectSchlusszeit(context),
                                  child: Text(schlusszeit),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Schlussort'],
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: false,
                                      hintText: 'Ort'
                                  ),
                                  onSaved: (value) => schlussort = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          height: (60 * goupCheckbox.length).toDouble(),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Betrifft'),
                              ),
                              Expanded(
                                  flex: 7,
                                  child: new ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: subgroups.map((Map<dynamic,dynamic> group){
                                      print("group: "+ group.toString());
                                      return new CheckboxListTile(
                                        title: new Text(group[groupMapgroupNickName]),
                                        value: goupCheckbox[group[userMapgroupID]],
                                          onChanged: (bool value){
                                            setState(() {
                                              goupCheckbox[group[userMapgroupID]] = value;
                                            });
                                          },
                                      );
                                    }).toList()
                                  )
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Beschreibung'),
                              ),
                              Expanded(
                                flex: 7,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Beschreibung'],
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: false,
                                  ),
                                  maxLines: 10,
                                  onSaved: (value) => beschreibung = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text('Kontakt'),
                              ),
                              Expanded(
                                flex: 3,
                                child: new TextFormField(
                                  initialValue: widget.eventinfo['Kontakt']['Pfadiname'],
                                  decoration: new InputDecoration(
                                    hintText: 'Pfadiname',
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => pfadiname = value,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: new TextFormField(
                                   initialValue: widget.eventinfo['Kontakt']['Email'],
                                  decoration: new InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(),
                                    filled: false,

                                  ),
                                  onSaved: (value) => email = value,
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                        height: 400,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 20*mitnehemen.length.toDouble(),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Text('Mitnehmen'),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: ListView.builder(
                                          itemCount: this.mitnehemen.length,
                                          itemBuilder: (context, index) => this._buildRow(index)),
                                    )
                                  ],
                                ),
                              ),
                              Form(
                                key: _addkey,
                                  child: Container(
                                    child:  Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: new TextFormField(
                                              decoration: new InputDecoration(
                                                border: OutlineInputBorder(),
                                                filled: false,
                                              ),
                                              onSaved: (value) => mitnehemen.add(value)
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: new RaisedButton(
                                            child: new Text('Add',style: new TextStyle(fontSize: 15)),
                                            onPressed: () => _addItem(),
                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                            color: Color(0xff7a62ff),
                                            textColor: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: new RaisedButton(
                                  child: new Text('Speichern',style: TextStyle(fontSize: 25)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  color: Color(0xff7a62ff),
                                  textColor: Colors.white,
                                  onPressed: () => eventHinzufuegen(_addEvent),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: new FlatButton(
                                  child: new Text('Event löschen',style: TextStyle(fontSize: 25, color: Colors.red)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: () => eventdelete(),
                                ),
                              )
                            ],
                          ),
                      ),
                    ],
                  )
              )
              )
          );
        }
      )
      );
  }
 _buildRow(int index) {
   return new GestureDetector(
     onTap: () => changemitnehmen(index),
     child: Container(
         child: Row(
           children: <Widget>[
             Expanded(
                 flex: 1,
                 child: Icon(Icons.brightness_1,size: 10,)
             ),
             Expanded(
               flex: 2,
               child: Text(mitnehemen[index],
                   style: new TextStyle(fontSize: 15, )),
             )
           ],
         )
     ),
   );

 }
}