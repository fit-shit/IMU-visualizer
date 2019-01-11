import processing.serial.*;

Serial myPort;
String val;

void setup() {
  size(800, 800, P3D);
  frameRate(200);
  smooth();
  
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 38400);
  
  background(20,20,20);
  
}

void draw() {
  
  
  
  
  if ( myPort.available() > 0) { 
    val = myPort.readStringUntil('\n');
  } 
  if (val != null) {
    float[] list = float(split(val, ','));
    println(val);
    if (list.length == 4) {
      background(20,20,20);
      lights();
      for (int i = 0; i<4; i++) {
        drawBox(list[0], list[1], list[2], list[3], i);
      }
      
    }
  }
}

void drawBox(float rotX, float rotY, float rotZ, float zPos, int quadrant) {
  int h = 120, w = 40, d = 200; 
  int column = quadrant % 2;
  int row = quadrant / 2;
 
  pushMatrix();
  float centerX = (400 * column) + 200 - (w / 2);
  float centerY = (400 * row) + 200 - (h / 2) - zPos; 
   
  translate(centerX, centerY, 0); 
  rotateZ(rotX);
  rotateX(rotY);
  rotateY(rotZ);
  noStroke();
  fill(255 * column, 255 * row, 255);
  box(h, w, d);

  popMatrix();

}
