ArrayList<ParticleSystem> systems;
import peasy.*;
PImage map, fang, ti, map2, up, down, icon;
String url="http://hq.sinajs.cn/list=sz002653,sh601515,sz002304,sz300146,sz000568,sh601717,sz000869,sh600031,sh600519,sz002353,sh600970,sz000979,sz002700,sz002128,sh600547,sz000651,sz002081,,sz002294,sh600535,sz000540,sz002038,sz000963,sh601877,sh600067,sh600309,sz000895,sz000028,sz002022,sh600816,sz000887,sz002701,sz000858,sh600805,sh600983,sz000538,sz000423,sh600729,sz002267,sz000922,sz000419,sh600354,sz000755,sh601001";
PeasyCam camera;
int m;
CameraState state;
float wr=0;
float hr=0;
PImage smoke;
int d2=1;
int showmap=1;
int num=43;
int about=-1;
String stock[][]=new String[num][];
float stockLocation[][]={{-42, 104}, {126, 214}, {249, 57}, {136, 245}, {6, 132}, {144, 14}, {233, -31}, {133, -84}, {49, 165}, {226, -39}, {185, 53}, {130, -93}, {-215, -152}, {215, -156}, {176, -17}, {159, 250}, {240, 60}, {168, 234}, {178, -63}, {5, 170}, {142, -74}, {193, 89}, {258, 104}, {241, 168}, {249, -32}, {144, 34}, {182, 234}, {264, 61}, {273, 85}, {193, 80}, {126, -98}, {-2, 120}, {234, 36}, {155, 75}, {-29, 194}, {153, -17}, {27, 118}, {45, 31}, {271, -203}, {90, 145}, {-134, -68}, {72, -29}, {83, -71}};
float changeC=0;
PFont font, font2, font3;
String b="Chinese Stock Map is a data visualization project made by Wu Shengzhi, this project is aimed to offer people a more intuitive and clear picture of the stock data in Chinese financial market. The visualization acquires real-time data from an open API from Sina Finance and Economics. 50 particle systems are created corresponding to 50 represented Chinese stocks in Shanghai and Shenzhen stock exchange, and the locations are mapped into the headquarters’ locations of these 50 corporations. The rise and fall rate is demonstrated by red and blue color, and the heights of the particles represent the current price of these stocks, simultaneously the expansion is related to trading volume of these stocks. Through the animated particle systems, people are able to clearly understand the comparison of these 50 stocks, as well as the dynamic of enterprises through time.";
String a="Chinese Stock Map is a data visualization environment of 50 represented stocks in Chinese financial market, and the stocks are mapped into their corporations’ locations in a map of China. The visualization explores the current price, rise or fall, and trading volume in real-time stock market.";
void setup() {
  fullScreen(P3D);
  systems = new ArrayList<ParticleSystem>();
  font = loadFont("HelveticaNeue-Bold-48.vlw");
  font2 = loadFont("Avenir-Medium-48.vlw");
  font3=loadFont("MinionPro-Bold-48.vlw");
  camera = new PeasyCam(this, 700);
  camera.setMinimumDistance(200);
  camera.setMaximumDistance(800);
  camera.rotateX(-0.7);
  state = camera.getState();
  map=loadImage("map.png");
  icon=loadImage("11.png");
  map2=loadImage("map2.png");
  fang=loadImage("fang.png");
  up=loadImage("up.png");
  down=loadImage("down.png");
  ti=loadImage("ti.png");
  m = minute();
  smoke = loadImage("texture.png");
  preLoadStockData();
}
void draw() {
  background(#0f141d);
  //lights();
  //println(height,width);
  imageMode(CENTER);
  if (showmap>0) {
    image(map, 0, 0);
  
  pushMatrix();
  translate(0, 0, 25);
  tint(100);
  image(map2, 0, 0, 1000, 1000);
  popMatrix();
  }
  for (ParticleSystem ps : systems) {
    ps.run();
    ps.addParticle();
  }
  updateStokeData();

  camera.beginHUD();
  textFont(font);
  textSize(25);
  fill(255);
  text("Chinese Stock Map", 20, 60);
  textFont(font2);
  textSize(15);
  text(a, 20, 110, 240, 400);
  noTint();
  image(icon, width-100, 50, 150, 30);

  if (about>0) {
    blendMode(BLEND);
    fill(0, 160);
    rect(0, 0, width, height);
    fill(255);
    textSize(17);
    text(b, width/2-280, height/2-170, 560, 500);
    textFont(font);
    textSize(19);

    text("About & detail", width/2-280, height/2-190);
    noFill();
    stroke(255);
    strokeWeight(0.8);
    rect(width/2-360, height/2-270, 720, 530, 6);
    continueExplore() ;
  } else {

    dimension();
    about();
    hideMap();
    time();
  }

  //text(systems.size(), 100, 100);
  camera.endHUD();

  //CameraState state = camera.getState();
  //println(state);
  //camera.setState(state);
}
void keyPressed(){
  if(key=='q'){
    exit();
  }
}
void mousePressed() {
  if (mouseX>20&&mouseX<220&&mouseY>350&&mouseY<400) {
    d2*=-1;
    camera.setState(state);
  }
  if (d2>0) {

    camera.setActive(true);
  } else {
    camera.reset();
    camera.setActive(false);
  }
  if (mouseX>20&&mouseX<220&&mouseY>417&&mouseY<464) {
    showmap*=-1;
  }
  if (about<0) {
    if (mouseX>20&&mouseX<220&&mouseY>484&&mouseY<531) {
      about*=-1;
    }
  }
  if (about>0) {
    if (mouseX>width/2-80 &&mouseX<width/2+120 &&mouseY>height-300&&mouseY<height-253) {
      about*=-1;
    }
  }
}
void updateStokeData() {
  if (minute()-m!=0) {
    preLoadStockData();
    m=minute();
  }
}
void preLoadStockData() {
  String lines[] = loadStrings(url);

  //println("there are " + lines.length + " lines");
  for (int i = 0; i < lines.length; i++) {
    stock[i]= split(lines[i], ',');
  }
  if (stock!=null) {

    for (int i=0; i<stock.length; i++) {
      float col=map(((float(stock[i][3])-float(stock[i][2])))/(float(stock[i][2])), -0.05, 0.05, 0, 1);
      float h=float(stock[i][3]);
      float w=float(stock[i][9])/120000000;
      //println(stock[i][0]);
      PVector o=new PVector( stockLocation[i][0], stockLocation[i][1], 25);



      systems.add(new ParticleSystem(o, col, h, w));
      if (systems.size()>num) {
        systems.remove(0);
      }
    }
  }
}
void dimension() {
  if (mouseX>20&&mouseX<220&&mouseY>350&&mouseY<400) {
    if (mousePressed!=true) {
      fill(100);
    } else if (mousePressed==true) {
      fill(255);
    }
  } else {
    noFill();
  }
  stroke(255);
  strokeWeight(1);
  rect(20, 350, 200, 47, 6);
  fill(255);
  textFont(font);
  textSize(15);
  if (d2>0) {

    text("Switch to 2D", 90, 378);
    tint(255);
    image(fang, 60, 374, 25, 25);
  } else {
    text("Switch to 3D", 90, 378);
    tint(255);
    image(ti, 60, 373, 25, 25);
    displayStockinfo();
  }
}
void displayStockinfo() {

  for (int i=0; i<stockLocation.length; i++) {
    float x=1.15*stockLocation[i][0];
    float y=1.15*stockLocation[i][1];
    if (mouseX>x+width/2-10&&mouseX<x+width/2+10&&mouseY>y+height/2-10&&mouseY<y+height/2+10) {
      fill(255, 180);
      noStroke();
      //wr+=(222-wr)*0.1;
      //hr+=(75-hr)*0.05;
      rect(x+15+width/2, y+height/2+2, 222, 75, 6);
      textFont(font);
      textSize(22);
      float currentPrice=float(stock[i][3]);
      float yesterday=float(stock[i][2]);
      float rito=100*(currentPrice-yesterday)/yesterday;
      String r=nfc(rito, 2);
      if (rito<0) {
        fill(#277150);
        //image(down,x+116+width/2, y+height/2+53,10,20);
      } else {
        fill(#D11B46);
        //image(up,x+115+width/2, y+height/2+52,10,20);
      }
      String[]code0=split(stock[i][0], '_');
      String[]code=split(code0[2], '=');
      code[0]=code[0].toUpperCase();

      text(stock[i][3], x+30+width/2, y+height/2+60);
      text(r+"%", x+135+width/2, y+height/2+60);
      fill(#1F2539);
      textSize(18);
      text("Stock Code: "+code[0], x+30+width/2, y+height/2+30);
    }
  }
}
void about() {
  float e=67;
  blendMode(BLEND);
  if (mouseX>20&&mouseX<220&&mouseY>417+e&&mouseY<464+e) {
    if (mousePressed!=true) {
      fill(100);
    } else if (mousePressed==true) {      
      fill(255);
    }
  } else {
    noFill();
  }
  textFont(font);
  stroke(255);
  strokeWeight(1);
  rect(20, 417+e, 200, 47, 6);
  fill(255);
  textSize(15);
  text("About & detail", 68, 443+e);
}
void time() {
  textSize(25);
  fill(110);
  text("GMT+8: "+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2), 22, height-30);
}
void continueExplore() {
  if (mouseX>width/2-100 &&mouseX<width/2+100 &&mouseY>height-300&&mouseY<height-253) {
    if (mousePressed!=true) {
      fill(100);
    } else if (mousePressed==true) {
      fill(255);
    }
  } else {
    noFill();
  }
  stroke(255);
  strokeWeight(1);

  rect(width/2-100, height-300, 200, 47, 6);
  fill(255);
  textFont(font);
  textSize(15);


  if (about>0) {
    fill(255);
    textFont(font);
    textSize(15);
    text("continue explore", width/2-60, height-275);
  }
}
void hideMap() {
  if (mouseX>20&&mouseX<220&&mouseY>417&&mouseY<464) {
    if (mousePressed!=true) {
      fill(100);
    } else if (mousePressed==true) {      
      fill(255);
    }
  } else {
    noFill();
  }
  textFont(font);
  stroke(255);
  strokeWeight(1);
  rect(20, 417, 200, 47, 6);
  fill(255);
  textSize(15);
  if (showmap>0) {
    text("Hide Map", 81, 443);
  } else {
    text("Show Map", 81, 443);
  }
}