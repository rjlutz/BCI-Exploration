/*
 * Muse FFT brainwave visualiser
 * Written in Processing 2.2.1
 * by Sarah Bennett (sarahb@cse.unsw.edu.au)
 * 2014-10-01
 *
 * modified R Lutz 2 Nov 2014
 * 
 * How to run:
 * 1) Run muse-io, with the dsp output set, specifying a UDP port
 * eg: ./muse-io --device 00:06:66:69:4F:8B --50hz --dsp --osc "osc.udp://localhost:5000"
 * where --device is your Muse's mac address
 *
 * 2) Run this script with Processing
 * 
 * 3) Enjoy :)
 */

// Import the required packages for OSC interfacing
import oscP5.*;
import netP5.*;
import java.util.Date;

/*
FEATURES TO ADD:

* live EEG data (in another tab?)
* logging to file
* scrolling the screen, not going over the page
*/

// set up the OSC stuff
OscP5 oscP5;
NetAddress myRemoteLocation;
 
// Some globals: current X position where we're drawing data; width of the lines we're drawing
int currentPosition = 0;
int drawWidth = 1;
Channels channels;

ArrayList<Integer> WAVE_COLORS = new ArrayList<Integer>();

// Set up the program
void setup() { 
  
  WAVE_COLORS.add(color(255,255,0));
  WAVE_COLORS.add(color(0,255,255));
  WAVE_COLORS.add(color(255,0,0));
  WAVE_COLORS.add(color(0,255,0));
  WAVE_COLORS.add(color(0,0,255));
 
  channels = new Channels(4); // process data from 4 incoming data channels
  
  // Specify the screen size
  size(800, 600);

  // Set up the OSC stuff
  oscP5 = new OscP5(this, 5000);
  myRemoteLocation = new NetAddress("127.0.0.1", 5000);

  // Set the background color of the screen
  background(0);

  // Specify that we're in HSB color mode
  colorMode(HSB);
  
}

// This function gets called every time any OSC message comes in.
// Within the function, we can check if a given message matches the one we're after, and react accordingly.
// This is in contrast to other OSC interfaces, which set up handlers for each type of message that can come in.
// I'm not sure whether this is possible to do in Processing with the current libraries.
void oscEvent(OscMessage theOscMessage) {
  
  // For each type of wave [alpha, beta, ...]
  for (String waveName : WAVE_NAMES) {
    // If the wave matches the DSP data for that wave
    if (theOscMessage.checkAddrPattern("/muse/elements/" + waveName + "_absolute") == true) {
      // Make sure that we have the type tag right: ffff means four floats, which is what we'll get when the Muse is set to preset 10.
      if (theOscMessage.checkTypetag("ffff")) {
        // For each of the channels of data (4, in preset 10)
        for (int i = 0; i < channels.size(); i++) {
          // Store the current data point in the channels object
          channels.get(i).getWave(waveName)
                  .add(theOscMessage.get(i).floatValue());
          }  
        }
     }
    }
    // channel 1 has a strong delta response
    //Wave w = channels.get(1).getWave("delta");       //NEW CODE
    //if (w.get(w.size()-1) >= 0.7)                    //NEW CODE
    //    java.awt.Toolkit.getDefaultToolkit().beep(); //NEW CODE
  }


// This is where we actually draw the graphics onto the screen
// This function takes the data from the global array, and draws each of the data points on the screen,
// wrapping around as the screen gets filled.
// Each wave is drawn in a different color, and it also displays the names of the waves with their current values [scaled from 0-1 to 0-100], for each channel.
void draw() {
  
  // Set the fill color to black, and turn off strokes
  fill(0);
  noStroke();
  // Draw a rectangle to cover the background in black, before overwriting the wave data
  rect(currentPosition, 0, drawWidth*5, height);

  // The top and bottom position of where we're going to draw
  float top, bottom;

  // For each channel:
  for (int curChannel = 0; curChannel < channels.size(); curChannel++) {
    
    // Specify the boundaries of where we're drawing
    top = map(curChannel, 0, channels.size(), height, 30);
    bottom = map(curChannel+1, 0, channels.size(), height, 30);
    
    // Draw a rectangle to clear where the text about each waveform is going to be
    fill(0);
    noStroke();
    rect(0, bottom-30, width, 30);

    // For each of the buckets / wave types:
    for (int i=0; i<WAVE_NAMES.length; i++) {

      // Specify the color for this wavetype
      Wave w = channels.get(curChannel).get(i);
      int c = w.getColor();
      
      // Create the text, talking about the waveform with its values
      fill(c);
      textAlign(TOP, LEFT);
      String cur = Float.isNaN(w.get(w.size()-1)) ?  "--" : nf(w.get(w.size()-1), 1, 2);
      String avg;
      if (w.getMovingAverage() == 0)
        avg = "--";
      else
        avg = nf(w.getMovingAverage(), 1, 2);
      text(w.getName() + "(" + cur + "/" + avg +  ")", 15+i*150, bottom-15);
      
      // Draw the line of the waveform
      stroke(c);
      line(currentPosition, map(w.get(w.size()-2), 0, 1, top-30, bottom), 
           currentPosition+drawWidth, map(w.get(w.size()-1), 0, 1, top-30, bottom));
    }
  }
  
  // Update the current x position across the page, and wrap around when we hit the end
  currentPosition+=drawWidth;
  currentPosition %= width;
}
