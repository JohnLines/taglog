Tag-help-version: 1.0
Translated-by: John Lines <john+taglog@paladyn.org>
Sorted-date: 2009-01-31 15:45:21
Sort-key: Id
End: 
Id: About
Description:: END_D
Dies ist Version $1 Copyright 2000 John Lines <john+taglog@paladyn.org>
Taglog ist freie Software und steht unter der GNU Public License.
Taglog Home Page: https://github.com/JohnLines/taglog/wiki
END_D
End: 
Id: actinput
Description:: END_D
Eine Aktion sollte ein klar definiertes Arbeitspaket sein, das Sie oder jemand
anderes ausführen soll. In den Feldern des Aktions-Eingabefensters können
Sie Schlüsselatribute für die Aktion angeben. Jedes Feld hat seinen eigenen
Hilfetext.

Bevor Sie eine neue Aktion definieren sollten Sie überlegen, ob sie über-
haupt durchgeführt werden sollte. Bedenken Sie Stephen R Coveys "Circle of
Concern and Circle of Influence from the 7 Habits of Highly Effective People".
Wenn eine Aktion nicht in Ihren Einflussbereich fällt, sollten Sie sie lieber
sein lassen und etwas anderes tun, wo Sie mehr bewirken können.
END_D
End: 
Id: actinput_abort_action
Description:: END_D
Dieses Feld enthält die Id einer Aktion, die gestartet wird, wenn die
Aktion, die gerade eingegeben wird, abgebrochen wird.
END_D
End: 
Id: actinput_active_after
Description:: END_D
Wenn Sie hier ein Datum (und optional eine Zeit) einsetzen, wird die Aktion
so lange als "Blockiert" markiert, bis der angegebene Zeitpunkt erreicht ist
oder Taglog das nächste Mal nach der angegebenen Zeit gestartet wurde. Dann
wird die Aktion automatisch auf "Aktiv" gesetzt.

Wenn die Aktion auf "Aktiv" gesetzt wird, erscheint ein Fenster, das die
Überschrift und die Beschreibung der Aktion enthält. Damit kann man zeit-
gesteuerte Erinnerungen veranlassen.
END_D
End: 
Id: actinput_date
Description:: END_D
Dieses Feld enthält das Datum, an dem die Aktion hinzu-
gefügt wurde. Es wird automatisch vom Programm besetzt.
END_D
End: 
Id: actinput_delegated_to
Description:: END_D
Dieses Feld enthält die Kontakt-Id (oder den Namen, falls Sie die Kontakte
nicht nutzen) der Person, der die Aktion übertragen wurde. Momentan benach-
richtigt taglog nicht diese Person, so dass Sie das selbst tun müssen.
END_D
End: 
Id: actinput_deliverable
Description:: END_D
Mit diesem Feld können Sie genau definieren, wie der Endzustand der Aktion
aussehen muss.

Falls sich die unerledigten Aktionen anhäufen, kann es sein, dass sie
genauere Angeben in diesem Feld machen müssen (bessere Zielbestimmung).
Falls sich die Ziele ändern, kann es besser sein, die Aktion abzubrechen
(Status Aborted) und neue Aktionen mit passenderen Zielen zu definieren.
END_D
End: 
Id: actinput_description
Description:: END_D
Hier können Sie eine längere Beschreibung zu der geplanten Tätigkeit geben.
Falls Sie z.B. über eine EMail zu einer Tätigkeit aufgefordert wurden,
können Sie die wesentlichen Teile mit "cut & paste" aus der EMail in
dieses Feld kopieren.
END_D
End: 
Id: actinput_difficulty
Description:: END_D
Der Schwierigkeitsgrad kann dazu genutzt werden, Aktionen herauszusuchen,
die leichter als ein bestimmter Grad sind.  Zum Beispiel wollen Sie sich für
das Ende der Arbeitstages eine leichte Aktion heraussuchen oder zu einem
günstigen Zeitpunkt eine anspruchsvolle Aktion in Angriff nehmen. 
END_D
End: 
Id: actinput_email_status_to
Description:: END_D
Wenn Sie dieses Feld anwählen und Ihre EMail-Einstellung
ist vorbelegt, wird jedesmal, wenn sich der Status einer
Aktion ändert, eine EMail an die angegebene Adresse ge-
sendet. Das schließt die Erzeugung der Aktion ein.

Die EMail enthält alle Felder der Aktion. Dadurch können
Sie ohne weiteres Zutun jemanden auf dem Laufenden halten.
END_D
End: 
Id: actinput_expected_completed_date
Description:: END_D
Geben Sie das Datum für die erwartete Erledigung der Aktion an.
Das Datum sollte im ISO-Format (JJJJ-MM-TT) angegeben werden.

Das Datum kann auch aus dem Kalender ausgewählt werden (Knopf rechts
neben dem Datum-Feld). 

Durch die Speicherung des Ende-Datums können sie leicht prüfen, welche
Aktionen zu einer bestimmten Zeit erledigt sein müssen.
END_D
End: 
Id: actinput_expected_cost
Description:: END_D
Geben Sie einen Geldbetrag beliebiger Währung an, der die erwarteten Kosten
(ohne die Kosten für die Arbeitszeit) der Aktion darstellt. Der Wert sollte
als reelle Zahl eingegeben werden.
END_D
End: 
Id: actinput_expected_start_date
Description:: END_D
Geben Sie das Datum für die erwartete Startzeit der Aktion an.
Also das Datum, an dem voraussichtlich der Status von "Wartend"
auf "Aktiv" geändert wird.
Das Datum sollte im ISO-Format (JJJJ-MM-TT) angegeben werden.

Es kann auch aus dem Kalender ausgewählt werden (Knopf rechts
neben dem Datum-Feld). 
END_D
End: 
Id: actinput_expected_time
Description:: END_D
Geben Sie die erwartete effektive Arbeitszeit in Stunden und Minuten an.

Sie können eine Wert aus dem Menü auswählen, oder einen Wert in das Text-
feld eingeben, z.B. 3:15 für 3 Stunden und 15 Minuten.
END_D
End: 
Id: actinput_id
Description:: END_D
Jeder Aktion ist eine eindeutige Identifizierung (Id) zugeordnet. Diese wird
automatisch generiert, wenn Sie das Id-Feld auf "*Auto*" belassen. Wenn Sie
ein Id-Präfix in Datei/Einstellungen angegeben haben, bildet dieses den
ersten Teil der Id.

