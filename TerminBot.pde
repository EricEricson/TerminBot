import java.io.File;
import java.util.List;
import java.util.regex.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
PFont f;

// Variable to store text currently being typed
String eingabe = "";

// Variable to store saved text when return is hit
String saved = "";
int state = 0;


Headtracking head;
TextToSpeech speech;
Capture video;
OpenCV opencv;

void setup() {
  size(800, 600);
  f = createFont("Arial",16);
  
  
  video = new Capture(this, 320/2, 240/2);
  opencv = new OpenCV(this, 320/2, 240/2);
  head = new Headtracking(video, opencv);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();
  
  speech = new TextToSpeech(new Minim(this));  
}

void draw() {
  // Damit man sofort mit der Eingabe beginnen kann oder das Fenster erst anklicken zu müssen
  frame.toFront();
  frame.requestFocus();
    
  background(255);
  
  textFont(f);
  fill(0, 88, 132);
  
    switch (state) {     
      case 1: 
         if(key == '\n' && state == 1 ){
           writeTermin();         
         }
      
        break;
      case 2:
        if(key == '\n' && state == 2 ){
          
          
        text ("Bot: Möchtest du den Termin wirklich löschen? ", 25, 100);
        if(head.isRight()){
           deleteTermin(); 
           state = 0;}         
       else if(head.isLeft()){
         state = 0;}
       }
        break;
      case 3:
        text ("Bot: Das sind all deine Termine: ", 25, 100);
        break;
      case 4:
        text ("Bot: Das sind all deine Termine: ", 25, 100);
        allDates();
        break;
        
        case 99:        
        text ("Bot: Das habe ich leider nicht verstanden. :(", 25, 80);
    }
  
  // Display everything
  text("Bot: Wie kann ich dir helfen? ", 25, 40);
  text ("Befehle:         [anlegen]           [ausgeben]         [löschen]", 25, 64);
  fill(0);
  text("Du: " + eingabe,25,500);
  head.track();
  if (head.isNeutral()){
    fill(12, 127, 0);
    circle(200, 10, 5);
  }else{
    fill(255, 0, 0);
    circle(200, 10, 5);
  }
}

void captureEvent(Capture c) {
  c.read();
}


void keyPressed() {    
  // Wenn Enter gedrückt wird überprüfe den String
  if (key == '\n' ) {
    saved = eingabe;
       
        if(eingabe.contains("anlegen")) {
           state = 1;
        } else if(eingabe.contains("löschen")) {
          state = 2;
          //head.resetHead();
        } else if(eingabe.contains("ausgeben")) {
          state = 3;
          readTermin();
        }else if (eingabe.contains("alle termine") || eingabe.contains("alle Termine") || eingabe.contains("Alle Termine")) {
          state = 4;
        
        } else if(eingabe.contains("beenden") || eingabe.contains("exit") || eingabe.contains("schließen")) {
          exit(); 
          return;
          
        } else{ //<>//
          state = 99;
        }
    
      
       
    // String leeren
    eingabe = "";
  }    
  else if(key == BACKSPACE) { 
      if (eingabe.length() > 0) {
        eingabe = eingabe.substring(0, eingabe.length() - 1);
      }
   }
   else if(key == TAB){
     eingabe = eingabe + " ";
   }
   else if(key != CODED) {    
    // Ansonsten erweitere den String
    eingabe = eingabe + key; 
  }
}

static Iterable<MatchResult> findMatches( String pattern, CharSequence s )
{
  List<MatchResult> results = new ArrayList<MatchResult>();

  for ( Matcher m = Pattern.compile(pattern).matcher(s); m.find(); )

    results.add( m.toMatchResult() );

  return results;
}

/***** TERMINE ANLEGEN *****/
void writeTermin(){
  
 try {
    
    //String aktion = "[A-Z][a-z]* [[A-Z][a-z]]? ";
    //String aktion = "[[A-Z][a-z]*] ]{1,3}";
    String aktion = "[A-Z][a-z]*]";
    MatchResult matchAction = findMatches( aktion, saved ).iterator().next();
    
    //Tag Monat Jahr durch Punkte getrennt
    String datum = "[0-3]?[0-9]\\.[0-1]?[0-9]\\.[1-2][0-9][0-9][0-9]";
    MatchResult matchDate = findMatches( datum, saved ).iterator().next();
    
    // mindestens ein Zahl, endet mit Uhr  -> z.B 9 Uhr oder 09 Uhr oder 09:00 Uhr...
    String uhrzeit = "[0-2]?[0-9]\\:?[0-9]?[0-9]? Uhr";
    MatchResult matchTime = findMatches( uhrzeit, saved ).iterator().next();  
    
    String terminDate = matchDate.group();    
    String terminTime = matchTime.group();    
    String terminAction = matchAction.group();
   
    
   saved = terminAction +  " am " + terminDate + " um " + terminTime;
    
   final String archive = dataPath(terminDate + ".txt");
   String[] list = split(saved, ',');
    
    
    saveStrings(archive, list);
    println("\n\nDatei gespeichert!\n");
    
   text ("Bot: Ich habe den Termin >> " + terminAction + " am "  + terminDate + " um " + terminTime  + " << gespeichert.", 25, 120);

  } catch (Exception error_write) {
     System.out.println("error_write"); 
     text("Bot: Keinen Termin in der Eingabe gefunden. ", 25, 100); 
  }
}


/***** TERMINE LÖSCHEN *****/
void deleteTermin(){
  try{
    String datum = "[0-3][0-9]\\.[0-1][0-9]\\.[1-2][0-9][0-9][0-9]";
    MatchResult matchDate = findMatches( datum, saved ).iterator().next();
    String terminDate = matchDate.group(); 
    
    
      String textDatei = dataPath(terminDate + ".txt");
      
      File f = dataFile(textDatei);
      String filePath = f.getPath();
      boolean exist = f.isFile();
      if(exist){println(filePath + "datei geht");}
      else{println(filePath + "datei geht nicht");}
      
      
      
      
      File del = new File(textDatei);
      text ("Bot: Ich habe alle Termine am " + terminDate + " gelöscht. ", 25, 100);
      del.delete();
      
  } catch (Exception error_del){
      System.out.println("error_del");
      
      text ("Bot: Es existieren keine Termine, die gelöscht werden können.", 25, 120);
    }  
}



/***** TERMINE AUSGEBEN *****/
void readTermin(){
  try {
    String datum = "[0-3]?[0-9]\\.[0-1]?[0-9]\\.[1-2][0-9][0-9][0-9]";
    MatchResult matchDate = findMatches( datum, saved ).iterator().next();
    String terminDate = matchDate.group();  
    String ausgabe[] = loadStrings(terminDate + ".txt");
    for (int i = 0 ; i < ausgabe.length; i++) {      
      //text((i+1) + ".            " + ausgabe[i], 25, 140+(i*20));
     System.out.println(ausgabe[i]);
     speech.playString(ausgabe[i]);
     delay(6000); // wartet nach jeder Ausgabe 6 Sekunden damit .mp3 komplett abgespielt wird
    }
  }catch (Exception error_read) {   
    text("Bot: Keinen Termin gefunden. ", 25, 100); 
    System.out.println("error_read"); 
  }
}


/***** ALLE TERMIN-DATEIEN AUS VERZEICHNIS AUSGEBEN *****/
void allDates(){
   File[] files = listFiles("C:/Users/s77273/Desktop/TerminBot/data");
   for (int i = 0; i < files.length; i++) {
      File f = files[i];   
      if(f.getName() != "sounds"){
        text( i+1 + ". Termine: " + f.getName(), 25, 140+(i*20));
      }
   }
}
