# TerminBot (Processing) 
## Einleitung
TerminBot ist eine Projektarbeit, die aus dem Multimodale Mensch-Maschine-Interaktion hervorgeht. Die Software ermöglicht es Termine auf neuartige Weise zu verwalten!

## Bibliotheken und Hardware
Laden Sie sich die aktuellste Version von Processing herunter: <a href="https://processing.org/download/" target="_blank">hier</a>. Bevor das Programm gestartet werden kann, müssen einige Bibliotheken bei Processing installiert werden. Die Bibliotheken <em>Minim</em>, <em>OpenCV for Processing</em> und <em>Video</em> sind Voraussetzung. Zudem wird eine Webcam benötigt. Nach der Installation der Bibliotheken ist die Klasse <em>TerminBot</em> ausführbar.

## Funktionalitäten
Folgende Funktionalitäten wurden implementiert:
<ul>
  <li>Termin anlegen</li>
  <li>Termin ausgeben</li>
  <li>Alle Termine ausgeben</li>
  <li>Termin löschen</li>
</ul> 

Die Funktion Termin anlegen wird von RegEx gestützt. Dies versichert eine einheitliche Notation. So muss zum Beispiel eine Termin-Bezeichnung, ein Datum und eine Uhrzeit angegeben werden. Dies könnte so aussehen: Friseur 21.06.2019 18 Uhr anlegen . Der Termin wird in einer Textdatei abgespeichert. Möchte man sich nun alle Termine anzeigen lassen, so schreibt man: Alle Termine. Es wird eine Liste mit allen Termine angezeigt. Sucht man sich einen gewissen Termin heraus, so zum Beispiel unseren eben angelegten Friseurtermin, und schreibt 21.06.2019 ausgeben wird der Termin visuell dargestellt und auditiv ausgegeben. Dies wurde mit Google TexteToSpeech erzielt. Einen Termin löscht man einfach mit dem Satz 21.06.2019 18 Uhr löschen. Der Nutzer wird aufgefordert dies mit einer Kopfbewegung zu bestätigen (nach links -> Vorgang abbrechen / nach rechts -> Vorgang bestätigen).
