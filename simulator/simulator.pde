import guru.ttslib.*;
import processing.video.*;

// import the beads library
import beads.*;
import controlP5.*;
import org.jaudiolibs.beads.*;
import java.util.*;


ControlP5 p5;

Movie plieVid;
Movie sauteVid;
boolean showPlie;
boolean showSaute;

WavePlayer sineCalf;
WavePlayer sineInnerLeg;
WavePlayer sineOuterLeg;
WavePlayer sineGlutes;

WavePlayer sawCalf;
WavePlayer sawInnerLeg;
WavePlayer sawOuterLeg;
WavePlayer sawGlutes;
WavePlayer modulator;

SamplePlayer align;

Glide sineGlide;
Gain sineGain;

Glide sineCalfGlide;
Glide sineInnerLegGlide;
Glide sineOuterLegGlide;
Glide sineGlutesGlide;

Gain sineCalfGain;
Gain sineInnerLegGain;
Gain sineOuterLegGain;
Gain sineGlutesGain;

Glide sawGlide;
Gain sawGain;

Glide sawCalfGlide;
Glide sawInnerLegGlide;
Glide sawOuterLegGlide;
Glide sawGlutesGlide;

Gain sawCalfGain;
Gain sawInnerLegGain;
Gain sawOuterLegGain;
Gain sawGlutesGain;

Gain sumSinesGain;
Gain sumSawsGain;

Gain modulatorGain;

Gain alignmentGain;
Glide alignmentGlide;

Gain g;
Glide gainGlide;
Envelope gainEnvelope;
Gain masterGain;

Button calfButton;
Button innerLegButton;
Button outerLegButton;
Button gluteButton;
Button alignButton;
Button all;

Slider2D xyGrid;
Slider calfSlider;
Slider innerLegSlider;
Slider outerLegSlider;
Slider gluteSlider;
Slider alignmentSlider;
Slider GainSlider;

Panner p;
float LEFT = -1.0;
float RIGHT = 1.0;
float panner = LEFT;

TextToSpeechMaker ttsMaker;
Button injury;
String muscle = "calf";

String plie1Json = "plie1.json";
String plie2Json = "plie2.json";
String plie3Json = "plie3.json";
String plie4Json = "plie4.json";
String plie5Json = "plie5.json";
String saute1Json = "saute1.json";
String saute2Json = "saute2.json";
String saute3Json = "saute3.json";
String saute4Json = "saute4.json";
String saute5Json = "saute5.json";

NotificationServer server;
ArrayList<Notification> notifications;

Example example;

//Comparator<Notification> comparator;
//PriorityQueue<Notification> queue;
PriorityQueue<Notification> q2;

boolean training = false;
boolean minInv = false;
Button trainingTog;
Button minimumTog;
Button plie1;
Button plie2;
Button plie3;
Button plie4;
Button plie5;
Button saute1;
Button saute2;
Button saute3;
Button saute4;
Button saute5;

