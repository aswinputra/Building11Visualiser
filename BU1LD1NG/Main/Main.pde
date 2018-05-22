import ddf.minim.*; //<>// //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PImage floorImage0, floorImage1, floorImage2, floorImage3, floorImage4, floorImage5;
int imgheight;
int imgwidth;

PShape floor0, floor1, floor2, floor3, floor4, floor5;
PShape[] floorShapes = {floor0, floor1, floor2, floor3, floor4, floor5};
float rotation = -16;
float rotation2 = 13;
float x = -500;
float y = -350;
float floorZ = 150;
PeasyCam cam;
float dateX, dateY;
float guideX, guideY; 
int day, time = 0;
ArrayList<PeopleCounter> sensors = new ArrayList<PeopleCounter>();
int dayNum, timeNum = 0;
BackgroundMusic soundEffect;

void setup() {
  frameRate(15);
  size(1000, 800, P3D);
  floorImage0 = loadImage("00.png");
  floorImage1 = loadImage("01.png");
  floorImage2 = loadImage("02.png");
  floorImage3 = loadImage("03.png");
  floorImage4 = loadImage("04.png");
  floorImage5 = loadImage("05.png");
  PImage[] floorImages = {floorImage0, floorImage1, floorImage2, floorImage3, floorImage4, floorImage5};
  for (int i=0; i<floorImages.length; i++) {
    floorShapes[i] = createShape(RECT, x, y, floorImages[i].width, floorImages[i].height);
    floorShapes[i].setTexture(floorImages[i]);
  }
  cam = new PeasyCam(this, 1800);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2500);
  background(0);
  rectMode(RADIUS);  

  dateX = width/10;
  dateY = height - 2 * height/8;
  guideX = dateX;
  guideY = height/8;

  String[][] fileNames = {
    {"PC00.05 (In).csv", "PC00.05 (Out).csv"}, 
    {"PC00.06 (In).csv", "PC00.06 (Out).csv"}, 
    {"PC00.07 (In).csv", "PC00.07 (Out).csv"}, 
    {"PC00.08 (In).csv", "PC00.08 (Out).csv"}, 
    {"PC00.09 (In).csv", "PC00.09 (Out).csv"}, 
    {"PC01.11 (In).csv", "PC01.11 (Out).csv"}, 
    {"PC01.12 (In).csv", "PC01.12 (Out).csv"}, 
    {"PC01.13 (In).csv", "PC01.13 (Out).csv"}, 
    {"PC02.14 (In).csv", "PC02.14 (Out).csv"}, 
    {"PC02.15 (In).csv", "PC02.15 (Out).csv"}, 
    {"PC02.16 (In).csv", "PC02.16 (Out).csv"}, 
    {"PC03.17 (In).csv", "PC03.17 (Out).csv"}, 
    {"PC04.20 (In).csv", "PC04.20 (Out).csv"}, 
    {"PC05.21 (In).csv", "PC05.21 (Out).csv"}, 
    {"PC05.22 (In).csv", "PC05.22 (Out).csv"}, 
    {"PC05.23 (In).csv", "PC05.23 (Out).csv"}, 
    {"PC05.24 (In).csv", "PC05.24 (Out).csv"}, 
  };
  float pointX005 = 167;
  float pointY005 = 429;
  float pointX006 = 383;
  float pointY006 = 495;
  float pointX007 = 145;
  float pointY007 = 321;
  float pointX008 = 680;
  float pointY008 = 494;
  float pointX009 = 224;
  float pointY009 = 524;
  float pointX111 = 321;
  float pointY111 = 433;
  float pointX112 = 529;
  float pointY112 = 434;
  float pointX113 = 367;
  float pointY113 = 343;
  float pointX214 = 763;
  float pointY214 = 474;
  float pointX215 = 607;
  float pointY215 = 434;
  float pointX216 = 752;
  float pointY216 = 374;
  float pointX317 = 438;
  float pointY317 = 427;
  float pointX420 = 267;
  float pointY420 = 456;
  float pointX521 = 781;
  float pointY521 = 371;
  float pointX522 = 578;
  float pointY522 = 471;
  float pointX523 = 594;
  float pointY523 = 535;
  float pointX524 = 129;
  float pointY524 = 403;

  float[][] points = {
    {pointX005, pointY005, 0}, 
    {pointX006, pointY006, 0}, 
    {pointX007, pointY007, 0}, 
    {pointX008, pointY008, 0}, 
    {pointX009, pointY009, 0},
    {pointX111, pointY111, floorZ}, 
    {pointX112, pointY112, floorZ}, 
    {pointX113, pointY113, floorZ}, 
    {pointX214, pointY214, 2 * floorZ}, 
    {pointX215, pointY215, 2 * floorZ}, 
    {pointX216, pointY216, 2 * floorZ}, 
    {pointX317, pointY317, 3 * floorZ}, 
    {pointX420, pointY420, 4 * floorZ}, 
    {pointX521, pointY521, 5 * floorZ}, 
    {pointX522, pointY522, 5 * floorZ}, 
    {pointX523, pointY523, 5 * floorZ}, 
    {pointX524, pointY524, 5 * floorZ}};

  for (int i = 0; i < fileNames.length; i++) {
    PeopleCounter sensor = new PeopleCounter(points[i][0], points[i][1], points[i][2]);
    DataCleaner cleaner = new DataCleaner(fileNames[i][0], fileNames[i][0], sensor);
    cleaner.cleanInData();

    sensors.add(sensor);
  }
  dayNum = sensors.get(0).getDays().size();
  timeNum = sensors.get(0).getDays().get(1).getTimelineLength();
  time = 20;
  
  BackgroundMusic music = new BackgroundMusic(new Minim(this), "Coffee_Shop.mp3");
  soundEffect = new BackgroundMusic(new Minim(this), "Away_In_A_Manger.mp3");
  music.play();
}

