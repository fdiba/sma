class Mover {

  Body body;
  float r;

  boolean isDead;
  
  Vec2 pos;

  Mover(float r_, float x, float y) {

    r = r_;
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);

    body.setLinearVelocity(new Vec2(random(-5, 5),random(-5, 5)));
    body.setAngularVelocity(random(-1, 1));
  }

  void checkPosition() {
    
    pos = box2d.getBodyPixelCoord(body);
    if(pos.x > width + r*2 || pos.x + r*2 < 0 ||
       pos.y > height + r*2 || pos.y + r*2 < 0)isDead= true;
  }
  void applyForce(Vec2 v) {
    body.applyForce(v, body.getWorldCenter());
  }


  void display() {

    // We look at each body and get its screen position
    

    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    if(isDead)fill(255, 0, 0);
    else fill(150);
    stroke(255);
    strokeWeight(3);
    ellipse(0, 0, r*2, r*2);

    // Let's add a line so we can see the rotation
    strokeWeight(2);
    stroke(100);
    line(0, 0, r-3, 0);
    popMatrix();
  }
}

