import oscP5.*;
import netP5.*;
import java.util.concurrent.ThreadLocalRandom;
import java.io.PrintWriter; 
import java.io.FileOutputStream;

//Created by Jory Alexander on 5/8/2017

// set up the OSC stuff
OscP5 oscP5;
NetAddress myRemoteLocation;

PrintWriter writer;
StringBuilder sb;

//update this filepath to corespond to your computer Macs will require a full filepath
//as opposed to a relative filepath. You should just be able to update Jory to your user
//name
final String FILE_PATH = "/Users/Jory/Desktop/Brain Mapping/data.csv";

float[] alphaAb = new float[4];
float[] betaAb = new float[4];
float[] deltaAb = new float[4];
float[] thetaAb = new float[4];
float[] gammaAb = new float[4];
float[] alphaRel = new float[4];
float[] betaRel = new float[4];
float[] deltaRel = new float[4];
float[] thetaRel = new float[4];
float[] gammaRel = new float[4];
float[] status = new float[4];

int battery;
long startTime;

String direction = "";

boolean firstRun = true;
boolean isRecording = false;
boolean overMiddle = false;
boolean overLeft = false;
boolean overRight = false;
boolean overTop = false;
boolean overBottom = false;
boolean leftHighlighted = false;
boolean rightHighlighted = false;
boolean bottomHighlighted = false;
boolean topHighlighted = false;
boolean middleHighlighted = false;

Square middle;
Square left;
Square right;
Square top;
Square bottom;

void setup() {
  // Specify the screen size
  size(800, 600);

  // Set up the OSC stuff
  oscP5 = new OscP5(this, 5000);
  myRemoteLocation = new NetAddress("127.0.0.1", 5000);
  
   // Set the background color of the screen
  background(211,211,211);

  // Specify that we're in HSB color mode
  colorMode(RGB);
}

