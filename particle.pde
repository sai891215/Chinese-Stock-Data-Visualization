class Particle {
  PVector position;
  float lifespan = 255.0;
  PVector acceleration = new PVector(0, 0, -0.05);
  PVector velocity;
  float col, h, w;
  color finalCol;
  Particle( PVector position_, float col_, float h_, float w_) {
    col=col_;
    w=map(w_/5,0,5,0.12,0.5);
    h=map(h_,2,80,2,5);
    position = position_.copy();
    color from = color(#05FF30);
    color to = color(#FF0873);
   
    finalCol = lerpColor(from, to, col);
    velocity = new PVector(random(-w, w), random(-w, w), random(1, h));
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    
    lifespan -= 3;
  }

  // Method to display
  void display() {
    fill(finalCol);
    blendMode(ADD);
    pushMatrix();
    //basicMaterial(lifespan);
    translate(this.position.x, this.position.y, this.position.z);
    //noStroke();
    //box(1+lifespan/100)
    stroke(finalCol,lifespan);
    strokeWeight(2);
    point(0,0,0);
    // point(this.position.x, this.position.y,this.position.z)
    popMatrix();
  }

  // Is the particle still useful?
  boolean isDead() {
    if (this.lifespan < 0||this.position.z<0) {
      return true;
    } else {
      return false;
    }
  }
}