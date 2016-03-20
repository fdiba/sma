import java.util.Date;
import themidibus.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;


MidiBus myBus;
Box2DProcessing box2d;

ArrayList<Mover> movers;

Attractor a;

int numMoversMax;

void setup() {

  size(640, 360);
  smooth();

  MidiBus.list();
  myBus = new MidiBus(this, "Midi Fighter Twister", "Midi Fighter Twister"); 

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, 0);

  numMoversMax = 25;
  movers = new ArrayList<Mover>();

  a = new Attractor(32, width/2, height/2);
}
void mousePressed() {

  println("change");
  //myBus.sendControllerChange(0, 32, 40);
  //myBus.sendNoteOn(0, 32, 0); 
  //myBus.sendNoteOff(0, 32, 0);
}
void draw() {
  background(255);

  if (frameCount%24==0 && movers.size()<numMoversMax) {    
    movers.add(new Mover(random(8, 16), random(width), random(height)));
  }

  box2d.step();

  a.update();

  a.display();

  for (int i = 0; i < movers.size (); i++) {
    Vec2 force = a.attract(movers.get(i));
    movers.get(i).applyForce(force);
    movers.get(i).display();
  }
}
void saveIMG() {
  Date date = new Date();
  String name = "data/sma-" + date.getTime() + ".jpg";
  save(name);
}
void keyPressed() {
  if (key == 's') {
    saveIMG();
  }
}
//---------------- Midibus ----------------//
void controllerChange(ControlChange change) {
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());


  if (change.channel()==0 && change.number()==32) {
    a.multi = (int) map(change.value(), 0, 127, 0, width);
  } else if (change.channel()==1 && change.number()==32 && change.value()==0) {
    a.multi = 0;
  } else if (change.channel()==0 && change.number()==33) {
    a.step = map(change.value(), 0, 127, 0.01, .1);
  } else if (change.channel()==1 && change.number()==33 && change.value()==0) {
    a.step = .1;
  } 
}