void mousePressed(){
  soundEffect.play();
}

void mouseReleased(){
  soundEffect.pause();
}

void drawBuilding() {
  for (int i = 0; i < floorShapes.length; i++) {
    pushMatrix();
    translate(0, 0, i*floorZ);
    shape(floorShapes[i]);
    popMatrix();
  }
}

void draw() {
  background(0);
  //println("x: " + mouseX);
  //println("y: " + mouseY);
  writeLevels();
  pushMatrix();
  translate(x, y, 5 * floorZ);
  writeDayAndTime();
  writeGuide();
  popMatrix();
  pushMatrix();
  visualizeCount();
  popMatrix();
  drawBuilding();
}

void visualizeCount() {
  for (PeopleCounter sensor : sensors) {
    GroupVisualiser visualiser = new GroupVisualiser(sensor);
    pushMatrix();
    translate(x, y-50, 0);
    visualiser.visualise(day, time);
    popMatrix();
  }
}

void writeLevels(){
  for (int i = 0; i < floorShapes.length; i++) {
    writeLevel(i);
  }
}

void writeLevel(int number){
  textSize(20);
  fill(255);
  pushMatrix();
  translate(x-100,y, number * floorZ);
  String level = "Level " + number;
  text(level, 0, guideY + 300);
  popMatrix();
}

void writeGuide() {
  cam.beginHUD();
  textSize(20);
  fill(255);
  String dayGuide = "> Press LEFT or RIGHT to change date";
  text(dayGuide, guideX, guideY);
  String timeGuide = "> Press UP or DOWN to change time";
  text(timeGuide, guideX, guideY + 30);
  String mouseGuide = "> Use mouse to pan, rotate, and zoom";
  text(mouseGuide, guideX+ 500, guideY);
  cam.endHUD();
}

void writeDayAndTime() {
  cam.beginHUD();
  pushMatrix();
  textSize(20);
  fill(255);
  String dayString = "Date: " + sensors.get(0).getDays().get(day).date;
  text(dayString, dateX, dateY);
  String timeString = "Time: " + sensors.get(0).getDays().get(day).getTimeline().get(time).time;
  text(timeString, dateX + 200, dateY);
  popMatrix();
  cam.endHUD();
}

void keyPressed()
{
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      if (day>0 && day<=dayNum-1) {
        day--;
        println("day decreased: " + day);
      }
    } else if (keyCode == RIGHT)
    {
      if (day>=0 && day<dayNum-1) {
        day++;
        println("day increased: " + day);
      }
    } else if (keyCode == DOWN)
    {
      if (time>0 && time<=timeNum-2) {
        time--;
        println("time decreased: " + time);
      }
    } else if (keyCode == UP)
    {
      if (time>=0 && time<timeNum-2) {
        time++;
        println("time increased: "  + time);
      }
    }
  }
}