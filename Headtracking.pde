import gab.opencv.*;
import processing.video.*;
import java.awt.*;

public class Headtracking{
Capture video;
OpenCV opencv;
int leftOrRight = 0;
int leftLimit = 60;
int rightLimit = 40;
int upLimit = 55;
int downLimit = 35;



public Headtracking(Capture video, OpenCV cv){
  this.video= video;
  this.opencv = cv;

}

public void resetHead(){
 leftOrRight = 0;
}

public boolean isRight(){
    return leftOrRight == 1;
};

public boolean isLeft(){
    return leftOrRight == -1;
};

public boolean isNeutral(){
    return leftOrRight == 0;
};


void track() {
  scale(2);
  opencv.loadImage(video);

  //image(video,0, 0 );

  noFill();
  stroke(255, 255, 255);
  strokeWeight(0);
  Rectangle[] faces = opencv.detect();
  if (faces.length > 0) {
    if (faces[0].x < rightLimit && leftOrRight <= 0) {
      println("RIGHT");
      leftOrRight = 1;
      
    } else if (faces[0].x > leftLimit && leftOrRight >= 0){
      println("LEFT");
      leftOrRight = -1;
    } else if(faces[0].x < leftLimit && faces[0].x > rightLimit && leftOrRight != 0){
      println("NEUTRAL");
      leftOrRight = 0;
    }
    
   }
   
/*   if (faces.length > 0) {
    if (faces[0].y < upLimit && leftOrRight <= 0) {
      println("UP");
      leftOrRight = 1;
      
    } else if (faces[0].y > downLimit && leftOrRight >= 0){
      println("DOWN");
      leftOrRight = -1;
    } else if(faces[0].x > downLimit && faces[0].x < upLimit && leftOrRight != 0){
      println("NEUTRAL");
      leftOrRight = 0;
    }
    
   }
*/

  for (int i = 0; i < faces.length; i++) {
    // println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);    
  }
}


}