Wenn die Aktion mit einem Projekt verknüpft ist, wird die Id aus dem Projekt-
namen und einer fortlaufenden Nummer erzeugt. Diese Nummer wird für jede
Aktion in einem Projekt hochgezählt - z.B. jlines.test_projekt.57

Falls die Aktion nicht mit einem Projekt verknüpft ist, wird die Identifizie-
rung in der Form "taglog.JJJJMMTThhmm" aus dem aktuellen Datum und der Uhr-
zeit gebildet - z.B. jlines.taglog.200011190945

Beachten Sie, dass das Präfix mit dem Urheber der Aktion verbunden ist und
nicht notwendigerweise mit dem, der die Aufgabe ausführen wird. Es wird be-
nutzt, damit eine Aktion eindeutig ist - so gibt es keine Unklarheit, wenn
jemand fragt - 'Haben Sie das Projekt jlines.test_projekt.57 beendet?'
END_D
End: 
Id: actinput_next_action
Description:: END_D
Dieses Feld enthält die Id einer Aktion, die gestartet wird, sobald die
aktuelle Aktion abgeschlossen ist.
END_D
End: 
Id: actinput_precursor
Description:: END_D
Das Vorgänger-Feld blockiert eine Aktion so
lange, bis eine andere (Vorgänger-)Aktion beendet ist.

Dieses Attribut wird noch nicht benutzt.
END_D
End: 
Id: actinput_priority
Description:: END_D
Taglog verwendet Prioritäten im Bereich von 0 bis 100.
  0 = höchste Priorität (eilig)
100 = niedrigste Priorität

Der Standardwert ist 50.
END_D
End: 
Id: actinput_project
Description:: END_D
Taglog benutzt den Begriff Projekt als Verrechnungsstelle (Kostenstelle) für
die Zeiterfassung. Wenn Sie eine Aktion ausführen, die mit einem Projekt
verbunden ist, wird die aufgewandte Zeit für dieses Projekt verbucht.
Falls Sie noch keine Projekte definiert haben, können Sie diese unter
Projects/add (Option in der Menüleiste) hinzufügen.
END_D
End: 
Id: actinput_reason
Description:: END_D
Manchmal weiß man nicht, aus welchem Grund man eine Aktion begonnen hat.
Hier kann dieses Feld helfen und einen motivieren. Falls das nicht der
Fall ist (z.B. der Grund ist 'Der Chef hat mir aufgetragen...') vergessen
Sie dieses Feld.
END_D
End: 
Id: actinput_status
Description:: END_D
Aktionen ist ein Bearbeitungsstatus zugeordnet. Folgende Status
sind möglich:
"Wartend"	("pending") Normalerweise der Status beim Start einer Aktion.
		(wartet auf Ausführung, noch nicht begonnen)
"Aktiv" 	("active") Momentan in Bearbeitung
"Abgeschlossen"	("completed") Bearbeitet
"Abgebrochen"	("aborted") Abgebrochen
"Delegiert"	("delegated") an eine andere Person delegiert
"Blockiert"	("blocked") Aktive Aktionen können als blockiert markiert
		werden, wenn man an ihrer Ausführung gehindert ist.
"Unveranlagt" 	("unclaimed") Besitzerlose Aktionen, die (noch) keinem Be-
		arbeiter zugeordnet sind, sondern einer gesamten Gruppe von
		Personen zur Verfügung stehen. Sie können einem Bearbeiter zu-
		geordnet werden, indem er den Status auf "Wartend" oder "Aktiv"
		setzt.
END_D
End: 
Id: actinput_subtask_of
Description:: END_D
"Unteraufgabe-von" bedeutet, dass eine Aufgabe eine Unter-
aufgabe einer anderen Aufgabe ist.

Diese Funktionalität ist noch nicht implementiert.
END_D
End: 
Id: actinput_title
Description:: END_D
Wählen Sie eine kurze Überschrift für diese Aktion. An vielen Stellen
können Sie die Aktion durch diese Überschrift identifizieren, ohne weitere
Informationen zu dieser Aufgabe (z.B. die Beschreibung oder das Projekt)
angeben zu müssen.

Wählen Sie deshalb eine aussagekräftige Überschrift.
END_D
End: 
Id: actions
Description:: END_D
Aktionen helfen Ihnen Ihre 'Todo'-Liste zu verwalten. Hat man einmal
Aktionen eingegeben, kann man eine aus den momentan aktiven Aktionen
auswählen indem man auf 'Aktion' in der mittleren Menüleiste klickt.

Hinzufügen...
	Hier kann eine neue Aktion erzeugt werden.
Ansicht	Zeigt ausgewählte Aktionen in einer Liste an. Mit einem rechten
	Mausklick kann man einen Eintrag editieren.
Historie
	Liefert alle Log-Einträge, die mit einer Aktion verknüpft sind
	und zeigt diese an. Zusätzlich summiert es alle Zeiten, die für
	diese Aktion aufgewendet wurden, auf und erlaubt so eine
	Abschätzung der zeitlichen Aufwände und des Erledigungsdatums.
	Diese Werte können hier auch geändert werden.
Abschließen
	Hier kann man eine aktive Aktion auswählen und als erledigt
	markieren. Das Erledigungsdatum wird automatisch gespeichert.
	Zusätzlich kann noch ein Erledigungsvermerk eingegeben werden.
Aktivieren
	Hier kann man eine 'wartende' Aktion auswählen und als aktiv
	markieren.
Abbruch Aktiv
	Hier kann man eine aktive Aktion auswählen und als abgebrochen
	markieren.
Abbruch Wartend
	Hier kann man eine 'wartende' Aktion auswählen und als
	abgebrochen markieren.
Reaktivieren
	Hier kann man eine als erledigt markierte Aktion auswählen und
	als aktiv markieren.
Extra...
	Hier können Änderungen an Aktionen vorgenommen werden, die
	normalerweise nicht notwendig sind.
