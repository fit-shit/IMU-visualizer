// IMPORT LIBRARIES
import processing.serial.*;


// SET GLOBAL VARIABLES
Serial myPort;
String val;



void setup() {
  /**
   *  The setup method is where the program is initially configured. Here, we'll set 
   *  the important view properties that remain constant throughout the lifecycle of
   *  the program such as view size, 2D/3D, frame rate, background color, serial 
   *  monitors, etc.
   *
   *  Note that setup() only runs ONCE when the program is first started. After setup()
   *  finishes executing, the program will move to the draw() loop, which runs indefinetly.
   *
   */
  
  // Set inital parameters of program view.
  size(800, 800, P3D);
  frameRate(200);
  smooth();
  
  // Set myPort to monitor the serial line at 38400 baud for data incoming from IMU module.
  String portName = Serial.list()[17];
  myPort = new Serial(this, portName, 38400);
  
  // Set initial background color to rgb(20,20,20).
  background(20,20,20);
  
}



void draw() {
  /**
   *  The draw() method is the meat and potatoes of this program. This is called once setup()
   *  is done executing, and will run over and over again until the program is ended.
   *
   *  Here, we'll want to pull the latest data from the serial monitor and process the 
   *  GUI accordingly - rotating and translating the shapes by the data calculated by the 
   *  IMU module.
   *
   */
  
  // If serial monitor has avaliable data, read the serial monitor, myPort, until it 
  // recieves a newline character '\n'.
  if ( myPort.available() > 0) val = myPort.readStringUntil('\n');
      
  if (val != null) {
    // If val contains data, split val into an array of float's by looking for commas.
    
    float[] list = float(split(val, ','));
    
    if (list.length == 9) {
      // Draw 3 unit axis of body
      
      drawWorldAxis(false, list);
      
      drawLine(list[0], list[1], list[2],0);
      drawLine(list[3], list[4], list[5],1);
      drawLine(list[6], list[7], list[8],2);

    } else if (list.length == 4) {
      
       drawWorldAxis(false, list);
      
       drawLine(list[1], list[2], list[3],3);
       drawLine(0, 0, 1,0);  
    }
  }
}


void drawWorldAxis(boolean drawAxisSphere, float[] list) {
  background(20,20,20);
  lights();
      
  pushMatrix();
  float unit_length = 300;
  translate(400,400,0);
  rotateX(60 * 0.0174533);
  rotateZ(15 * 0.0174533);
  rotateY(0 * 0.0174533);
 
  lights();
  stroke(255,0,0);
  line(0, 0, 0, unit_length, 0, 0);
  stroke(0,255,0);
  line(0, 0, 0, 0, unit_length, 0);
  stroke(0,0,255);
  line(0, 0, 0, 0, 0, unit_length);
  
  if(drawAxisSphere == true) {
    fill(255,0,0);
    translate(unit_length*list[0], 0, 0);
    sphere(14);
    fill(0,255,0);
    translate(-unit_length*list[0], unit_length*list[4], 0);
    sphere(14);
    translate(0, -unit_length*list[4], unit_length*list[8]);
    fill(0,0,255);
    sphere(14);
  }
  
  popMatrix();
}


void drawLine(float unitX, float unitY, float unitZ, int col) {
  
  
  color lineColor = color(255,255,255);
  switch (col) {
     case 0:
     lineColor = color(0,255,255);
     break;
     case 1:
     lineColor = color(255,255,0);
     break;
     case 2:
     lineColor = color(255,0,255);
     break;
     case 3:
     lineColor = color(220,220,220);
     break;
  }
  
  pushMatrix();
  float unit_length = 200;
  translate(400,400,0);
  rotateX(60 * 0.0174533);
  rotateZ(15 * 0.0174533);
  rotateY(0 * 0.0174533);
  
  stroke(lineColor);
  strokeWeight(4);
  line(0, 0, 0, unitX*unit_length, unitY*unit_length, unitZ*unit_length);

  lights();
  noStroke();
  fill(lineColor);
  translate(unitX*unit_length, unitY*unit_length, unitZ*unit_length);
  sphere(20);

  popMatrix();
  
}

// CUSTOM MOETHODS

void drawBox(float rotX, float rotY, float rotZ, float zPos, int quadrant) {
  /**
   *  Call to draw a box on the screen at given quadrant with given rotational parameters
   *  and 3D translation parameters.
   *
   *  @param     rotX     <float>     Absolute rotation about X-axis (in rads)
   *  @param     rotY     <float>     Absolute rotation about Y-axis (in rads)
   *  @param     rotZ     <float>     Absolute rotation about Z-axis (in rads)
   *  @param     zPos     <float>     Absolute position along Z-axis (unspecified unit)
   */
   
  // Define box's height (h), width (w), and depth (d).
  int h = 120, w = 40, d = 200; 
  
  // Calculate the row and column in the 2x2 set of the quadrant to draw the box in.
  int column = quadrant % 2;
  int row = quadrant / 2;
 
  // Calling pushMatrix() followed by popMatrix() will reset the translate and rotate
  // positions to 0 (otherwise they are cumulative; the values of each are based on the 
  // last value that they were set to).
  pushMatrix();
  
  // Calculate the centered X and Y positions to draw each box.
  float centerX = (400 * column) + 200 - (w / 2);
  float centerY = (400 * row) + 200 - (h / 2);// - zPos; 
   
  // Set drawing tool to position and orientation according to the provided data.
  translate(centerX, centerY, 0); 
  rotateZ(rotX);
  rotateX(rotY);
  rotateY(rotZ);
  
  // Change fill colour based on row and column so that we can differentiate between each.
  fill(255 * column, 255 * row, 255);
  noStroke();

  // Draw box with previously defined size constraints.
  box(h, w, d);

  // Again, calling popMatrix() resets the translate and rotate positions to 0.
  popMatrix();

}