void setup(){
 size(700,700);
// initialize our AudioContext
ac = new AudioContext();
p5 = new ControlP5(this);

plieVid = new Movie(this, "plie.mp4");
sauteVid = new Movie(this, "saute.mp4");

//create sine waveplayers for muscle
sineCalf = new WavePlayer(ac, 349, Buffer.SINE);
sineInnerLeg = new WavePlayer(ac, 440, Buffer.SINE);
sineOuterLeg = new WavePlayer(ac, 523, Buffer.SINE);
sineGlutes = new WavePlayer(ac, 659, Buffer.SINE);

sawCalf = new WavePlayer(ac, 349, Buffer.SAW);
sawInnerLeg = new WavePlayer(ac, 440, Buffer.SAW);
sawOuterLeg = new WavePlayer(ac, 523, Buffer.SAW);
sawGlutes = new WavePlayer(ac, 659, Buffer.SAW);

//create the amplitude modulator sine
modulator = new WavePlayer(ac, 0, Buffer.SINE);
modulatorGain = new Gain(ac, 1, modulator);

alignmentGlide = new Glide(ac, .5, 50);
alignmentGain = new Gain(ac, 1, alignmentGlide);

sumSinesGain = new Gain(ac, 1, 0.2);
sumSawsGain = new Gain(ac, 1, 0.2);

//create sine glides for each muscle
sineCalfGlide = new Glide(ac, 1, 300);
sineInnerLegGlide = new Glide(ac, 1, 300);
sineOuterLegGlide = new Glide(ac, 1, 300);
sineGlutesGlide = new Glide(ac, 1, 300);

sineCalfGain = new Gain(ac, 1, sineCalfGlide);
sineInnerLegGain = new Gain(ac, 1, sineInnerLegGlide);
sineOuterLegGain = new Gain(ac, 1, sineOuterLegGlide);
sineGlutesGain = new Gain(ac, 1, sineGlutesGlide);

sawCalfGlide = new Glide(ac, 0, 300);
sawInnerLegGlide = new Glide(ac, 0, 300);
sawOuterLegGlide = new Glide(ac, 0, 300);
sawGlutesGlide = new Glide(ac, 0, 300);

sawCalfGain = new Gain(ac, 1, sawCalfGlide);
sawInnerLegGain = new Gain(ac, 1, sawInnerLegGlide);
sawOuterLegGain = new Gain(ac, 1, sawOuterLegGlide);
sawGlutesGain = new Gain(ac, 1, sawGlutesGlide);

sawGlide = new Glide(ac, .5, 50);
sawGain = new Gain(ac, 1, sawGlide);

gainGlide = new Glide(ac, .5, 300);
p = new Panner(ac, panner);
p.setPos(0);
gainEnvelope = new Envelope(ac, 0.0);
g = new Gain(ac, 1, gainEnvelope);
masterGain = new Gain(ac, 1, gainGlide);

align = getSamplePlayer("alignment.wav");
align.pause(true);

ttsMaker = new TextToSpeechMaker();

sawCalfGain.addInput(sawCalf);
sineCalfGain.addInput(sineCalf);
sawInnerLegGain.addInput(sawInnerLeg);
sineInnerLegGain.addInput(sineInnerLeg);
sawOuterLegGain.addInput(sawOuterLeg);
sineOuterLegGain.addInput(sineOuterLeg);
sawGlutesGain.addInput(sawGlutes);
sineGlutesGain.addInput(sineGlutes);

sumSinesGain.addInput(sineCalfGain);
sumSinesGain.addInput(sineInnerLegGain);
sumSinesGain.addInput(sineOuterLegGain);
sumSinesGain.addInput(sineGlutesGain);

sumSawsGain.addInput(sawCalfGain);
sumSawsGain.addInput(sawInnerLegGain);
sumSawsGain.addInput(sawOuterLegGain);
sumSawsGain.addInput(sawGlutesGain);

modulatorGain.addInput(sumSinesGain);
modulatorGain.addInput(sumSawsGain);

alignmentGain.addInput(align);

g.addInput(modulatorGain);
g.addInput(alignmentGain);

g.addInput(sumSawsGain);
g.addInput(sumSinesGain);
masterGain.addInput(g);
//masterGain.addInput(modulatorGain);
//masterGain.addInput(alignmentGain);

//masterGain.addInput(sumSawsGain);
//masterGain.addInput(sumSinesGain);
p.addInput(masterGain);
ac.out.addInput(p);
//ac.out.addInput(g);

GainSlider = p5.addSlider("GainSlider")
    .setPosition(25, 500)
    .setSize(600, 20)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("Volume");

calfSlider = p5.addSlider("calfSlider")
    .setPosition(25, 550)
    .setSize(20, 80)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("");
    
innerLegSlider = p5.addSlider("innerLegSlider")
    .setPosition(85, 550)
    .setSize(20, 80)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("");
    
outerLegSlider = p5.addSlider("outerLegSlider")
    .setPosition(145, 550)
    .setSize(20, 80)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("");
    
gluteSlider = p5.addSlider("gluteSlider")
    .setPosition(205, 550)
    .setSize(20, 80)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("");
    
alignmentSlider = p5.addSlider("alignmentSlider")
    .setPosition(450, 550)
    .setSize(20, 80)
    .setRange(0, 100)
    .setValue(50)
    .setLabel("");
    
xyGrid = p5.addSlider2D("xyGrid")
    .setPosition(300, 550)
    .setMinMax(-7, -7, 7, 7)
    .setLabel("Weight Dist");

 calfButton = p5.addButton("calf").setPosition(10, 650).setSize(50, 30).setLabel("Calves").activateBy(ControlP5.RELEASE);
 innerLegButton = p5.addButton("innerLeg").setPosition(70, 650).setSize(50, 30).setLabel("Hamstrings").activateBy(ControlP5.RELEASE);
 outerLegButton = p5.addButton("outerLeg").setPosition(130, 650).setSize(50, 30).setLabel("Outer Legs").activateBy(ControlP5.RELEASE);
 gluteButton = p5.addButton("glutes").setPosition(190, 650).setSize(50, 30).setLabel("Glutes").activateBy(ControlP5.RELEASE);
 alignButton = p5.addButton("align").setPosition(435, 650).setSize(50, 30).setLabel("Alignment").activateBy(ControlP5.RELEASE);
 // panButton = p5.addButton("pan").setPosition(width/4, 420).setSize(width / 4, 30).setLabel("pan").activateBy(ControlP5.RELEASE);
 injury = p5.addButton("injury").setPosition(550, 575).setSize(100, 30).setLabel("Injury").activateBy(ControlP5.RELEASE);
 all = p5.addButton("all").setPosition(550, 625).setSize(100, 30).setLabel("All").activateBy(ControlP5.RELEASE);

 trainingTog = p5.addButton("trainingTog").setPosition(10, 25).setSize(100, 30).setLabel("Training Mode").activateBy(ControlP5.RELEASE);
 minimumTog = p5.addButton("minimumTog").setPosition(120, 25).setSize(100, 30).setLabel("Min Intervention Mode").activateBy(ControlP5.RELEASE);
 
 //perfect plie sound
 plie1 = p5.addButton("plie1").setPosition(10, 75).setSize(100, 30).setLabel("Perfect Plie").activateBy(ControlP5.RELEASE);
 //improper balance
 plie2 = p5.addButton("plie2").setPosition(10, 125).setSize(100, 30).setLabel("Plie Test 1").activateBy(ControlP5.RELEASE);
 //bad muscle tension
 plie3 = p5.addButton("plie3").setPosition(10, 175).setSize(100, 30).setLabel("Plie Test 2").activateBy(ControlP5.RELEASE);
 //poor alignment and balance issues
 plie4 = p5.addButton("plie4").setPosition(10, 225).setSize(100, 30).setLabel("Plie Test 3").activateBy(ControlP5.RELEASE);
 //complex issues - many problems at once
 plie5 = p5.addButton("plie5").setPosition(10, 275).setSize(100, 30).setLabel("Plie Test 4").activateBy(ControlP5.RELEASE);
 
 //perfect saute sound
 saute1 = p5.addButton("saute1").setPosition(120, 75).setSize(100, 30).setLabel("Perfect Saute").activateBy(ControlP5.RELEASE);
 //bad landing and off balance takeoff
 saute2 = p5.addButton("saute2").setPosition(120, 125).setSize(100, 30).setLabel("Saute Test 1").activateBy(ControlP5.RELEASE);
 //poor alignment
 saute3 = p5.addButton("saute3").setPosition(120, 175).setSize(100, 30).setLabel("Saute Test 2").activateBy(ControlP5.RELEASE);
 //tension in other muscle groups
 saute4 = p5.addButton("saute4").setPosition(120, 225).setSize(100, 30).setLabel("Saute Test 3").activateBy(ControlP5.RELEASE);
 //complex issues - many problems at once
 saute5 = p5.addButton("saute5").setPosition(120, 275).setSize(100, 30).setLabel("Saute Test 4").activateBy(ControlP5.RELEASE);
 
//ac.start();
// start audio processing

  NotificationComparator priorityComp = new NotificationComparator();
  q2 = new PriorityQueue<Notification>(10, priorityComp);
  
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);
  
  //END NotificationServer setup

}

