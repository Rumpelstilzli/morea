
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:expandable/expandable.dart';
// generiert mit https://datenschutz-generator.de/
abstract class BaseDatenschutz{
  Future<void> moreaDatenschutzerklaerung(BuildContext context);
}


class Datenschutz implements BaseDatenschutz{
  static Datenschutz _instance;
  factory Datenschutz() => _instance ??= new Datenschutz._();

  Datenschutz._();
Textdatenschutz textdatenschutz = new Textdatenschutz();
bool akzeptiert = false;
bool expand = false;
void expandpressed(){
  expand = !expand;
  print(expand);
}

  Future<void> moreaDatenschutzerklaerung(BuildContext context)async{
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(15),
        child: new Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Text('Datenschutzerklährung',
               style: new TextStyle(
                 fontSize: 25,
                  color: Color(0xff7a62ff),
                  fontWeight: FontWeight.bold
                  ), ),
            ),
            Expanded(
              flex: 1,
              child: new Divider(),
            ),
            Expanded(
              flex: 100,
              child: Scrollbar(
                child: new SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                    ExpandablePanel(
                      header: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              //SizedBox(width: 20,),
                              Icon(Icons.info_outline, color: Colors.red,),
                              Text('Das wichtigste in Kurze', 
                              style: new TextStyle(fontSize: 20, color: Colors.red),),
                            ]
                          )
                        ),
                      expanded: Column(
                        children: <Widget>[
                          new Text('Wir sind Gegner der Verwischung des Datenschutzes durch Juristendeutsch. Deshalb möchten wir transparent sein, weshalb wir eine Dateschutzerklährung benötigen. '),
                          SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               Column(
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Icon(Icons.brightness_1, size: 5,),
                                ],
                              ),
                              Container(
                                width: 340,
                                child: Text(' Wir erheben sensible Daten bei der Registration (deine Registrationsdaten). Dies benötig deine Einwilligung.'),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Icon(Icons.brightness_1, size: 5,),
                                ],
                              ),
                              Container(
                                width: 340,
                                child:  Text(' Weiter verwenden wir ein Service namens Firebase, über diesen Service lauft unser Log-in-System und unser Serverbackend, den wir brauchen um Inhalte wie z. B. Aktuelle Informationen, Lager oder Teleblitze anzeigen zu können.'),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          new Text('Wir verwenden keine Cookies und deine Daten werden nur für die Pfadi verwendet. Bei Fragen über den Datenschutz wende dich an Jarvis.'),
                          SizedBox(height: 5,),
                          new Text('Bei dem Drücken des Knopfes Akzeptieren, akzeptierst du die Datenschutzbestimmungen, dies ist nicht rechtsfähig und dient nur als überblick.')
                        ],
                      ),
                      tapHeaderToExpand: true,
                      hasIcon: true,
                    ),
                    new Divider(),
                    new Html(data: textdatenschutz.moreaV01,)
                  ],
                ),
              ),
              )
            ),
            Expanded(
              flex: 1,
              child: new Divider(),
            ),
            Expanded(
              flex: 8,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    child:new FlatButton(
                      child: const Text('Ablehnen', style:  TextStyle(color: Color(0xff7a62ff))),
                      onPressed: () {
                     Navigator.pop(context);
                      }),
                  ),
                  Expanded(
                    child: new RaisedButton(
                  child: const Text('Akzeptieren',style: TextStyle(color: Colors.white),),
                  color: Color(0xff7a62ff),
                  onPressed: () {
                    akzeptiert = true;
                    Navigator.pop(context);
                    
                  }),
                  )
                ],
              ),
            )
          ],
        ),
        )
      ),
      ) 
    );
  }
}

class Textdatenschutz{
  String moreaV01Info = '<p>Wir sind Gegner der Verwaschung des Datenschutzes durch Juristendeutsch. Deshalb möchten wir tranparent sein, weshalb wir eine Dateschutzerklährung benötigen.</p><ul><li>Wir erheben sensible Daten bei der Registration (deine Registrationsdaten). Dies benötig deine Einwiligung.</li><li>Weiter verwenden wir ein Service namens Firebase, über diesen Service lauft unser Loginsystem und unser Serverbackend, den wir brauchen um Inhalte wie z.B. Akutuelle Informationen, Lager oder Teleblitze anzeigen zu können.</li> </ul><p>Wir verwenden keine Cookies und deine  Daten werden nur für die Pfadi verwendet.\nBei Fragen zu betrefflich Datenschutz wende dich an Jarvis.\nBei dem Drücken des Knopfes Akzeptieren, akzeptierst du die Datenschutzbestimmungen, dies hier ist nicht rechtsfähig und dient nur als überblick.</p>';

