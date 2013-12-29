HScrollbar hs,hs1,hs2,hs3;  // Two scrollbars
PImage back;
PImage play1,pause1;

PImage syncon,syncoff;

int animx, animy;
int deck1x, deck1y;
int deck2x, deck2y;

boolean deck1Playing = false;
boolean deck2Playing = false;
boolean sync = false;
float rotateDeck1 = 0;
float rotateDeck2 = 0;
float currentFrame = 0;
int margin = width/40;
PImage [] images;
PImage [] recordPlayer;
Maxim maxim;
AudioPlayer player1;
AudioPlayer player2;
float speedAdjust=1.0;
float volAdjust=1.0;
float speedAdjust2=1.0;
float volAdjust2=1.0;
float p1av = 0;
float p1bass=0;
float p1treb = 0;
float p2av = 0;
float p2bass=0;
float p2treb = 0;

void setup()
{
  size(850, 560);
  noStroke();
  back = loadImage("backimg.jpg");  

  hs = new HScrollbar(29,20, width/2-width/10, 16, 4);    //Display of scrollbars
  hs1 = new HScrollbar(29,40, width/2-width/10, 16, 4);
  hs2 = new HScrollbar(width-width/2+width/10-29,20, width/2-width/10, 16, 4);
  hs3 = new HScrollbar(width-width/2+width/10-29,40, width/2-width/10, 16, 4);  
  imageMode(CENTER);
  play1 = loadImage("play2.png");                        //Display of stop/play buttons
  pause1 = loadImage("stop.png");
  
  recordPlayer = loadImages("black-record_", ".png", 36);//Display records

  maxim = new Maxim(this);
  player1 = maxim.loadFile("beat1.wav");
  player1.setAnalysing(true);
  player1.setLooping(true);

  player2 = maxim.loadFile("beat2.wav");
  player2.setAnalysing(true);
  player2.setLooping(true);

  background(10);
  
  syncoff = loadImage("syncoff.png"); //Display sync images
  syncon = loadImage("syncon.png");  

}

void draw()
{
  imageMode(CORNER);  
  image(back,0,0);  
  stroke(239,228,176);
  line(width/2,0,width/2,height);  
  hs.update();                         //For scroll bars
  hs.display();
  volAdjust = 2 * hs.getPos();
  hs1.update();
  hs1.display();
  speedAdjust = 2* hs1.getPos();
  hs2.update();
  hs2.display();
  volAdjust2 = 2 * hs2.getPos();

  if (sync){                          //To adjust the speed of the 2nd speed bar based on whether sync is on or off
   hs3.sync_to(hs1); 
   speedAdjust2=((player2.getLengthMs()/player1.getLengthMs())*speedAdjust); 
  }
  else {
    hs3.update();  
    speedAdjust2 = 2* hs3.getPos();   
  }
    
  hs3.display();

  imageMode(CENTER);
   //To position the decks
  deck1x = 29+ (width/2 - width/10)/2;
  deck1y = 65+recordPlayer[0].height/2+margin;
  image(recordPlayer[(int) rotateDeck1], deck1x, deck1y, recordPlayer[0].width, recordPlayer[0].height);
  
  deck2x = width - deck1x;
  deck2y = 65+recordPlayer[0].height/2+margin;
  image(recordPlayer[(int) rotateDeck2], deck2x, deck2y, recordPlayer[0].width, recordPlayer[0].height);


  image(play1, deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10,deck1y,play1.width,play1.height);
  image(play1, width-(deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10),deck1y,play1.width,play1.height);

  //Positioning sync button
  imageMode(CENTER);
  if (sync) {     
  image(syncon, width/2,height * (5/8)-15,syncoff.width,syncoff.height);    
  }
  
  else {
  image(syncoff, width/2,height * (5/8)-15,syncoff.width,syncoff.height);
  }
  if (deck1Playing || deck2Playing) {
    
    player1.speed(speedAdjust);
    player2.speed(speedAdjust2);

    currentFrame= currentFrame+1*speedAdjust;

  }

  //Adjust volume and speed of deck1 if it is playing
  if (deck1Playing) {

    rotateDeck1 += 1*speedAdjust;
  
    image(pause1, deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10,deck1y,play1.width,play1.height);
    player1.volume(volAdjust);
   



    if (rotateDeck1 >= recordPlayer.length) {

      rotateDeck1 = 0;
    }
    //Power meters
    player1.play();
    p1av = player1.getAveragePower();
    fill(255*p1av,255*p1av,255*p1av);
    if (p1av>0){
    rect(76,521,21,p1av*-185);}
    else{
    rect(76,521,21,p1av*185);} 
    
    p1bass = player1.getBassPower();
    fill(255*p1bass,255*p1bass,255*p1bass);

    if (p1bass>0) {
    rect(46,521,21,p1bass*-185);}
    else{
        rect(46,521,21,p1bass*185);} 
    
    p1treb = player1.getTrebPower();
    fill(255*p1treb,255*p1treb,255*p1treb);
    if (p1treb>0) {   
    rect(106,521,21,p1treb*-185); }
    else {   
    rect(106,521,21,p1treb*185); }
  }
  //Adjust volume and speed of deck2 if it is playing
  if (deck2Playing) {

    rotateDeck2 += 1*speedAdjust2;

    player2.volume(volAdjust2);    
    
    image(pause1, width-(deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10),deck1y,play1.width,play1.height);
    if (rotateDeck2 >= recordPlayer.length) {

      rotateDeck2 = 0;
    }
    //Power meters  
    player2.play();
    p2av = player2.getAveragePower();
    fill(255*p2av,255*p2av,255*p2av);
    if (p2av>0){
    rect(754,523,21,p2av*-185);}
    else{
    rect(754,523,21,p2av*185);} 
    
    p2bass = player2.getBassPower();
    fill(255*p2bass,255*p2bass,255*p2bass);
    if (p2bass>0){
    rect(724,523,21,p2bass*-185);} 
    else{
    rect(724,523,21,p2bass*185);} 
    
    p2treb = player2.getTrebPower();
    fill(255*p2treb,255*p2treb,255*p2treb);
    if (p2treb>0){
    rect(784,523,21,p2treb*-185); }
    else{
    rect(784,523,21,p2treb*185); }  
    }

}


void mouseClicked()  //Check if the mouse has clicked on any button/scroller
{

  if(dist(mouseX, mouseY, deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10,deck1y) < play1.width/2){
    
    deck1Playing = !deck1Playing;
  }
    if(dist(mouseX, mouseY, width-(deck1x-(recordPlayer[0].width/2)-(play1.width/2)-10),deck1y) < play1.width/2){
    
    deck2Playing = !deck2Playing;
  }
  
  if(dist(mouseX, mouseY,width/2,height * (5/8)-15) < syncoff.width/2){
    
    sync = !sync;
  }
  if (deck1Playing) {
    player1.play();
  } 
  else {

    player1.stop();
  }



  if (deck2Playing) {
    player2.play();
  } 
  else {

    player2.stop();
  }
}


//Scrollbar class
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {                    //Updates scroller position
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);

    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  void sync_to(HScrollbar h){    //For sync feature
  spos = h.spos+sposMin-h.sposMin;
  newpos = spos;
  }  

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {        //Displays entire scrollbar
    noStroke();
    fill(239,228,176);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(120, 103, 24);
    } else {
      fill(217,190,64);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {      
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return (spos - sposMin)/(sposMax - sposMin);
  }
}



