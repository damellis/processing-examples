// This program proxies data between open-source control (OSC)
// messages and a serial port. Serial port data is formatted as
// tab-separated ASCII-formatted floating point numbers, with
// each (newline-terminated) line of serial data corresponding
// to one OSC message, e.g.:
// 100.0  2.3  47.5
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
int PORT = 6448;
String ADDRESS = "/wek/inputs";

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
  OscMessage msg = new OscMessage(ADDRESS);
  print(">");
  for (int i = 0; i < vals.length; i++) {
    float val = float(trim(vals[i]));
    print("\t" + val);
    msg.add(val);
  }
  println();
  osc.send(msg, address);
}

void oscEvent(OscMessage msg)
{
  print("<");
  for (int i = 0; i < msg.arguments().length; i++) {
    print("\t" + msg.arguments()[i].toString());
    port.write(msg.arguments()[i].toString());
    if (i < msg.arguments().length - 1) port.write("\t");
  }
  println();
  port.write("\n");
}