public void calf() {
  muscle = "calf";
  sumSawsGain.clearInputConnections();
  sumSinesGain.clearInputConnections();
  sumSawsGain.addInput(sawCalfGain);
  sumSinesGain.addInput(sineCalfGain);
}

public void innerLeg() {
  muscle = "hamstrings";
  sumSawsGain.clearInputConnections();
  sumSinesGain.clearInputConnections();
  sumSawsGain.addInput(sawInnerLegGain);
  sumSinesGain.addInput(sineInnerLegGain);
}

public void outerLeg() {
  muscle = "outer leg";
  sumSawsGain.clearInputConnections();
  sumSinesGain.clearInputConnections();
  sumSawsGain.addInput(sawOuterLegGain);
  sumSinesGain.addInput(sineOuterLegGain);
}

public void glutes() {
  muscle = "glutes";
  sumSawsGain.clearInputConnections();
  sumSinesGain.clearInputConnections();
  sumSawsGain.addInput(sawGlutesGain);
  sumSinesGain.addInput(sineGlutesGain);
}

public void all() {
  sumSawsGain.clearInputConnections();
  sumSinesGain.clearInputConnections();
  
  sumSinesGain.addInput(sineCalfGain);
  sumSinesGain.addInput(sineInnerLegGain);
  sumSinesGain.addInput(sineOuterLegGain);
  sumSinesGain.addInput(sineGlutesGain);

  sumSawsGain.addInput(sawCalfGain);
  sumSawsGain.addInput(sawInnerLegGain);
  sumSawsGain.addInput(sawOuterLegGain);
  sumSawsGain.addInput(sawGlutesGain);
}

public void injury() {
  ttsExamplePlayback(muscle);
}

public void trainingTog() {
  training = !training;
  if (training) {
    gainEnvelope.addSegment(1, 0);
    ac.start();
  } else {
    ac.stop();
  }
}