END_D
End: 
Id: actmail_message
Description:: END_D
Geben Sie den Text ein, der als Beschreibung zu
dieser Aktion mit versendet werden soll.
END_D
End: 
Id: actmail_to
Description:: END_D
Geben Sie die EMail-Adresse der Person an, an die die Nachricht geschickt
werden soll, oder wählen Sie deren Ansprechpartner Id aus der Liste, um
die EMail-Adresse automatisch zu besetzen.
END_D
End: 
Id: actreminder
Description:: END_D
Benutzen Sie dieses Feld, wenn Sie sich an Aktionen, die Sie heute vorhaben,
erinnern lassen möchten. Momentan ist es nur ein gewöhnliches Textfeld, das
nicht mit den Aktions-Daten verbunden ist. Wenn Sie das Programm verlassen,
wird der Inhalt der Felder gespeichert, so dass Sie zurückschauen und sich
erinnern können, was Sie gestern getan haben. (Momentan allerdings nur in
einer Datei.)
END_D
End: 
Id: actsel
Description:: END_D
In diesem Fenster können Sie auswählen, welche Aktion Sie sich anzeigen
lassen möchten. Es gibt viele Arten eine Aktion auszuwählen. Hier können
Sie Attribute setzen, die die auszuwählenden Aktionen haben müssen.

Diese Attribute werden durch ein "logisches UND" verknüpft, d.h. alle
gesetzten Attribute müssen für eine Aktion zutreffen.

Die "Refresh"-Schaltfläche baut die Liste der Aktionen in den "drop down"
Menüs für Id (Identifikation) und Überschrift anhand der ausgewählten
Attribute neu auf.
END_D
End: 
Id: actsel_expected_completed
Description:: END_D
Hier kann man Aktionen mit einem erwarteten Erledigungsdatum auswählen.
END_D
End: 
Id: actsel_expected_start
Description:: END_D
Hier kann man Aktionen mit einem erwarteten Startdatum auswählen.
END_D
End: 
Id: actsel_filename
Description:: END_D
Wählen Sie den Namen einer Datei aus, in der Aktionen
gespeichert sind, die Sie anzeigen lassen wollen. Vor-
besetzt ist die Datei, in der sich die momentane
Aktion befindet.
END_D
End: 
Id: actsel_id
Description:: END_D
Wenn sie die "Aktualisieren"-Schaltfläche links vom "Id"-Feld betätigen, wird
das "Id"-Menü mit Ids der Aktionen gefüllt, die den anderen ausgewählten Feldern
entsprechen. Sie können dann das "Id"-Feld nutzen, um eine spezielle Aktion
auszuwählen.
END_D
End: 
Id: actsel_maxpriority
Description:: END_D
Aktionen, deren Priorität kleiner oder gleich dem hier angegebenen
Wert sind, werden berücksichtigt.

Prioritäten reichen von 1 (höchste Priorität) bis 100 (niedrigste Pr.).
Der Standardwert ist 50.

Diese Option erlaubt es, Aktionen auszuwählen, die mindestens eine
bestimmte Wichtigkeit haben.
END_D
End: 
Id: actsel_project
Description:: END_D
Wählen Sie ein Projekt aus, für das Sie Aktionen auswählen. Es werden nur
Aktionen berücksichtigt, die mit diesem Projekt verbunden sind.
END_D
End: 
Id: actsel_showfields
Description:: END_D
Sie können die Felder auswählen, die in der Liste der Aktionen angezeigt
werden sollen. Ist der "Alle"-Schalter gesetzt, werden alle Felder auswählt,
ansonsten werden nur die Felder angezeigt, deren Schalter aktiviert sind.
END_D
End: 
Id: actsel_sortby
Description:: END_D
Die Liste der Aktionen kann nach verschiedenen Feldern sortiert werden.
Wählen Sie hier einen Wert, um die ausgewählten Aktionen nach diesem
Wert zu sortieren.
END_D
End: 
Id: actsel_st
Description:: END_D
Wenn der "Beliebig"-Schalter gesetzt, ist werden alle Aktionen ungeachtet ihrer
Status berücksichtigt. Die Anderen Status-Schalter spielen dann keine Rolle.
Ist der "Beliebig"-Schalter nicht gesetzt, werden nur Aktionen berücksichtigt,
die den selektierten Status-Schaltern entsprechen.
END_D
End: 
Id: actsel_title
Description:: END_D
Wenn Sie die "Refresh"-Schaltfläche links vom "Id"-Feld betätigen, wird
das "Titel"-Menü mit Überschriften der Aktionen gefüllt, die den anderen
ausgewählten Feldern entsprechen. Sie können dann das "Titel"-Feld nutzen,
um eine spezielle Aktion auszuwählen.
END_D
End: 
Id: add_old_log
Description:: END_D
Hier können Sie einen alten Log-Eintrag auswählen. Der Eintrag wird immer an
die Log-Datei angefügt, auch wenn er schon existiert, der Zeitbereich
früher ist als alle Zeiten in der Datei oder Bereiche überlappen. Das bringt
die Programmteile durcheinander, die Reports erstellen.

Diese Funktionaltiät ist hauptsächlich dafür gedacht, dass man Zeiten nach-
tragen kann, wenn man ein oder mehrere Tage nicht an seinem Computer ge-
arbeitet hat.
END_D
End: 
Id: addcontact
Description:: END_D
Füllen Sie diese Felder aus, um einen neuen Ansprechpartner hinzuzufügen.
Sie können diesen Kontakt nutzen, um das Versenden von Mails zu ver-
einfachen, um Telefonanrufe nachzuvollziehen, die Sie machen müssen, oder
um eine Historie von Kontakten mit einer bestimmten Person zu erhalten.
END_D
End: 
Id: addcontact_address
Description:: END_D
Geben Sie hier Teile der Adresse ein, die in keinem anderen Feld unter-
zubringen sind.
END_D
End: 
Id: addcontact_country
Description:: END_D
Geben Sie das Land an, in dem die Person wohnt. Ich schlage vor, den ISO-
Ländercode zu verwenden, um konsistent zu bleiben, aber das ist nicht
erforderlich.
END_D
End: 
Id: addcontact_default_as
Description:: END_D
Dieser Parameter ist bisher nur experimentell. In Zukunft wird man hier eine
Id eines anderen Kontakts angeben können, wodurch alle Felder des Kontakts bis
auf diejenigen, die den Kontakt umfangreicher beschreiben, durch Werte des hier
ausgewählten Kontakts gefüllt werden.

In dieser Version ist es nur ein Platzhalter und bewirkt nichts.
END_D
End: 
Id: addcontact_email
Description:: END_D
Geben Sie die EMail-Adresse des Kontakts an.
END_D
End: 
Id: addcontact_fax
Description:: END_D
Geben Sie die Fax-Nummer des Kontakts an.
END_D
End: 
Id: addcontact_forename
Description:: END_D
Geben Sie den Vornamen des Kontakts an.
END_D
End: 
Id: addcontact_id
Description:: END_D
Geben Sie eine Identifizierung (ID) für diesen neuen Kontakt (Person) an.
Diese ID sollte kurz und gut zu merken sein, da sie in Auswahlmenüs von
Kontakten verwendet wird.

