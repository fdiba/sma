import java.util.Date;
import themidibus.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;


MidiBus myBus;
Box2DProcessing box2d;

ArrayList<Mover> movers;
ArrayList<Attractor> attractors;

Attractor a;

int numMoversMax;

int numOfAttractor;
int numOfAttractorMax = 3;

void setup() {

  size(800, 600);
  smooth();

  numOfAttractor = 1;

  MidiBus.list();
  myBus = new MidiBus(this, "Midi Fighter Twister", "Midi Fighter Twister"); 

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, 0);

  numMoversMax = 25;
  movers = new ArrayList<Mover>();

  attractors = new ArrayList<Attractor>();
  attractors.add(new Attractor(32, width/2-150, height/2-90)); //32
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

  if (attractors.size()<numOfAttractorMax && attractors.size() != numOfAttractor) {
    if(numOfAttractor==1)attractors.add(new Attractor(32, width/2-150, height/2-90)); //32
    if(numOfAttractor==2)attractors.add(new Attractor(32, width/2+150, height/2-90)); //32
    if (numOfAttractor==3)attractors.add(new Attractor(32, width/2, height/2+150)); //32
  }
  
  //TODO sync midi interface !!
  while (numOfAttractor<attractors.size()){
    box2d.destroyBody( attractors.get(attractors.size()-1).body);
    attractors.remove(attractors.size()-1);
  }

  box2d.step();

  for (int i = 0; i < attractors.size (); i++) {
    attractors.get(i).update();
    attractors.get(i).display();
  }

  for (int i = 0; i < movers.size (); i++) {

    Vec2 force;
    if(attractors.size()>0) {
      force = attractors.get(0).attract(movers.get(i));
      movers.get(i).applyForce(force);
    }
    
    movers.get(i).checkPosition();
    movers.get(i).display();
  }

  for (int i = movers.size ()-1; i >= 0; i--) {

    if (movers.get(i).isDead) {
      box2d.destroyBody(movers.get(i).body);
      movers.remove(i);
    }
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


  if (change.channel()==0 && change.number()==0) {
    
    float r = map(change.value(), 0, 127, 0, 64);
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).r = r;
      attractors.get(i).hasBeenUpdated = true;
    }
  
} else if (change.channel()==0 && change.number()==1) {

    int multi = (int) map(change.value(), 0, 127, 0, width);        
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).multi = multi;
    }
    
  } else if (change.channel()==1 && change.number()==1 && change.value()==0) {
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).multi = 0;
    }
    
  } else if (change.channel()==0 && change.number()==2) {
    
    float step = map(change.value(), 0, 127, 0.01, .1);
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).step = step;
    }
    
  } else if (change.channel()==1 && change.number()==2 && change.value()==0) {
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).step = .1;
    }
    
  } else if (change.channel()==0 && change.number()==4) {
    
    float G = map(change.value(), 0, 127, 0, 200);
    
    for (int i = 0; i < attractors.size (); i++) {
      attractors.get(i).G = G;
    }
    
  } else if (change.channel()==0 && change.number()==12) {
    
    
    numOfAttractor = (int) map(change.value(), 0, 127, 0, 3);
    //println(numOfAttractor);
  }
}