//this method is called by processing on every refresh of the squeen
//it grabs the data from the muse headband based on different paths and datatypes
void oscEvent(OscMessage theOscMessage){
  //status of the sensors 1 = good, 2 = ok >=3 is bad 
  if(theOscMessage.checkAddrPattern("/muse/elements/horseshoe")) {
    if(theOscMessage.checkTypetag("ffff")) {
      status[0] = theOscMessage.get(0).floatValue();
      status[1] = theOscMessage.get(1).floatValue();
      status[2] = theOscMessage.get(2).floatValue();
      status[3] = theOscMessage.get(3).floatValue();
    }
  }
  
  //relative reading from headband
   if(theOscMessage.checkAddrPattern("/muse/elements/alpha_relative")){
     if(theOscMessage.checkTypetag("ffff")){
        alphaRel[0] = theOscMessage.get(0).floatValue();
        alphaRel[1] = theOscMessage.get(1).floatValue();
        alphaRel[2] = theOscMessage.get(2).floatValue();
        alphaRel[3] = theOscMessage.get(3).floatValue();
        
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/beta_relative")){
     if(theOscMessage.checkTypetag("ffff")){
        betaRel[0] = theOscMessage.get(0).floatValue();
        betaRel[1] = theOscMessage.get(1).floatValue();
        betaRel[2] = theOscMessage.get(2).floatValue();
        betaRel[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/delta_relative")){
     if(theOscMessage.checkTypetag("ffff")){
        deltaRel[0] = theOscMessage.get(0).floatValue();
        deltaRel[1] = theOscMessage.get(1).floatValue();
        deltaRel[2] = theOscMessage.get(2).floatValue();
        deltaRel[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/theta_relative")){
     if(theOscMessage.checkTypetag("ffff")){
        thetaRel[0] = theOscMessage.get(0).floatValue();
        thetaRel[1] = theOscMessage.get(1).floatValue();
        thetaRel[2] = theOscMessage.get(2).floatValue();
        thetaRel[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/gamma_relative")){
     if(theOscMessage.checkTypetag("ffff")){
        gammaRel[0] = theOscMessage.get(0).floatValue();
        gammaRel[1] = theOscMessage.get(1).floatValue();
        gammaRel[2] = theOscMessage.get(2).floatValue();
        gammaRel[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  //Absolute Readings from headband
  if(theOscMessage.checkAddrPattern("/muse/elements/alpha_absolute")){
     if(theOscMessage.checkTypetag("ffff")){
        alphaAb[0] = theOscMessage.get(0).floatValue();
        alphaAb[1] = theOscMessage.get(1).floatValue();
        alphaAb[2] = theOscMessage.get(2).floatValue();
        alphaAb[3] = theOscMessage.get(3).floatValue();
        
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/beta_absolute")){
     if(theOscMessage.checkTypetag("ffff")){
        betaAb[0] = theOscMessage.get(0).floatValue();
        betaAb[1] = theOscMessage.get(1).floatValue();
        betaAb[2] = theOscMessage.get(2).floatValue();
        betaAb[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/delta_absolute")){
     if(theOscMessage.checkTypetag("ffff")){
        deltaAb[0] = theOscMessage.get(0).floatValue();
        deltaAb[1] = theOscMessage.get(1).floatValue();
        deltaAb[2] = theOscMessage.get(2).floatValue();
        deltaAb[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/theta_absolute")){
     if(theOscMessage.checkTypetag("ffff")){
        thetaAb[0] = theOscMessage.get(0).floatValue();
        thetaAb[1] = theOscMessage.get(1).floatValue();
        thetaAb[2] = theOscMessage.get(2).floatValue();
        thetaAb[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/elements/gamma_absolute")){
     if(theOscMessage.checkTypetag("ffff")){
        gammaAb[0] = theOscMessage.get(0).floatValue();
        gammaAb[1] = theOscMessage.get(1).floatValue();
        gammaAb[2] = theOscMessage.get(2).floatValue();
        gammaAb[3] = theOscMessage.get(3).floatValue();
     }
  }
  
  if(theOscMessage.checkAddrPattern("/muse/batt")){
     if(theOscMessage.checkTypetag("iiii")){
        battery = theOscMessage.get(0).intValue() + theOscMessage.get(1).intValue() + theOscMessage.get(2).intValue() + theOscMessage.get(3).intValue() /4;
     }
  }
  
  
}

void draw() {

  if(firstRun) {
    intializeSquares();
    drawInitialSquares();
    firstRun = false;
    text("Click the middle button to begin recording. \nMove your mouse over the green highlighted block. \nClick the middle block to proceed to the next prompt.",10,10);
    writeLables();
    
  }
  else {
    update();
    if(overMiddle){
      if(middleHighlighted) {
        middleHighlighted = false;
        isRecording = false;
      }
      middle.setColor(255,0,0);
      middle.drawSquare();
    }else if (!middleHighlighted){
      middle.setColor(0,0,0);
      middle.drawSquare();
    }
    
    if(overLeft){
      if(leftHighlighted) {
        leftHighlighted = false;
        isRecording = false;
      }
      left.setColor(255,0,0);
      left.drawSquare();
    }else if(!leftHighlighted){
      left.setColor(0,0,0);
      left.drawSquare();
    }
    
    if(overRight){
      if(rightHighlighted) {
        rightHighlighted = false;
        isRecording = false;
      }
      right.setColor(255,0,0);
      right.drawSquare();
    }else if(!rightHighlighted){
      right.setColor(0,0,0);
      right.drawSquare();
    }
    
    if(overTop){
      if(topHighlighted)  {
        topHighlighted = false;
        isRecording = false;
      }
      top.setColor(255,0,0);
      top.drawSquare();
    }else if(!topHighlighted){
      top.setColor(0,0,0);
      top.drawSquare();
    }
    
    if(overBottom){
      if(bottomHighlighted) {
        bottomHighlighted = false;
        isRecording = false;
      }
      bottom.setColor(255,0,0);
      bottom.drawSquare();
    }else if (!bottomHighlighted){
      bottom.setColor(0,0,0);
      bottom.drawSquare();
    }
  }
  
  if(isRecording) {
      int randomNum = ThreadLocalRandom.current().nextInt(0, 4);
      if(!topHighlighted && !bottomHighlighted && !leftHighlighted && !rightHighlighted && !middleHighlighted) {
        direction = determineDirection(randomNum);
      }
      highlightSquare(direction);
      
      writeData();
  }

  }

//determines weather any of the square are being hovered over
void update() {
  if(overMiddle()) {
    overMiddle = true;
    overLeft = false;
    overRight = false;
    overTop = false;
    overBottom = false;
  } else if(overLeft()) {
    overMiddle = false;
    overLeft = true;
    overRight = false;
    overTop = false;
    overBottom = false;
  } else if (overRight()) {
    overMiddle = false;
    overLeft = false;
    overRight = true;
    overTop = false;
    overBottom = false;
  } else if(overTop()) {
    overMiddle = false;
    overLeft = false;
    overRight = false;
    overTop = true;
    overBottom = false;
  } else if(overBottom()) {
    overMiddle = false;
    overLeft = false;
    overRight = false;
    overTop = false;
    overBottom = true;
  } else {
    overMiddle = false;
    overLeft = false;
    overRight = false;
    overTop = false;
    overBottom = false;
  }
  
}

//writes the data to a csv file
void writeData() {
  try {
      sb = new StringBuilder();
      sb.append(System.currentTimeMillis() - startTime);
      sb.append(",");
      sb.append(alphaAb[0]);
      sb.append(",");
      sb.append(alphaAb[1]);
      sb.append(",");
      sb.append(alphaAb[2]);
      sb.append(",");
      sb.append(alphaAb[3]);
      sb.append(",");
      sb.append(betaAb[0]);
      sb.append(",");
      sb.append(betaAb[1]);
      sb.append(",");
      sb.append(betaAb[2]);
      sb.append(",");
      sb.append(betaAb[3]);
      sb.append(",");
      sb.append(deltaAb[0]);
      sb.append(",");
      sb.append(deltaAb[1]);
      sb.append(",");
      sb.append(deltaAb[2]);
      sb.append(",");
      sb.append(deltaAb[3]);
      sb.append(",");
      sb.append(gammaAb[0]);
      sb.append(",");
      sb.append(gammaAb[1]);
      sb.append(",");
      sb.append(gammaAb[2]);
      sb.append(",");
      sb.append(gammaAb[3]);
      sb.append(",");
      sb.append(thetaAb[0]);
      sb.append(",");
      sb.append(thetaAb[1]);
      sb.append(",");
      sb.append(thetaAb[2]);
      sb.append(",");
      sb.append(thetaAb[3]);
      sb.append(",");
      sb.append(alphaRel[0]);
      sb.append(",");
      sb.append(alphaRel[1]);
      sb.append(",");
      sb.append(alphaRel[2]);
      sb.append(",");
      sb.append(alphaRel[3]);
      sb.append(",");
      sb.append(betaRel[0]);
      sb.append(",");
      sb.append(betaRel[1]);
      sb.append(",");
      sb.append(betaRel[2]);
      sb.append(",");
      sb.append(betaRel[3]);
      sb.append(",");
      sb.append(deltaRel[0]);
      sb.append(",");
      sb.append(deltaRel[1]);
      sb.append(",");
      sb.append(deltaRel[2]);
      sb.append(",");
      sb.append(deltaRel[3]);
      sb.append(",");
      sb.append(gammaRel[0]);
      sb.append(",");
      sb.append(gammaRel[1]);
      sb.append(",");
      sb.append(gammaRel[2]);
      sb.append(",");
      sb.append(gammaRel[3]);
      sb.append(",");
      sb.append(thetaRel[0]);
      sb.append(",");
      sb.append(thetaRel[1]);
      sb.append(",");
      sb.append(thetaRel[2]);
      sb.append(",");
      sb.append(thetaRel[3]);
      sb.append(",");
      sb.append(battery);
      sb.append(",");
      sb.append(status[0]);
      sb.append(",");
      sb.append(status[1]);
      sb.append(",");
      sb.append(status[2]);
      sb.append(",");
      sb.append(status[3]);
      sb.append(",");
      sb.append(direction);
      sb.append("\n");
      
      writer = new PrintWriter(new FileOutputStream(FILE_PATH,true));
      writer.append(sb.toString());
      writer.close();
      

    } catch (IOException e) {
      e.printStackTrace();
    } 
}

//writes all the data lables to a csv file
void writeLables() {
  try { 
      sb = new StringBuilder();
      sb.append("Time");
      sb.append(",");
      sb.append("Alpha Absolute 1");
      sb.append(",");
      sb.append("Alpha Absolute 2");
      sb.append(",");
      sb.append("Alpha Absolute 3");
      sb.append(",");
      sb.append("Alpha Absolute 4");
      sb.append(",");
      sb.append("Beta Absolute 1");
      sb.append(",");
      sb.append("Beta Absolute 2");
      sb.append(",");
      sb.append("Beta Absolute 3");
      sb.append(",");
      sb.append("Beta Absolute 4");
      sb.append(",");
      sb.append("Delta Absolute 1");
      sb.append(",");
      sb.append("Delta Absolute 2");
      sb.append(",");
      sb.append("Delta Absolute 3");
      sb.append(",");
      sb.append("Delta Absolute 4");
      sb.append(",");
      sb.append("Gamma Absolute 1");
      sb.append(",");
      sb.append("Gamma Absolute 2");
      sb.append(",");
      sb.append("Gamma Absolute 3");
      sb.append(",");
      sb.append("Gamma Absolute 4");
      sb.append(",");
      sb.append("Theta Absolute 1");
      sb.append(",");
      sb.append("Theta Absolute 2");
      sb.append(",");
      sb.append("Theta Absolute 3");
      sb.append(",");
      sb.append("Theta Absolute 4");
      sb.append(",");
      sb.append("Alpha Relative 1");
      sb.append(",");
      sb.append("Alpha Relative 2");
      sb.append(",");
      sb.append("Alpha Relative 3");
      sb.append(",");
      sb.append("Alpha Relative 4");
      sb.append(",");
      sb.append("Beta Relative 1");
      sb.append(",");
      sb.append("Beta Relative 2");
      sb.append(",");
      sb.append("Beta Relative 3");
      sb.append(",");
      sb.append("Beta Relative 4");
      sb.append(",");
      sb.append("Delta Relative 1");
      sb.append(",");
      sb.append("Delta Relative 2");
      sb.append(",");
      sb.append("Delta Relative 3");
      sb.append(",");
      sb.append("Delta Relative 4");
      sb.append(",");
      sb.append("Gamma Relative 1");
      sb.append(",");
      sb.append("Gamma Relative 2");
      sb.append(",");
      sb.append("Gamma Relative 3");
      sb.append(",");
      sb.append("Gamma Relative 4");
      sb.append(",");
      sb.append("Theta Relative 1");
      sb.append(",");
      sb.append("Theta Relative 2");
      sb.append(",");
      sb.append("Theta Relative 3");
      sb.append(",");
      sb.append("Theta Relative 4");
      sb.append(",");
      sb.append("Battery Level");
      sb.append(",");
      sb.append("Status Indicator 1");
      sb.append(",");
      sb.append("Status Indicator 2");
      sb.append(",");
      sb.append("Status Indicator 3");
      sb.append(",");
      sb.append("Status Indicator 4");
      sb.append(",");
      sb.append("Direction");
      sb.append("\n");
      
      writer = new PrintWriter(new FileOutputStream(FILE_PATH));
      
      writer.write(sb.toString());
      writer.close();
      

    } catch (IOException e) {
      e.printStackTrace();
    } 
}

//Determines if the mouse is pressed and if so which square is pressed. If the middle square
//is pressed the program begins recording data.
void mousePressed() {
  if (overMiddle) {
    if(!isRecording) {
      isRecording = true;
      startTime = System.currentTimeMillis();
  }
}
  if (overLeft) {
    if(isRecording) {
      isRecording = false;
    }
  }
   if (overRight) {
    if(isRecording) {
      isRecording = false;
    }
  }
   if (overTop) {
    if(isRecording) {
      isRecording = false;
    }
  }
   if (overBottom) {
    if(isRecording) {
      isRecording = false;
    }
  }
  
}

//Determines if the mouse is hovering over the middle square
boolean overMiddle()  {
  if (mouseX >= middle.getX() && mouseX <= middle.getX()+middle.getWidth() && 
      mouseY >= middle.getY() && mouseY <=middle.getY()+middle.getHeight()) {
    return true;
  } else {
    return false;
  }
}

//Determines if the mouse is hovering over the left square
boolean overLeft()  {
  if (mouseX >= left.getX() && mouseX <= left.getX()+left.getWidth() && 
      mouseY >= left.getY() && mouseY <=left.getY()+middle.getHeight()) {
    return true;
  } else {
    return false;
  }
}

//Determines if the mouse is hovering over the right square
boolean overRight()  {
  if (mouseX >= right.getX() && mouseX <= right.getX()+right.getWidth() && 
      mouseY >= right.getY() && mouseY <= right.getY()+right.getHeight()) {
    return true;
  } else {
    return false;
  }
}

//Determines if the mouse if hovering over the Top square
boolean overTop()  {
  if (mouseX >= top.getX() && mouseX <= top.getX()+top.getWidth() && 
      mouseY >= top.getY() && mouseY <=top.getY()+top.getHeight()) {
    return true;
  } else {
    return false;
  }
}

//Determines if the mouse is hovering over the bottom square
boolean overBottom()  {
  if (mouseX >= bottom.getX() && mouseX <= bottom.getX()+bottom.getWidth() && 
      mouseY >= bottom.getY() && mouseY <=bottom.getY()+bottom.getHeight()) {
    return true;
  } else {
    return false;
  }
}


//changes the color of the square corresponding to the passed in direction to green
public void highlightSquare(String direction) {
  if(!topHighlighted && !bottomHighlighted && !leftHighlighted && !rightHighlighted && !middleHighlighted) {
    if(direction.equals("Left")) {
      left.setColor(0,255,0);
      left.drawSquare();
      leftHighlighted = true;
    }else if(direction.equals("Right")) {
      right.setColor(0,255,0);
      right.drawSquare();
      rightHighlighted = true;
    }else if(direction.equals("Top")) {
      top.setColor(0,255,0);
      top.drawSquare();
      topHighlighted= true;
    }else if(direction.equals("Bottom")) {
      bottom.setColor(0,255,0);
      bottom.drawSquare();
      bottomHighlighted = true;
    }
  }
}

//Determines which direction the passed in integer corresponds to. 
public String determineDirection(int num) {
    if(num == 0) {
      return "Right";
    }
    else if(num == 1) {
      return "Left";
    }
    else if(num == 2) {
      return "Top";
    }
    else{
      return "Bottom";
    }
}

// initialized the 5 black square objects
public void intializeSquares() {
  
  middle = new Square(width/2,height/2);
  left = new Square(width/2 - 200,height/2);
  right = new Square(width/2 + 200, height/2);
  top = new Square(width/2, height/2 - 200);
  bottom = new Square(width/2, height/2 + 200);
}

//draws the 5 square objects on squeen
public void drawInitialSquares() {
  middle.drawSquare();
  left.drawSquare();
  right.drawSquare();
  top.drawSquare();
  bottom.drawSquare();
}