Je nachdem wieviele Personen Sie speichern wollen, können Sie nur die
Initialen oder auch den gesamten Namen hier angeben.
END_D
End: 
Id: addcontact_ldap
Description:: END_D
Geben Sie die LDAP URL (wie in RFC 2255 beschrieben) für den Kontakt ein.
z.B. ldap://ldap.example.com/cn=smith,dc=example,dc=com

Das kann möglicherweise dazu benutzt werden, um die Details dieser Person
beim LDAP Server zu bekommen oder zu überprüfen.
END_D
End: 
Id: addcontact_mobilephone
Description:: END_D
Geben Sie die Mobilfunknummer des Kontakts an.
END_D
End: 
Id: addcontact_organisation
Description:: END_D
Geben Sie die Organisation an, die mit der Person verbunden ist (z.B die
Firma, in der sie arbeitet).
END_D
End: 
Id: addcontact_phone
Description:: END_D
Geben Sie die Telefonnummer des Kontakts an.
END_D
End: 
Id: addcontact_postcode
Description:: END_D
Geben Sie die Postleitzahl (oder den zip code) des Kontakts an.
END_D
End: 
Id: addcontact_short_id
Description:: END_D
Geben Sie eine kurze (2 bis 3 Zeichen) Identifizierung für diesen Kontakt
an. Sie wird für Berichte genutzt, bei denen eine Aktion mit einer oder
mehreren Personen verbunden ist, und soll dort nicht viel Raum einnehmen.
Dieses Feld ist (momentan) nur für Mitarbeiter von bedeutung. Wenn es nicht
besetzt ist, wird die normale ID angezeigt.
END_D
End: 
Id: addcontact_surname
Description:: END_D
Geben Sie den Nachnamen des Kontakts an.
END_D
End: 
Id: addcontact_title
Description:: END_D
Geben Sie den Titel der Person an oder wählen Sie Ihn vom "drop down"
Menü. Bitte bedenken Sie, dass es so viele Titel gibt, dass sie nicht
alle aufgeführt werden können.
END_D
End: 
Id: addcontact_type
Description:: END_D
Wählen sie einen Typ aus dem "drop down"-Menü. Diese Typen können Sie in
der Datei für die Voreinstellungen ändern.
END_D
End: 
Id: addcontact_web
Description:: END_D
Geben Sie die HTTP-URL für die Homepage dieser Person an.
END_D
End: 
Id: addproject
Description:: END_D
In taglog ist ein Projekt etwas, auf dem man Arbeitszeit verbuchen kann.

Der Projektname sollte eine einfach zu merkende Bezeichnung des Projekts sein.

Der Buchungs-Code wird benutzt als Identifizierung des Projekts in Ihrem
Abrechnungssystem, das vielleicht keine Buchstaben für Kostenstellen ver-
arbeiten kann.

Man kann Projekte haben, die als "Pausen" (Unterbrechungen, Pausen) gekenn-
zeichnet sind. Ihre Zeit kann nicht verbucht werden.

Es gibt sogenannte "Overhead" Projekte, die bei der Generierung von Reports
genutzt werden, wobei Zeiten, die in diesen Projekten verbraucht wurden, auf
wirkliche Projekte verteilt werden.

Die Hauptprojekte, an denen Sie momentan arbeiten, sollten als "Aktiv"
markiert sein. Sie erscheinen immer in Projekt/Ansicht Darstellung, auch
wenn für sie keine Zeit verbucht wurde.

Das Erzeugungsdatum des Projekts wird automatisch vom System gesetzt und
Sie können das Datum des voraussichtlichen Endes angeben, oder sie geben
es später über die Option "Projekte/Bearbeiten" ein.

Das System nutzt die Datumeinträge um schneller die verbrachte Zeit in einem
Projekt berechnen zu können, da nur Log-Dateien durchsucht werden müssen,
die ab dem Erzeugungsdatum des Projekts erstellt wurden.
Wenn das Beendigungsdatum überschritten wurde, wird Ihnen das zugehörige
Projekt nicht mehr angeboten, um darauf Zeit zu verbuchen.
END_D
End: 
Id: adjstart
Description:: END_D
Die Möglichkeit, die Startzeit eines Log-Eintrags anzupassen, ist z.B.
dann nützlich, wenn Sie für "kurze" Zeit Ihren Arbeitsplatz verlassen,
während das Logging zu einem Projekt läuft, und Sie von Jemandem länger
als erwartet durch eine Diskussion zu einem anderen Projekt aufgehalten
werden.

Sie können die Startzeit für die aktuelle Aktion (die, deren Beschreibung
Sie in das untere große Fenster eingeben) durch das Betätigen der "Start"-
Schaltfläche ändern. Dabei können Sie entweder die geänderte Zeit in das
Feld mit der Beschriftung "Neue Startzeit" eintragen, oder Sie können mit
dem Schieberegler die Anzahl der Minuten einstellen, die Sie abziehen möchten.

