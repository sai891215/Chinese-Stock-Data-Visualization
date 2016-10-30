class ParticleSystem {

  PVector loc;
  float cc,hh,ww;
  ArrayList<Particle> particles;
  float aaa=10;
  ParticleSystem(PVector loc_,float col_, float h_, float w_) {
    loc= new PVector(loc_.x, loc_.y,loc_.z);
    particles = new ArrayList<Particle>();
    cc=col_;
    hh=h_;
    ww=w_+0.5;
   
  }
  void addParticle() {
    for(int i=0;i<int(ww+1);i++){
      particles.add(new Particle(loc,cc,hh,ww));
    }
    pushMatrix();
    translate(loc.x,loc.y,35);
    noFill();
   
   
    
    color from1 = color(#05FF30);
    color to1 = color(#FF0873);
   
    color finalCol2 = lerpColor(from1, to1,cc);
    
    if(aaa<ww*6.8){
      aaa+=(ww*7-aaa)*0.03;
      
    }else {
      aaa=ww*3;
    }
    
    float aaac=map(aaa,ww*3,ww*7,255,20);
    stroke(finalCol2,aaac);
    strokeWeight(1);
    ellipse(0,0,15,15);
    ellipse(0,0,aaa*1.5,aaa*1.5);
    ellipse(0,0,aaa,aaa);
    //color from = color(#540DFF);
    //color to = color(#05FF30);
    
    //color finalCol = lerpColor(from, to, cc);
    //println(ww);
    //float ww2=map(ww,0,1,8,25);
    
    //fill(finalCol);
    //box(ww2,ww2,hh*2);
    popMatrix();
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}