public void minimumTog() {
  minInv = !minInv;
  if (minInv) {
    sumSinesGain.setGain(0);
    sumSawsGain.setGain(0);
  } else {
    sumSinesGain.setGain(0.2);
    sumSawsGain.setGain(0.2);
  } 
}

public void plie1() {
  ac.start();
  showPlie = true;
  showSaute = false;
  plieVid.jump(0);
  plieVid.play();
  server.loadEventStream(plie1Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 12000);
}

public void plie2() {
  ac.start();
  showPlie = true;
  showSaute = false;
  plieVid.jump(0);
  plieVid.play();
  server.loadEventStream(plie2Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 12000);
}

public void plie3() {
  ac.start();
  showPlie = true;
  showSaute = false;
  plieVid.jump(0);
  plieVid.play();
  server.loadEventStream(plie3Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 12000);
}

public void plie4() {
  ac.start();
  showPlie = true;
  showSaute = false;
  plieVid.jump(0);
  plieVid.play();
  server.loadEventStream(plie4Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 12000);
}

public void plie5() {
  ac.start();
  showPlie = true;
  showSaute = false;
  plieVid.jump(0);
  plieVid.play();
  server.loadEventStream(plie5Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 12000);
}

public void saute1() {
  ac.start();
  showPlie = false;
  showSaute = true;
  sauteVid.jump(0);
  sauteVid.play();
  server.loadEventStream(saute1Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 7000);
}

public void saute2() {
  ac.start();
  showPlie = false;
  showSaute = true;
  sauteVid.jump(0);
  sauteVid.play();
  server.loadEventStream(saute2Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 7000);
}

public void saute3() {
  ac.start();
  showPlie = false;
  showSaute = true;
  sauteVid.jump(0);
  sauteVid.play();
  server.loadEventStream(saute3Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 7000);
}

public void saute4() {
  ac.start();
  showPlie = false;
  showSaute = true;
  sauteVid.jump(0);
  sauteVid.play();
  server.loadEventStream(saute4Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 7000);
}

public void saute5() {
  ac.start();
  showPlie = false;
  showSaute = true;
  sauteVid.jump(0);
  sauteVid.play();
  server.loadEventStream(saute5Json);
  gainEnvelope.addSegment(1, 0);
  gainEnvelope.addSegment(0, 7000);
}

public void align() { 
  //println("align");
  align.start(0);
}

public void pan() {
  if (panner == LEFT) {
    panner = RIGHT;
  } else {
    panner = LEFT;
  }
  p.setPos(panner);
}

public void xyGrid() {
  float x = xyGrid.getArrayValue()[0];
  float y = xyGrid.getArrayValue()[1];
  //print(y);
  p.setPos(x);
  if (y <= 1 && y >= -1) {
    modulatorGain.clearInputConnections();
    g.clearInputConnections();
    g.addInput(sumSinesGain);
    g.addInput(sumSawsGain);
    g.addInput(alignmentGain);
  } else  {
    g.clearInputConnections();
    modulatorGain.clearInputConnections();
    modulatorGain.addInput(sumSinesGain);
    modulatorGain.addInput(sumSawsGain);
    g.addInput(modulatorGain);
    g.addInput(alignmentGain);
    modulator.setFrequency(y);
  }
}

public void GainSlider(float value) {
  //println("gain slider presed");
  //normalize 0-100
  gainGlide.setValue(value/100.0);
}
//public void SineSlider(float value) {
//  println("sine slider pressed");
//  //normalize 0-100
//  sineGlide.setValue(value/100.0);
//}
public void calfSlider(float value) {
  //println("calf slider pressed");
  //normalize 0-100
  sawCalfGlide.setValue(value/100.0);
  sineCalfGlide.setValue(1-(value/100.0));
}

public void innerLegSlider(float value) {
  //println("inner leg slider pressed");
  //normalize 0-100
  sawInnerLegGlide.setValue(value/100.0);
  sineInnerLegGlide.setValue(1-(value/100.0));
}

public void outerLegSlider(float value) {
  //println("outer leg pressed");
  //normalize 0-100
  sawOuterLegGlide.setValue(value/100.0);
  sineOuterLegGlide.setValue(1-(value/100.0));
}

public void gluteSlider(float value) {
  //println("glute slider pressed");
  //normalize 0-100
  sawGlutesGlide.setValue(value/100.0);
  sineGlutesGlide.setValue(1-(value/100.0));
}

public void alignmentSlider(float value) {
  //println("alignment slider pressed");
  //normalize 0-100
  alignmentGlide.setValue(value/100.0);
}

void movieEvent(Movie movie) {  
  movie.read();
}

void draw() {
  background(0);
  if (showPlie) { image(plieVid, 0, 0); }
  if (showSaute) { image(sauteVid, 0, 0); }
}