Falls Sie nicht die Startzeit des ersten Eintrags an diesem Tag ändern, haben
Sie die Möglichkeit das Ende des vorhergehenden Eintrags an die geänderte
Zeit anzupassen. Das ist die Voreinstellung. Wenn Sie diese Anpassung nicht
vornehmen, wird für die Zeitdifferenz das Zeitkonto doppelt belastet.
END_D
End: 
Id: alwin_project
Description:: END_D
Der Projektname, der mit der alten Log-Datei verbunden ist, kann hier ein-
gegeben werden oder aus dem "drop down"-Menü ausgewählt werden. Man kann
alle Projekte auswählen, auch solche, deren Beendigungszeit schon über-
schritten wurde. 
END_D
End: 
Id: contacts
Description:: END_D
Die Verwaltung von Kontakten ist nicht die Hauptaufgabe von taglog, aber
diese Möglichkeit ist vorhanden und erlaubt Ihnen Log-Einträge mit Personen
zu verknüpfen oder Einträge zu suchen, die mit bestimmten Personen verknüpft
sind. Es können auch Email-Adressen gespeichert werden und zusammen mit der
EMail Funktion von taglog verwendet werden.
END_D
End: 
Id: contactview
Description:: END_D
Benutzen Sie diese Felder zur Auswahl von Informationen zu Ansprech-
partnern, die sie sehen möchten, und klicken Sie 'Ansicht'.
END_D
End: 
Id: cview_forename
Description:: END_D
Geben Sie den Vornamen (oder einen Teil davon) der Person ein, die Sie
suchen.
END_D
End: 
Id: cview_organisation
Description:: END_D
Geben Sie die Organisation (oder einen Teil davon) ein, die Sie suchen.
END_D
End: 
Id: cview_phone
Description:: END_D
Geben Sie die Telefonnummer (oder einen Teil davon) ein,
die Sie suchen.
END_D
End: 
Id: cview_surname
Description:: END_D
Geben Sie den Nachnamen (oder einen Teil davon) der Person ein, die Sie
suchen.
END_D
End: 
Id: cview_type
Description:: END_D
Wählen Sie einen Kontakt-Typ aus, um das Suchergebnis auf Kontakte mit
diesen Typ zu beschränken.
END_D
End: 
Id: editprefs
Description:: END_D
Hier können Sie einige Merkmale festlegen, die die Arbeitsweise des
Programms beeinflussen. Jeder Eintrag hat seinen eigenen Hilfetext
(linker Maus-Klick auf die jeweilige Beschriftung).
Taglog speichert diese Einstellungen in einer Datei, deren Name in der
Kopfzeile zu finden ist. Mit Ok werden die neuen Einstellungen in die
Datei geschrieben.
END_D
End: 
Id: editprefs_current_win_depth
Description:: END_D
Hier können Sie die Anzahl der Zeilen für das aktuelle Log-Fenster ein-
stellen. (Das ist das untere Fenster im Hauptfenster). Allerdings ändert
sich die Fenstergröße, wenn Sie das Hauptfenster in seiner Größe verändern.
END_D
End: 
Id: editprefs_history_win_depth
Description:: END_D
Hier geben Sie die Anzahl der Zeilen für das "History"-Fenster an. (Das ist
das Fenster, das die bisherigen Log-Einträge des Tages enthält.) Damit kann
man auf kleinen Bildschirmen Platz sparen.
END_D
End: 
Id: editprefs_id_prefix
Description:: END_D
Dieses Präfix wird verwendet, um Aktionen, die Sie neu definieren, ein-
deutig zu machen (innerhalb einer Arbeitsgruppe). Falls ein Präfix gesetzt
ist, wird dieses jeder neuen Aktions-ID vorangestellt.
END_D
End: 
Id: editprefs_num_today_actions
Description:: END_D
Hier können Sie die Anzahl der Felder für Aktionen auswählen, an die Sie
erinnert werden wollen. Diese Felder werden unter der Menüleiste im Haupt-
fenster angezeigt. Mit 0 können Sie alle Felder ausblenden.
END_D
End: 
Id: editprefs_projects_url
Description:: END_D
Geben Sie eine URL zu einer Web-Seite an, die eine Liste von Projekten liefert,
auf die Zeit gebucht werden kann.
Beispiel: http://projects.example.com/projects-list.php?jl
END_D
End: 
Id: editprefs_start_procs
Description:: END_D
Alle hier angegebenen Prozeduren werden beim Start von taglog gestartet.
Wenn Sie mit einem ikonifizierten Hauptfenster und einem Fenster, das die
momentan aktiven Projekte und die für diesen Tag darauf verbuchten Zeiten
anzeigt, starten möchten, wählen Sie 'iconify_mainwin doShowProjects'.
END_D
End: 
Id: editproject
Description:: END_D
In taglog ist ein Projekt etwas, auf dem man Arbeitszeit verbuchen kann.

Jedes Projekt hat einen Namen, einige Kennzeichnungen, wie Zeiten, die für
dieses Projekt verbucht werden können, einen Buchungs-Code und das Start-
und Beendigungsdatum.

Die Kennzeichnungen sind:
  Pausen   Diese Projekte haben keine normale Arbeitszeit. Ihre Zeiten werden
           bei Berichten anders behandelt. 'Overhead'-Zeiten werden nicht auf
	   sie verteilt.
  Overhead Zeiten, für solche Projekte werden bei den Berichten gleichmäßig
           auf die anderen projekte verteilt (mit Ausnahme von 'Pausen')
  Aktiv    Solche Projekte sind in der Bearbeitung (im Gegensatz zu nur
           offen). Sie werden immer in Projekte/Ansicht mit aufgeführt, auch
	   wenn keine Zeit für sie verbucht wurde.

Wenn Sie vermeiden wollen, dass ein Projekt in der Projektauswahl erscheint,
geben Sie diesem ein Beendigungsdatum, das älter als der heutige Tag ist.
END_D
End: 
Id: endbutton
Description:: END_D
Die Punkte unter dem 'Ende'-Knopf behandeln verschiedene Eigenschaften des Log-
eintrags.
Sie können die aktuelle Aktion abschließen.
Sie können die aktuelle Aktion abbrechen.
Sie können einen Ansprechpartner mit dem aktuellen Log-Eintrag verknüpfen.
Die Verknüpfung wird zurückgesetzt, wenn Sie zum nächsten Eintrag übergehen.
Sie können eine Rate mit dem aktuellen Log-Eintrag verknüpfen. Diese
Verknüpfung bleibt bestehen, bis Sie das Programm verlassen oder die Rate
löschen.
END_D
End: 
Id: ep_enddate
Description:: END_D
Geben Sie das Beendigungsdatum für das Projekt an.
END_D
End: 
Id: file
Description:: END_D
'Öffnen'     erlaubt Ihnen Einträge von vorangegengenen Tagen anzuschauen. Man
             kann Einträge aufgrund verschiedener Kriterien suchen (z.B.
	     Projektbezeichnung oder Aktivität)
'Ende'       Beendigung des Programmes am Ende des Tages
'Abbruch'    Beendet das Programm ohne den letzten Eintrag zu speichern
'Log hinzufügen/ändern
             Erlaubt Eintraäg von vorhergehenden Tagen zu ändern oder neu zu
	     erzeugen. Um einen Eintrag des aktuellen Tages zu ändern sollte
	     man mit der rechten Maustaste diesen Eintrag auswählen.
'Anhalten'   Hält die Buchungsuhr an (z.B. wegen Pausen)
'Fortfahren' Läßt die angehaltene Buchungsuhr wieder weiterlaufen.
'Einstellungen'
             Erlaubt benutzerdefinierte Einstellungen.
