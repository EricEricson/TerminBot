/** 
 * Sources for this file:
 *
 * https://amnonp5.wordpress.com/2011/11/26/text-to-speech/
 * http://code.compartmental.net/tools/minim/
 * https://stackoverflow.com/questions/35002003/how-to-use-google-translate-tts-with-the-new-v2-api
 */

import ddf.minim.*;
import java.net.*;
import java.io.*;

public class TextToSpeech {

  AudioPlayer player;
  Minim minim;

  String sketchPath = "C:/[FILE PATH]";
   
  public TextToSpeech(Minim minim) {
    this.minim = minim;
  }
   
  void visualize() {
    if (player != null) {
      translate(0, 250);
      for(int i = 0; i < player.left.size()-1; i++) {
        line(i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50);
        line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
      }
    }
  }
  
  void playString(String s) {
      googleTTS(s, "de");
      if (player != null) { player.close(); } // comment this line to layer sounds
      player = minim.loadFile(sketchPath + "/" + s + ".mp3", 2048);
      player.play();
  }
  
  void stopPlaying() {
      if (player != null) {
        player.pause();
        player = null;
      }  
  }
   
  void googleTTS(String txt, String language) {
    String u = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=";    
    u = u + language + "&q=" + txt;
    u = u.replace(" ", "%20");
    try {
      URL url = new URL(u);
      try {
        URLConnection connection = url.openConnection();
        connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");
        connection.connect();
        InputStream is = connection.getInputStream();
        String filePath= sketchPath + "/" + txt + ".mp3";
        System.out.println(filePath);
        File f = new File(filePath);
        OutputStream out = new FileOutputStream(f);
        byte buf[] = new byte[1024];
        int len;
        while ((len = is.read(buf)) > 0) {
          out.write(buf, 0, len);
        }
        out.close();
        is.close();
        println("File created: " + txt + ".mp3");
      } catch (IOException e) {
        e.printStackTrace();
      }
    } catch (MalformedURLException e) {
      e.printStackTrace();
    }
  }
   
  void stop() {
    player.close();
    minim.stop();
  }
}