  String moreaV01 = '</h3><p>Diese Datenschutzerklärung klärt Sie über die Art, den Umfang und Zweck der Verarbeitung von personenbezogenen Daten (nachfolgend kurz „Daten“) im Rahmen der Erbringung unserer Leistungen sowie innerhalb unseres Onlineangebotes und der mit ihm verbundenen Webseiten, Funktionen und Inhalte sowie externen Onlinepräsenzen, wie z.B. unser Social Media Profile auf (nachfolgend gemeinsam bezeichnet als „Onlineangebot“). Im Hinblick auf die verwendeten Begrifflichkeiten, wie z.B. „Verarbeitung“ oder „Verantwortlicher“ verweisen wir auf die Definitionen im Art. 4 der Datenschutzgrundverordnung (DSGVO). <br><br></p><h3 id="dsg-general-controller">Verantwortlicher</h3><p><span class="tsmcontroller">David Wild v/o Jarvis / Pfadi Morea<br>Magdalenenstrasse 22<br>8050 Zürich<br>Schweiz</span></p><h3 id="dsg-general-datatype">Arten der verarbeiteten Daten</h3><p>-	Bestandsdaten (z.B., Personen-Stammdaten, Namen oder Adressen).<br>-	Kontaktdaten (z.B., E-Mail, Telefonnummern).<br>-	Inhaltsdaten (z.B., Texteingaben, Fotografien, Videos).<br>-	Nutzungsdaten (z.B., besuchte Webseiten, Interesse an Inhalten, Zugriffszeiten).<br>-	Meta-/Kommunikationsdaten (z.B., Geräte-Informationen, IP-Adressen).</p><h3 id="dsg-general-datasubjects">Kategorien betroffener Personen</h3><p>Besucher und Nutzer des Onlineangebotes (Nachfolgend bezeichnen wir die betroffenen Personen zusammenfassend auch als „Nutzer“).<br></p><h3 id="dsg-general-purpose">Zweck der Verarbeitung</h3><p>-	Zurverfügungstellung des Onlineangebotes, seiner Funktionen und  Inhalte.<br>-	Beantwortung von Kontaktanfragen und Kommunikation mit Nutzern.<br>-	Sicherheitsmaßnahmen.<br>-	Reichweitenmessung/Marketing<br><span class="tsmcom"></span></p><h3 id="dsg-general-terms">Verwendete Begrifflichkeiten </h3><p>„Personenbezogene Daten“ sind alle Informationen, die sich auf eine identifizierte oder identifizierbare natürliche Person (im Folgenden „betroffene Person“) beziehen; als identifizierbar wird eine natürliche Person angesehen, die direkt oder indirekt, insbesondere mittels Zuordnung zu einer Kennung wie einem Namen, zu einer Kennnummer, zu Standortdaten, zu einer Online-Kennung (z.B. Cookie) oder zu einem oder mehreren besonderen Merkmalen identifiziert werden kann, die Ausdruck der physischen, physiologischen, genetischen, psychischen, wirtschaftlichen, kulturellen oder sozialen Identität dieser natürlichen Person sind.<br><br>„Verarbeitung“ ist jeder mit oder ohne Hilfe automatisierter Verfahren ausgeführte Vorgang oder jede solche Vorgangsreihe im Zusammenhang mit personenbezogenen Daten. Der Begriff reicht weit und umfasst praktisch jeden Umgang mit Daten.<br><br>„Pseudonymisierung“ die Verarbeitung personenbezogener Daten in einer Weise, dass die personenbezogenen Daten ohne Hinzuziehung zusätzlicher Informationen nicht mehr einer spezifischen betroffenen Person zugeordnet werden können, sofern diese zusätzlichen Informationen gesondert aufbewahrt werden und technischen und organisatorischen Maßnahmen unterliegen, die gewährleisten, dass die personenbezogenen Daten nicht einer identifizierten oder identifizierbaren natürlichen Person zugewiesen werden.<br><br>„Profiling“ jede Art der automatisierten Verarbeitung personenbezogener Daten, die darin besteht, dass diese personenbezogenen Daten verwendet werden, um bestimmte persönliche Aspekte, die sich auf eine natürliche Person beziehen, zu bewerten, insbesondere um Aspekte bezüglich Arbeitsleistung, wirtschaftliche Lage, Gesundheit, persönliche Vorlieben, Interessen, Zuverlässigkeit, Verhalten, Aufenthaltsort oder Ortswechsel dieser natürlichen Person zu analysieren oder vorherzusagen.<br><br>Als „Verantwortlicher“ wird die natürliche oder juristische Person, Behörde, Einrichtung oder andere Stelle, die allein oder gemeinsam mit anderen über die Zwecke und Mittel der Verarbeitung von personenbezogenen Daten entscheidet, bezeichnet.<br><br>„Auftragsverarbeiter“ eine natürliche oder juristische Person, Behörde, Einrichtung oder andere Stelle, die personenbezogene Daten im Auftrag des Verantwortlichen verarbeitet.<br></p><h3 id="dsg-general-legalbasis">Maßgebliche Rechtsgrundlagen</h3><p>Nach Maßgabe des Art. 13 DSGVO teilen wir Ihnen die Rechtsgrundlagen unserer Datenverarbeitungen mit.  Für Nutzer aus dem Geltungsbereich der Datenschutzgrundverordnung (DSGVO), d.h. der EU und des EWG gilt, sofern die Rechtsgrundlage in der Datenschutzerklärung nicht genannt wird, Folgendes: <br>Die Rechtsgrundlage für die Einholung von Einwilligungen ist Art. 6 Abs. 1 lit. a und Art. 7 DSGVO;<br>Die Rechtsgrundlage für die Verarbeitung zur Erfüllung unserer Leistungen und Durchführung vertraglicher Maßnahmen sowie Beantwortung von Anfragen ist Art. 6 Abs. 1 lit. b DSGVO;<br>Die Rechtsgrundlage für die Verarbeitung zur Erfüllung unserer rechtlichen Verpflichtungen ist Art. 6 Abs. 1 lit. c DSGVO;<br>Für den Fall, dass lebenswichtige Interessen der betroffenen Person oder einer anderen natürlichen Person eine Verarbeitung personenbezogener Daten erforderlich machen, dient Art. 6 Abs. 1 lit. d DSGVO als Rechtsgrundlage.<br>Die Rechtsgrundlage für die erforderliche Verarbeitung zur Wahrnehmung einer Aufgabe, die im öffentlichen Interesse liegt oder in Ausübung öffentlicher Gewalt erfolgt, die dem Verantwortlichen übertragen wurde ist Art. 6 Abs. 1 lit. e DSGVO. <br>Die Rechtsgrundlage für die Verarbeitung zur Wahrung unserer berechtigten Interessen ist Art. 6 Abs. 1 lit. f DSGVO. <br>Die Verarbeitung von Daten zu anderen Zwecken als denen, zu denen sie erhoben wurden, bestimmt sich nach den Vorgaben des Art 6 Abs. 4 DSGVO. <br>Die Verarbeitung von besonderen Kategorien von Daten (entsprechend Art. 9 Abs. 1 DSGVO) bestimmt sich nach den Vorgaben des Art. 9 Abs. 2 DSGVO. <br></p><h3 id="dsg-general-securitymeasures">Sicherheitsmaßnahmen</h3><p>Wir treffen nach Maßgabe der gesetzlichen Vorgabenunter Berücksichtigung des Stands der Technik, der Implementierungskosten und der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung sowie der unterschiedlichen Eintrittswahrscheinlichkeit und Schwere des Risikos für die Rechte und Freiheiten natürlicher Personen, geeignete technische und organisatorische Maßnahmen, um ein dem Risiko angemessenes Schutzniveau zu gewährleisten.<br><br>Zu den Maßnahmen gehören insbesondere die Sicherung der Vertraulichkeit, Integrität und Verfügbarkeit von Daten durch Kontrolle des physischen Zugangs zu den Daten, als auch des sie betreffenden Zugriffs, der Eingabe, Weitergabe, der Sicherung der Verfügbarkeit und ihrer Trennung. Des Weiteren haben wir Verfahren eingerichtet, die eine Wahrnehmung von Betroffenenrechten, Löschung von Daten und Reaktion auf Gefährdung der Daten gewährleisten. Ferner berücksichtigen wir den Schutz personenbezogener Daten bereits bei der Entwicklung, bzw. Auswahl von Hardware, Software sowie Verfahren, entsprechend dem Prinzip des Datenschutzes durch Technikgestaltung und durch datenschutzfreundliche Voreinstellungen.<br></p><h3 id="dsg-general-coprocessing">Zusammenarbeit mit Auftragsverarbeitern, gemeinsam Verantwortlichen und Dritten</h3><p>Sofern wir im Rahmen unserer Verarbeitung Daten gegenüber anderen Personen und Unternehmen (Auftragsverarbeitern, gemeinsam Verantwortlichen oder Dritten) offenbaren, sie an diese übermitteln oder ihnen sonst Zugriff auf die Daten gewähren, erfolgt dies nur auf Grundlage einer gesetzlichen Erlaubnis (z.B. wenn eine Übermittlung der Daten an Dritte, wie an Zahlungsdienstleister, zur Vertragserfüllung erforderlich ist), Nutzer eingewilligt haben, eine rechtliche Verpflichtung dies vorsieht oder auf Grundlage unserer berechtigten Interessen (z.B. beim Einsatz von Beauftragten, Webhostern, etc.). <br><br>Sofern wir Daten anderen Unternehmen unserer Unternehmensgruppe offenbaren, übermitteln oder ihnen sonst den Zugriff gewähren, erfolgt dies insbesondere zu administrativen Zwecken als berechtigtes Interesse und darüberhinausgehend auf einer den gesetzlichen Vorgaben entsprechenden Grundlage. <br></p><h3 id="dsg-general-thirdparty">Übermittlungen in Drittländer</h3><p>Sofern wir Daten in einem Drittland (d.h. außerhalb der Europäischen Union (EU), des Europäischen Wirtschaftsraums (EWR) oder der Schweizer Eidgenossenschaft) verarbeiten oder dies im Rahmen der Inanspruchnahme von Diensten Dritter oder Offenlegung, bzw. Übermittlung von Daten an andere Personen oder Unternehmen geschieht, erfolgt dies nur, wenn es zur Erfüllung unserer (vor)vertraglichen Pflichten, auf Grundlage Ihrer Einwilligung, aufgrund einer rechtlichen Verpflichtung oder auf Grundlage unserer berechtigten Interessen geschieht. Vorbehaltlich ausdrücklicher Einwilligung oder vertraglich erforderlicher Übermittlung, verarbeiten oder lassen wir die Daten nur in Drittländern mit einem anerkannten Datenschutzniveau, zu denen die unter dem "Privacy-Shield" zertifizierten US-Verarbeiter gehören oder auf Grundlage besonderer Garantien, wie z.B. vertraglicher Verpflichtung durch sogenannte Standardschutzklauseln der EU-Kommission, dem Vorliegen von Zertifizierungen oder verbindlichen internen Datenschutzvorschriften verarbeiten (Art. 44 bis 49 DSGVO, <a href="https://ec.europa.eu/info/law/law-topic/data-protection/data-transfers-outside-eu_de" target="blank">Informationsseite der EU-Kommission</a>).</p><h3 id="dsg-general-rightssubject">Rechte der betroffenen Personen</h3><p>Sie haben das Recht, eine Bestätigung darüber zu verlangen, ob betreffende Daten verarbeitet werden und auf Auskunft über diese Daten sowie auf weitere Informationen und Kopie der Daten entsprechend den gesetzlichen Vorgaben.<br><br>Sie haben entsprechend. den gesetzlichen Vorgaben das Recht, die Vervollständigung der Sie betreffenden Daten oder die Berichtigung der Sie betreffenden unrichtigen Daten zu verlangen.<br><br>Sie haben nach Maßgabe der gesetzlichen Vorgaben das Recht zu verlangen, dass betreffende Daten unverzüglich gelöscht werden, bzw. alternativ nach Maßgabe der gesetzlichen Vorgaben eine Einschränkung der Verarbeitung der Daten zu verlangen.<br><br>Sie haben das Recht zu verlangen, dass die Sie betreffenden Daten, die Sie uns bereitgestellt haben nach Maßgabe der gesetzlichen Vorgaben zu erhalten und deren Übermittlung an andere Verantwortliche zu fordern. <br><br>Sie haben ferner nach Maßgabe der gesetzlichen Vorgaben das Recht, eine Beschwerde bei der zuständigen Aufsichtsbehörde einzureichen.<br></p><h3 id="dsg-general-revokeconsent">Widerrufsrecht</h3><p>Sie haben das Recht, erteilte Einwilligungen mit Wirkung für die Zukunft zu widerrufen.</p><h3 id="dsg-general-object">Widerspruchsrecht</h3><p><strong>Sie können der künftigen Verarbeitung der Sie betreffenden Daten nach Maßgabe der gesetzlichen Vorgaben jederzeit widersprechen. Der Widerspruch kann insbesondere gegen die Verarbeitung für Zwecke der Direktwerbung erfolgen.</strong></p><h3 id="dsg-general-cookies">Cookies und Widerspruchsrecht bei Direktwerbung</h3><p>Als „Cookies“ werden kleine Dateien bezeichnet, die auf Rechnern der Nutzer gespeichert werden. Innerhalb der Cookies können unterschiedliche Angaben gespeichert werden. Ein Cookie dient primär dazu, die Angaben zu einem Nutzer (bzw. dem Gerät auf dem das Cookie gespeichert ist) während oder auch nach seinem Besuch innerhalb eines Onlineangebotes zu speichern. Als temporäre Cookies, bzw. „Session-Cookies“ oder „transiente Cookies“, werden Cookies bezeichnet, die gelöscht werden, nachdem ein Nutzer ein Onlineangebot verlässt und seinen Browser schließt. In einem solchen Cookie kann z.B. der Inhalt eines Warenkorbs in einem Onlineshop oder ein Login-Status gespeichert werden. Als „permanent“ oder „persistent“ werden Cookies bezeichnet, die auch nach dem Schließen des Browsers gespeichert bleiben. So kann z.B. der Login-Status gespeichert werden, wenn die Nutzer diese nach mehreren Tagen aufsuchen. Ebenso können in einem solchen Cookie die Interessen der Nutzer gespeichert werden, die für Reichweitenmessung oder Marketingzwecke verwendet werden. Als „Third-Party-Cookie“ werden Cookies bezeichnet, die von anderen Anbietern als dem Verantwortlichen, der das Onlineangebot betreibt, angeboten werden (andernfalls, wenn es nur dessen Cookies sind spricht man von „First-Party Cookies“).<br><br>Wir können temporäre und permanente Cookies einsetzen und klären hierüber im Rahmen unserer Datenschutzerklärung auf.<br><br>Sofern wir die Nutzer um eine Einwilligung in den Einsatz von Cookies bitten (z.B. im Rahmen einer Cookie-Einwilligung), ist die Rechtsgrundlage dieser Verarbeitung Art. 6 Abs. 1 lit. a. DSGVO. Ansonsten werden die personenbezogenen Cookies der Nutzer entsprechend den nachfolgenden Erläuterungen im Rahmen dieser Datenschutzerklärung auf Grundlage unserer berechtigten Interessen (d.h. Interesse an der Analyse, Optimierung und wirtschaftlichem Betrieb unseres Onlineangebotes im Sinne des Art. 6 Abs. 1 lit. f. DSGVO) oder sofern der Einsatz von Cookies zur Erbringung unserer vertragsbezogenen Leistungen erforderlich ist, gem. Art. 6 Abs. 1 lit. b. DSGVO, bzw. sofern der Einsatz von Cookies für die Wahrnehmung einer Aufgabe, die im öffentlichen Interesse liegt erforderlich ist oder in Ausübung öffentlicher Gewalt erfolgt, gem. Art. 6 Abs. 1 lit. e. DSGVO, verarbeitet.<br><br>Falls die Nutzer nicht möchten, dass Cookies auf ihrem Rechner gespeichert werden, werden sie gebeten die entsprechende Option in den Systemeinstellungen ihres Browsers zu deaktivieren. Gespeicherte Cookies können in den Systemeinstellungen des Browsers gelöscht werden. Der Ausschluss von Cookies kann zu Funktionseinschränkungen dieses Onlineangebotes führen.<br><br>Ein genereller Widerspruch gegen den Einsatz der zu Zwecken des Onlinemarketing eingesetzten Cookies kann bei einer Vielzahl der Dienste, vor allem im Fall des Trackings, über die US-amerikanische Seite <a href="http://www.aboutads.info/choices/">http://www.aboutads.info/choices/</a> oder die EU-Seite <a href="http://www.youronlinechoices.com/">http://www.youronlinechoices.com/</a> erklärt werden. Des Weiteren kann die Speicherung von Cookies mittels deren Abschaltung in den Einstellungen des Browsers erreicht werden. Bitte beachten Sie, dass dann gegebenenfalls nicht alle Funktionen dieses Onlineangebotes genutzt werden können.</p><h3 id="dsg-general-erasure">Löschung von Daten</h3><p>Die von uns verarbeiteten Daten werden nach Maßgabe der gesetzlichen Vorgaben gelöscht oder in ihrer Verarbeitung eingeschränkt. Sofern nicht im Rahmen dieser Datenschutzerklärung ausdrücklich angegeben, werden die bei uns gespeicherten Daten gelöscht, sobald sie für ihre Zweckbestimmung nicht mehr erforderlich sind und der Löschung keine gesetzlichen Aufbewahrungspflichten entgegenstehen. <br><br>Sofern die Daten nicht gelöscht werden, weil sie für andere und gesetzlich zulässige Zwecke erforderlich sind, wird deren Verarbeitung eingeschränkt. D.h. die Daten werden gesperrt und nicht für andere Zwecke verarbeitet. Das gilt z.B. für Daten, die aus handels- oder steuerrechtlichen Gründen aufbewahrt werden müssen.</p><h3 id="dsg-general-changes">Änderungen und Aktualisierungen der Datenschutzerklärung</h3><p>Wir bitten Sie sich regelmäßig über den Inhalt unserer Datenschutzerklärung zu informieren. Wir passen die Datenschutzerklärung an, sobald die Änderungen der von uns durchgeführten Datenverarbeitungen dies erforderlich machen. Wir informieren Sie, sobald durch die Änderungen eine Mitwirkungshandlung Ihrerseits (z.B. Einwilligung) oder eine sonstige individuelle Benachrichtigung erforderlich wird.</p><p></p><h3 id="dsg-organisation">  Erbringung unserer satzungs- und geschäftsgemäßen Leistungen</h3><p></p><p><span class="ts-muster-content">Wir verarbeiten die Daten unserer Mitglieder, Unterstützer, Interessenten, Kunden oder sonstiger Personen entsprechend Art. 6 Abs. 1 lit. b. DSGVO, sofern wir ihnen gegenüber vertragliche Leistungen anbieten oder im Rahmen bestehender geschäftlicher Beziehung, z.B. gegenüber Mitgliedern, tätig werden oder selbst Empfänger von Leistungen und Zuwendungen sind. Im Übrigen verarbeiten wir die Daten betroffener Personen gem. Art. 6 Abs. 1 lit. f. DSGVO auf Grundlage unserer berechtigten Interessen, z.B. wenn es sich um administrative Aufgaben oder Öffentlichkeitsarbeit handelt.<br><br>Die hierbei verarbeiteten Daten, die Art, der Umfang und der Zweck und die Erforderlichkeit ihrer Verarbeitung bestimmen sich nach dem zugrundeliegenden Vertragsverhältnis. Dazu gehören grundsätzlich Bestands- und Stammdaten der Personen (z.B., Name, Adresse, etc.), als auch die Kontaktdaten (z.B., E-Mailadresse, Telefon, etc.), die Vertragsdaten (z.B., in Anspruch genommene Leistungen, mitgeteilte Inhalte und Informationen, Namen von Kontaktpersonen) und sofern wir zahlungspflichtige Leistungen oder Produkte anbieten, Zahlungsdaten (z.B., Bankverbindung, Zahlungshistorie, etc.).<br><br>Wir löschen Daten, die zur Erbringung unserer satzungs- und geschäftsmäßigen Zwecke nicht mehr erforderlich sind. Dies bestimmt sich entsprechend der jeweiligen Aufgaben und vertraglichen Beziehungen. Im Fall geschäftlicher Verarbeitung bewahren wir die Daten so lange auf, wie sie zur Geschäftsabwicklung, als auch im Hinblick auf etwaige Gewährleistungs- oder Haftungspflichten relevant sein können. Die Erforderlichkeit der Aufbewahrung der Daten wird alle drei Jahre überprüft; im Übrigen gelten die gesetzlichen Aufbewahrungspflichten.</span></p><p></p><h3 id="dsg-registration">Registrierfunktion</h3><p></p><p><span class="ts-muster-content">Nutzer können ein Nutzerkonto anlegen. Im Rahmen der Registrierung werden die erforderlichen Pflichtangaben den Nutzern mitgeteilt und auf Grundlage des Art. 6 Abs. 1 lit. b DSGVO zu Zwecken der Bereitstellung des Nutzerkontos verarbeitet. Zu den verarbeiteten Daten gehören insbesondere die Login-Informationen (Name, Passwort sowie eine E-Mailadresse). Die im Rahmen der Registrierung eingegebenen Daten werden für die Zwecke der Nutzung des Nutzerkontos und dessen Zwecks verwendet. <br><br>Die Nutzer können über Informationen, die für deren Nutzerkonto relevant sind, wie z.B. technische Änderungen, per E-Mail informiert werden. Wenn Nutzer ihr Nutzerkonto gekündigt haben, werden deren Daten im Hinblick auf das Nutzerkonto, vorbehaltlich einer gesetzlichen Aufbewahrungspflicht, gelöscht. Es obliegt den Nutzern, ihre Daten bei erfolgter Kündigung vor dem Vertragsende zu sichern. Wir sind berechtigt, sämtliche während der Vertragsdauer gespeicherten Daten des Nutzers unwiederbringlich zu löschen.<br><br>Im Rahmen der Inanspruchnahme unserer Registrierungs- und Anmeldefunktionen sowie der Nutzung des Nutzerkontos, speichern wir die IP-Adresse und den Zeitpunkt der jeweiligen Nutzerhandlung. Die Speicherung erfolgt auf Grundlage unserer berechtigten Interessen, als auch der Nutzer an Schutz vor Missbrauch und sonstiger unbefugter Nutzung. Eine Weitergabe dieser Daten an Dritte erfolgt grundsätzlich nicht, außer sie ist zur Verfolgung unserer Ansprüche erforderlich oder es besteht hierzu besteht eine gesetzliche Verpflichtung gem. Art. 6 Abs. 1 lit. c. DSGVO. Die IP-Adressen werden spätestens nach 7 Tagen anonymisiert oder gelöscht.<br></span></p><p></p><h3 id="dsg-ga-googleanalytics">Google Analytics</h3><p></p><p><span class="ts-muster-content">Wir setzen Google Analytics, einen Webanalysedienst der Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Irland („Google“) ein. Google verwendet Cookies. Die durch das Cookie erzeugten Informationen über Benutzung des Onlineangebotes durch die Nutzer werden in der Regel an einen Server von Google in den USA übertragen und dort gespeichert.<br><br>Google wird diese Informationen in unserem Auftrag benutzen, um die Nutzung unseres Onlineangebotes durch die Nutzer auszuwerten, um Reports über die Aktivitäten innerhalb dieses Onlineangebotes zusammenzustellen und um weitere, mit der Nutzung dieses Onlineangebotes und der Internetnutzung verbundene Dienstleistungen, uns gegenüber zu erbringen. Dabei können aus den verarbeiteten Daten pseudonyme Nutzungsprofile der Nutzer erstellt werden.<br><br>Wir setzen Google Analytics nur mit aktivierter IP-Anonymisierung ein. Das bedeutet, die IP-Adresse der Nutzer wird von Google innerhalb von Mitgliedstaaten der Europäischen Union oder in anderen Vertragsstaaten des Abkommens über den Europäischen Wirtschaftsraum gekürzt. Nur in Ausnahmefällen wird die volle IP-Adresse an einen Server von Google in den USA übertragen und dort gekürzt.<br><br>Die von dem Browser des Nutzers übermittelte IP-Adresse wird nicht mit anderen Daten von Google zusammengeführt. Die Nutzer können die Speicherung der Cookies durch eine entsprechende Einstellung ihrer Browser-Software verhindern; die Nutzer können darüber hinaus die Erfassung der durch das Cookie erzeugten und auf ihre Nutzung des Onlineangebotes bezogenen Daten an Google sowie die Verarbeitung dieser Daten durch Google verhindern, indem sie das unter folgendem Link verfügbare Browser-Plugin herunterladen und installieren:&nbsp;<a target="_blank" href="http://tools.google.com/dlpage/gaoptout?hl=de">http://tools.google.com/dlpage/gaoptout?hl=de</a>.<br><br>Sofern wir die Nutzer um eine Einwilligung bitten (z.B. im Rahmen einer Cookie-Einwilligung), ist die Rechtsgrundlage dieser Verarbeitung Art. 6 Abs. 1 lit. a. DSGVO. Ansonsten werden die personenbezogenen Daten der Nutzer auf Grundlage unserer berechtigten Interessen (d.h. Interesse an der Analyse, Optimierung und wirtschaftlichem Betrieb unseres Onlineangebotes im Sinne des Art. 6 Abs. 1 lit. f. DSGVO) verarbeitet.<br><br>Soweit Daten in den USA verarbeitet werden, weisen wir daraufhin, dass Google unter dem Privacy-Shield-Abkommen zertifiziert ist und hierdurch zusichert, das europäische Datenschutzrecht einzuhalten (<a target="_blank" href="https://www.privacyshield.gov/participant?id=a2zt000000001L5AAI&amp;status=Active">https://www.privacyshield.gov/participant?id=a2zt000000001L5AAI&amp;status=Active</a>).<br><br>Weitere Informationen zur Datennutzung durch Google, Einstellungs- und Widerspruchsmöglichkeiten, erfahren Sie in der Datenschutzerklärung von Google (<a target="_blank" href="https://policies.google.com/privacy">https://policies.google.com/privacy</a>) sowie in den Einstellungen für die Darstellung von Werbeeinblendungen durch Google <a target="_blank" href="https://adssettings.google.com/authenticated">(https://adssettings.google.com/authenticated</a>).<br><br>Die personenbezogenen Daten der Nutzer werden nach 14 Monaten gelöscht oder anonymisiert.</span></p><p></p><h3 id="dsg-ga-universal">Google Universal Analytics</h3><p></p><p><span class="ts-muster-content">Wir setzen Google Analytics in der Ausgestaltung als „<a target="_blank" href="https://support.google.com/analytics/answer/2790010?hl=de&amp;ref_topic=6010376">Universal-Analytics</a>“ ein. „Universal Analytics“ bezeichnet ein Verfahren von Google Analytics, bei dem die Nutzeranalyse auf Grundlage einer pseudonymen Nutzer-ID erfolgt und damit ein pseudonymes Profil des Nutzers mit Informationen aus der Nutzung verschiedener Geräten erstellt wird (sog. „Cross-Device-Tracking“).</span></p><p></p><h3 id="dsg-google-firebase">Google-Firebase</h3><p></p><p><span class="ts-muster-content">Wir nutzen die Entwicklerplattform „Google Firebase“ und die mit ihr verbundenen Funktionen und Dienste, angeboten von Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Irland.<br><br>Bei Google Firebase handelt es sich um eine Plattform für Entwickler von Applikationen (kurz „Apps“) für mobile Geräte und Webseiten. Google Firebase bietet eine Vielzahl von Funktionen, die auf der folgenden Übersichtsseite dargestellt werden: <a target="_blank" href="https://firebase.google.com/products/">https://firebase.google.com/products/</a>.<br><br>Die Funktionen umfassen unter anderem die Speicherung von Apps inklusive personenbezogener Daten der Applikationsnutzer, wie z.B. von ihnen erstellter Inhalte oder Informationen betreffend ihre Interaktion mit den Apps (sog. „Cloud Computing“). Google Firebase bietet daneben Schnittstellen, die eine Interaktion zwischen den Nutzern der App und anderen Diensten erlauben, z.B. die Authentifizierung mittels Diensten wie Facebook, Twitter oder mittels einer E-Mail-Passwort-Kombination.<br><br>Die Auswertung der Interaktionen der Nutzer kann mithilfe des Analyse-Dienstes „Firebase Analytics“ erfolgen. Firebase Analytics ist darauf gerichtet zu erfassen, wie Nutzer mit einer App interagieren. Dabei werden Ereignisse (sog „Events“) erfasst, wie z.B. das erstmalige Öffnen der App, Deinstallation, Update, Absturz oder Häufigkeit der Nutzung der App. Mit den Events können auch weitere Nutzerinteressen, z.B. für bestimmte Funktionen der Applikationen oder bestimmte Themengebiete erfasst werden. Hierdurch können auch Nutzerprofile erstellt werden, die z.B. als Grundlage für die Darstellung von auf Nutzer zugeschnittenen Werbehinweisen, verwendet werden können.<br><br>Google Firebase und die mittels von Google Firebase verarbeiteten personenbezogenen Daten der Nutzer können ferner zusammen mit weiteren Diensten von Google, wie z.B. Google Analytics und den Google-Marketing-Diensten und Google Analytics verwendet werden (in diesem Fall werden auch gerätebezogene Informationen, wie „Android Advertising ID“ and „Advertising Identifier for iOS“ verarbeitet, um mobile Geräte der Nutzer zu identifizieren).<br><br>Sofern wir die Nutzer um eine Einwilligung bitten (z.B. im Rahmen einer Cookie-Einwilligung), ist die Rechtsgrundlage dieser Verarbeitung Art. 6 Abs. 1 lit. a. DSGVO. Ansonsten werden die personenbezogenen Daten der Nutzer auf Grundlage unserer berechtigten Interessen (d.h. Interesse an der Analyse, Optimierung und wirtschaftlichem Betrieb unseres Onlineangebotes im Sinne des Art. 6 Abs. 1 lit. f. DSGVO) verarbeitet.<br><br>Soweit Daten in den USA verarbeitet werden, weisen wir daraufhin, dass Google unter dem Privacy-Shield-Abkommen zertifiziert ist und hierdurch zusichert, das europäische Datenschutzrecht einzuhalten (<a target="_blank" href="https://www.privacyshield.gov/participant?id=a2zt000000001L5AAI&amp;status=Active">https://www.privacyshield.gov/participant?id=a2zt000000001L5AAI&amp;status=Active</a>).<br><br>Die Datenschutzerklärung von Google ist unter <a target="_blank" href="https://policies.google.com/privacy">https://policies.google.com/privacy</a> abrufbar. Weitere Informationen zur Datennutzung zu Marketingzwecken durch Google, erfahren Nutzer auf der Übersichtsseite: <a target="_blank" href="https://policies.google.com/technologies/ads?hl=de">https://policies.google.com/technologies/ads?hl=de</a>,<br><br>Wenn Nutzer der interessensbezogenen Werbung durch Google-Marketing-Dienste widersprechen möchten, können Nutzer die von Google gestellten Einstellungs- und Opt-Out-Möglichkeiten nutzen: <a target="_blank" href="https://adssettings.google.com/">https://adssettings.google.com/</a></span></p><a href="https://datenschutz-generator.de" class="dsg1-6" rel="nofollow" target="_blank">Erstellt mit Datenschutz-Generator.de von RA Dr. Thomas Schwenke</a>';
}