END_D
End: 
Id: hint_activity_pre_meeting
Description:: END_D
Besprechungen können eine große Zeitverschwendung oder extrem produktiv
sein. Wesentlich ist die Vorbereitung. Bedenken Sie folgendes vor einer
besprechung:

Weshalb sind Sie dabei?
 Bereiten Sie die besprechung vor?
  Falls ja, haben Sie eine Agenda mit Ihren persönlichen Leitlinien und
  der dazugehörigen Zeitplanung?
 Sollen Sie technische Informationen dazu beitragen?
  Falls ja, haben Sie die notwendigen Hintergrundinformationen gesammelt?
  Welche Fragen können Inhen gestellt werden?
 Sind Sie dabei, um Informationen zu bekommen?

Was sind Ihre Ziele?
 Wenn Sie wissen, was für Sie bei der Besprechung herauskommen soll und
 die anderen Teilnehmer sind nicht vorbereitet, werden Sie wahrscheinlich
 Ihre Ziele erreichen.

END_D
End: 
Id: hint_help
Description:: END_D
Dieser Abschnitt enthält Hintergrundinformationen zum Zeit-Management.
Einige davon enthalten Vorschläge, wie man Zeit-Management-Probleme mit
taglog löst, aber es sind auch allgemeinere Hilfen enthalten.

Weitere Zusätze sind willkommen. Wenn Sie einen guten Tip zum Zeit-Management
haben, schicken Sie ihn bitte an den Author.
END_D
End: 
Id: hint_problem_actions_overrun
Description:: END_D
Wenn Sie meinen, dass Aktionen länger dauern als ursprünglich erwartet, waren
Sie wahrscheinlich bei zu Beginn zu optimistisch. Falls Sie es nicht schon
tun, versuchen Sie zu Beginn einer Aktion die erwartete Zeit anzugeben.
Prüfen Sie regelmäßig Ihre aktiven Aktionen indem Sie den Menüpunkt
Aktionen/Historie aufrufen und passen Sie gegebenenfalls die Daten an.

Die Zusammenfassung von Aktionen/Historie zeigen den Unterschied zwischen
der letzten und der ursprünglichen Schätzung. Verwenden Sie diese Information
um künftig bessere Anfangsabschätzungen machen zu können.
END_D
End: 
Id: hint_problem_interruptions
Description:: END_D
Fall Sie durch Unterbrechungen zu sehr gestört werden, legen Sie Zeiten fest,
an denen Sie nicht zu sprechen sind und machen Sie diese durch eine Notiz
an Ihrer Tür oder auf Ihrem Schreibtisch (falls Sie in einem Großraumbüro
arbeiten) bekannt. Ihr Anrufbeantworter sollte Zeiten angeben, zu denen
Sie bevorzugr Gespräche annehmen.
END_D
End: 
Id: introduction
Description:: END_D
Taglog erlaubt es zu messen, wie Sie Ihre Zeit verwenden und hilft Ihnen
bei der planung von Aktionen (Aufgaben). Sie können Peiten auf Projekte
buchen. Projekte werden in taglog dazu verwendet um die Arbeitszeit in
buchbare Einheiten aufzuteilen.

Wenn Sie Zeiten zu Projekten buchen wollen, dann legen Sie im nächsten
Schritt Projekte an.

Die Hauptfunktion von taglog ist es, Anmerkungen zur verbrachten Zeit zu
machen. Diese werden im größeren Fenster unten eingegeben.

Wenn Sie zur nächsten Aktivität wechseln, klicken Sie auf 'Weiter'. Damit
wird die Start- und Beendigungszeit der Aktivität protokolliert.

Viele der Beschriftungen haben eine Online-Hilfe und/oder erlauben Ihnen
Werte aus einer Liste auszuwählen. Dazu klicken Sie einfach auf die Be-
schriftung.

Um das Programm zu verlassen verwendet man den Menüeintrag Datei/Ende.
END_D
End: 
Id: led_calendar
Description:: END_D
Drücken Sie einen Knopf im Kalender, um Log-Einträge für den zugehörigen Tag
auszuwählen. Mit ">>" und "<<" kann man den nächsten oder vorherigen Monat
auswählen. Wenn zu einem Tag eine Log-Datei existiert, ist der zugehörige Knopf
gelb dargestellt.
END_D
End: 
Id: led_ediEnt
Description:: END_D
Dieses Fenster erlaubt die Parameter eines Log-Eintrages zu verändern.
END_D
End: 
Id: led_entList
Description:: END_D
Dieses Fenster zeigt die Liste aller Log-Einträge für einen ausgewählten Tag.
Einträge mit Startzeiten, die früher als die End-Zeit des vorhergehenden Ein-
trags sind, sind mit ">" gekennzeichnet. Falls die Startzeit eines Eintrags
größer als dessen End-Zeit ist, wird der Eintrag mit "!" markiert. Die
markierten Einträge sind auch farbig hervorgehoben, wenn das die TCL/TK-
Version unterstützt.
Folgende Bearbeitungsoptionen sind vorhanden:
Bearbeiten...
  Diese Option ist nur aktiviert, wenn Einträge in der Liste ausgewählt wurden.
  Für jeden ausgewählten Eintrag wird ein Fenster geöffnet, das alle Parameter
  zu diesem Log-Eintrag enthält.
Hinzufügen...
  Es wird ein Eingabefenster geöffnet, in dem man einen neuen Log-Eintrag hinzu-
  fügen kann.
Löschen
  Die ausgewählten Einträge werden gelöscht.
Importieren...
  Diese Option erlaubt es Log-Einträge aus Dateien zu übernehmen.

Zusätzlich besteht die Möglichkeit, Start- oder End-Zeiten an die Zeit des
vorherigen oder nächsten Eintrages anzupassen. Dazu wählt man den zu
ändernden Eintrag mit der rechten Maustaste aus. Es erscheint ein Menü,
in dem Sie die gewünschte Operation ausführen können.

END_D
End: 
Id: led_impList
Description:: END_D
Diese Liste enthält alle Log-Einträge der ausgewählten Datei. Einträge mit
Startzeiten, die früher als die End-Zeit des vorhergehenden Eintrags sind,
sind mit ">" gekennzeichnet. Falls die Startzeit eines Eintrags größer als
dessen End-Zeit ist, wird der Eintrag mit "!" markiert. Die markierten Ein-
träge sind auch farbig hervorgehoben, wenn das Ihre TCL/TK-Version unterstützt.

