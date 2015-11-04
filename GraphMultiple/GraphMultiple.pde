// Graphing sketch


// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023 followed by a newline, or newline and carriage return.
// It can graph multiple independent data series, separated by spaces or tabs
// within each lines, e.g.
// 0 512 670
// 3 509 672
// 2 506 671

// Created 20 Apr 2005
// Updated 18 Jan 2008
// by Tom Igoe
// Updated 04 November 2015
// by David Mellis
// This example code is in the public domain.

import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1, prevXPos;         // horizontal position of the graph
float[] prevVals, vals;

void setup () {
  // set the window size:
  size(400, 300);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
  colorMode(HSB);
}
void draw () {
  if (xPos < prevXPos) background(0);
  else if (vals != null && prevVals != null && prevVals.length == vals.length) {
    for (int i = 0; i < vals.length; i++) {
      float val = vals[i], prevVal = prevVals[i];
      val = map(val, 0, 1023, 0, height);
      prevVal = map(prevVal, 0, 1023, 0, height);

      // draw the line:
      stroke(255 / vals.length * i, 255, 255);
      line(prevXPos, int(height - prevVal), xPos, int(height - val));
    }    
  }
  prevXPos = xPos;
  prevVals = vals;
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    vals = float(splitTokens(inString));

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }
}