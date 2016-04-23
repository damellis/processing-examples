// This program forwards data received on the serial port
// as open-sound control (OSC) messages. Input format is 
// tab-separated ASCII integers, e.g.:
// 123  45  6  7890
// Requires: oscP5 library

// David A. Mellis
// April 22, 2016

import processing.serial.*;

import netP5.*;
import oscP5.*;

// which serial device to use. this is an index into the list
// of serial devices printed when this program runs. 
int SERIAL_PORT = 1;
int BAUD = 9600; // baud rate of the serial device

// the OSC server to talk to
String HOST = "127.0.0.1";
int PORT = 5000;

Serial port;
OscP5 osc;
NetAddress address;

void setup()
{
  printArray(Serial.list());
  osc = new OscP5(this, 12000);
  address = new NetAddress(HOST, PORT);
  port = new Serial(this, Serial.list()[SERIAL_PORT], BAUD);
  port.bufferUntil('\n');
}

void draw()
{
  background(0);
}

void serialEvent(Serial port)
{
  String line = port.readStringUntil('\n');
  if (line == null) return;
  String[] vals = splitTokens(line);
  OscMessage msg = new OscMessage("/Data");
  for (int i = 0; i < vals.length; i++) {
    int val = int(trim(vals[i]));
    print(val + "\t");
    msg.add(val);
  }
  println();
  osc.send(msg, address);
}