Mit "Importieren" kann man selektierte Einträge übernehmen. "Alle" erlaubt
es, die gesamte Liste zu importieren.
END_D
End: 
Id: led_newEnt
Description:: END_D
Hier können Sie die Parameter für einen neuen Log-Eintrag eingeben.
END_D
End: 
Id: logedit
Description:: END_D
Gemäß 'The Rubaiyat' von Omar Khayyam (ins Englische übersetzt von
Edward Fitzgerald)

 The Moving Finger writes; and, having writ,
 Moves on; nor all thy Piety nor Wit
 Shall lure it back to cancel half a Line,
 Nor all thy Tears wash out a Word of it.

Taglog gibt ihnen allerdings die Möglichkeit, mit der rechten Maustaste
einen Eintrag anzuklicken und Ihn zu editieren.
END_D
End: 
Id: logedit_action
Description:: END_D
Sie können die mit diesem Eintrag verbundene Aktion ändern. Momentan kön-
nen Sie die Aktion nicht einer Auswahlliste entnehmen. Seien Sie vorsichtig,
die Aktions-Id wird nicht geprüft.
Sie sollten das 'Titel der Aktion' Feld anpassen, wenn Sie eine Änderung
vornehmen.
END_D
End: 
Id: logedit_actiontitle
Description:: END_D
Sie können die Überschrift der Aktion für diesen Eintrag ändern. Momentan kön-
nen Sie die Überschrift nicht einer Auswahlliste entnehmen. Sie müssen diese
Änderung zusammen mit dem Aktions-Feld durchführen, was Sie zur Zeit noch
von Hand ausführen müssen.
END_D
End: 
Id: logedit_activity
Description:: END_D
Sie können hier die mit dem Eintrag verbundene Aktivität ändern.
END_D
End: 
Id: logedit_contact
Description:: END_D
Sie können hier den mit dem Eintrag verbundenen Kontakt ändern.
END_D
End: 
Id: logedit_description
Description:: END_D
Sie können hier die mit dem Eintrag verbundene Beschreibung ändern.
END_D
End: 
Id: logedit_end
Description:: END_D
Sie können die Beendigungszeit dieses Eintrags ändern. Beachten Sie aber,
dass die Startzeit des vorhergehenden Eintrags momentan nicht angepasst
wird.

Diese Anpassung müssen Sie selbst durchführen, wenn Sie Ihre Logs konsistent
halten wollen.
END_D
End: 
Id: logedit_id
Description:: END_D
Dieses Feld zeigt die Identifizierung, die mit dem Log-Eintrag verbunden
ist. Man kann dieses Feld nicht ändern.
END_D
End: 
Id: logedit_project
Description:: END_D
Ändern Sie das Projekt, das mit diesem Eintrag verbunden ist.
END_D
End: 
Id: logedit_rate
Description:: END_D
Sie können hier die mit dem Eintrag verbundene Rate ändern.
END_D
End: 
Id: logedit_start
Description:: END_D
Sie können die Startzeit dieses Eintrags ändern. Beachten Sie aber, dass
die Beendigungszeit des vorhergehenden Eintrags momentan nicht angepasst
wird.

Diese Anpassung müssen Sie selbst durchführen, wenn Sie Ihre Logs konsistent
halten wollen.
END_D
End: 
Id: logsel
Description:: END_D
Der obere Teil des Fensters enthält eine Liste der Log-Dateien, deren Inhalt
Sie sich anschauen können. Einträge in der Liste setzen sich zusammen aus dem
Monat und dem Tag (z.B. 0102 bedeutet 2. Januar). Die Felder unter der Liste
dienen zur Einschränkung dessen, was angezeigt werden soll.
END_D
End: 
Id: logsel_activity
Description:: END_D
Wenn Sie hier einen Typ eine Aktivität auswählen, dann werden nur Einträge
mit diesem Aktivitätstyp angezeigt.
END_D
End: 
Id: logsel_contact
Description:: END_D
Wenn Sie hier einen Kontakt wählen, dann werden nur Einträge angezeigt,
die mit diesem Kontakt verbunden sind. Das kann z.B dazu genutzt werden,
um Themen, die Sie mit einer bestimmten Person in den letzten Monaten
diskutiert haben, zu suchen und anzuzeigen.
END_D
End: 
Id: lvsa_dirname
Description:: END_D
Der Name des Verzeichnisses, wo die zu sichernde Datei gespeichert werden
soll, kann hier eingegeben oder ausgewählt werden.
END_D
End: 
Id: prefs_dateformat
Description:: END_D
Wählen Sie von den gegebenen Optionen Ihr bevorzugtes Format zur Eingabe
und Darstellung von Datumwerten. Taglog arbeitet intern immer im ISO 8601
Format, aber einige Teile des Programms erlauben Ihr bevorzugtes Format.

Beachten Sie, dass die Unterstützung der anderen Formate momentan noch
unvollständig ist.
END_D
End: 
Id: prefs_docdir
Description:: END_D
Taglog speichert seine Dokumentation in diesem Verzeichnis. Wenn Sie diesen
Text lesen, ist der Pfadname für das Dokumentationsverzeichnis wahrscheinlich
richtig. Falls Sie also diesen Text lesen können, sollten Sie den Pfadnamen
NICHT ändern.
END_D
End: 
Id: prefs_language
Description:: END_D
Dieses Feld zeigt Ihre bevorzugte Sprache als ISO 639 Sprachen-Code an.
Momentan ist nur die Hilfe-Information in mehreren Sprachen vorhanden. 
Hilfe bei einer besseren Übersetzung und bei der Erweiterung auf mehr
Sprachen ist erwünscht und wird dankbar angenommen.
END_D
End: 
Id: prefs_rootdir
Description:: END_D
Dateien mit den Daten für taglog sind in diesem Verzeichnis oder dessen
Unterverzeichnis gespeichert.

Bitte beachten Sie, dass Sie bei Änderung dieses Verzeichnisses die schon
existierenden Dateien umkopieren müssen.
END_D
End: 
Id: prefs_showtime_hours_per_day
Description:: END_D
Geben Sie die Länge Ihres Arbeitstages in Stunden (Dezimalschreibweise) an.
Diese Angabe wird im wöchentlichen Zeitbuchungs-Report genutzt, wenn sie
eine Abfrage nach Zeiten in Tagen mit Dezimalschreibweise starten.
END_D
End: 
Id: prefs_showtime_spreadoverheads
Description:: END_D
Wählen Sie diese Option aus, wenn Sie die Zeiten von 'Overhead"-Projekten
standardmäßig auf alle buchbare Projekte verteilen möchten.
END_D
End: 
Id: projects
Description:: END_D
Projekte werden in taglog dazu verwendet um die Arbeitszeit in buchbare
Einheiten aufzuteilen. Die Möglichkeit zur Planung und Kontrolle von
Aktivitäten finden Sie unter 'Aktionen'.

Hinzufügen
	Erzeugt ein neues projekt
Bearbeiten
	Editieren und Löschen von Projekten
Aktualisieren
	Laden von Projektinformationen über eine URL. Diese kann in
	Datei/Einstellungen angegeben werden.
Ansicht	Zeigt an, wie sich die Arveitszeit des aktuellen Tages über die
	Projekte verteilt. Außerdem ist diese Projektansicht bei ikonisiertem
	Hauptfenster vorhanden.
END_D
End: 
Id: reports
Description:: END_D
Taglog kann eine Vielzahl von Berichten aus den gesammelten Informationen
erzeugen.

END_D
End: 
Id: smtp_mailhost
Description:: END_D
Geben Sie den Namen des Rechners an, der als "Mailhost" verwendet
werden soll. Das ist der Rechner, der Ihre Mails an die Empfänger
weiterleitet. Die Vorbesetzung unter UNIX ist hierbei "localhost".
END_D
End: 
Id: smtp_myemail
Description:: END_D
Geben Sie hier Ihre EMail-Adresse an. Diese Adresse
wird in den "Von:"-Teil der EMail eingesetzt.
END_D
End: 
Id: smtp_port
Description:: END_D
SMTP an andere Rechner benutzt normalerweise den Port 25.
Auf einigen Systemen wird der Port 587 für die Versendung
lokaler Mails verwendet.
END_D
End: 
Id: smtp_prefsfile
Description:: END_D
Die Einstellungen für die Mail-Konfiguration sind in einer gesonderten
Datei gespeichert:
UNIX:     ~/.smtp
Windows:  ~/smtp.cfg
Falls keiner dieser Dateien gefunden wird, werden die Parameter mit im
Programm vordefinierten Einstellungen initialisiert.
END_D
End: 
Id: smtp_thishost
Description:: END_D
Geben Sie den Namen dieses Rechners an. Er
wird für den HELO-Teil des SMTP verwendet.
END_D
End: 
Id: summarybox
Description:: END_D
Geben Sie eine Zusammenfassung der Ereignisse dieses Tages.
Wenn Sie hier 'Abbruch' klicken, wird das Programm trotzdem beendet.
Es wird nur keine Zusammenfassung gespeichert.
END_D
End: 
Id: timebook_numweeks
Description:: END_D
Geben Sie die Anzahl der Wochen an, für die Sie einen Report wünschen.
Damit können Sie Reports für mehrere Wochen gleichzeitig erzeugen.
END_D
End: 
Id: timebook_weekno
Description:: END_D
Geben Sie die Kalenderwoche an. Als Vorgabe ist die aktuelle Kalenderwoche
eingegeben. Mit den Schaltflächen "+" und "-" können Sie diese ändern.
END_D
End: 
Id: timebook_year
Description:: END_D
Wählen Sie das Jahr, in dem die Zeitbuchung beginnt. Beachten Sie,
dass Reports, die sich über Jahre ausdehnen, wahrscheinlich nicht
erzeugt werden können.
END_D
End: 
Id: timebooksel
Description:: END_D
Hier können Sie Einstellung zur Berichtgenerierung bearbeiten. Die Zeiten
können in Stunden und Minuten, Stunden in Dezimalschreibweise oder Tage
in Dezimalschreibweise ausgegeben werden. Der Auswahlwert 'Stunden pro Tag'
bestimmt die Umrechnung von Tagen in Dezimalschreibweise.

Die Vorgabe 'Stunden pro Tag' aus Datei/Einstellungen bestimmt die Derzimal-
darstellung der Tage.

Wenn sie die Option 'Overhead-Projekte aufteilen' wählen, dann werden die
Zeiten, die auf die Projekte, die mit 'overhead' markiert sind, auf alle
übrigen Projekte (mit Ausnahme der Projekte, die mit 'Pause' markiert sind)
verteilt. Die 'overhead'-Zeiten für jeden Tag werden nach der Zeitaufteilung
der buchbaren Projekte einer Woche verteilt.

Sie können auswählen, ob die Projekte anhand des Buchungscodes, des Namens
oder beider Kriterien dargestellt werden sollen. Wenn Sie den Buchungscode
wählen und mehr als ein Projekt mit dem gleichen Buchungscode existiert, dann
werden deren Gesamtsummen dargestellt.

Geben Sie ein Jahr an, wenn sie nicht das aktuelle Jahr auswählen wollen.
Die Kalenderwoche für den Report können Sie eingeben oder mit den Schalt-
flächen "+" und "-" verändern.
END_D
End: 
Id: timebooksel_timeformat
Description:: END_D
Zeiten könne ausgegeben werden als:
. Stunden und Minuten
. Stunden in Dezimalschreibweise
. Tagen in Dezimalschreibweise

Der Auswahlwert 'Stunden pro Tag' in Datei/Einstellungen bestimmt die
Umrechnung von Tagen in Dezimalschreibweise.
END_D
End: 
Id: UNKNOWN
Description:: END_D
Zu diesem Thema gibt es keinen Hilfetext. Ich wäre sehr dankbar, wenn Sie
eine Übersetzung an john+taglog@paladyn.org senden könnten.
END_D
End: 
Id: viewc
Description:: END_D
Mit der rechten Maustaste können Sie einen Kontakt auswählen,
um ihn zu editieren.
END_D
End: 
Id: viewproject
Description:: END_D
Die Darstellung 'Projektzeiten' zeigt die kumulative Zeit für alle
Projekte an, die für den aktuellen Tag Zeit verbucht haben.
Außerdem wird die Gesamtzeit für alle Projekte und für alle Projekte, die
nicht mit 'Pause' bezeichnet sind, aufgführt.

Projekte, für die die Zeiten beim Öffnen dieses Fensters noch nicht ver-
bucht waren, werden nicht angezeigt. Erst wenn Sie die Schaltfläche OK be-
tätigen und dann nochmal 'Projekte/Ansicht' auswählen, erscheinen sie.

Sie können durch Klicken auf 'Projekt' zu anderen Projekten wechseln.
END_D
End: 
