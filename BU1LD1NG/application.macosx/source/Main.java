import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import peasy.*; 
import peasy.org.apache.commons.math.*; 
import peasy.org.apache.commons.math.geometry.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Main extends PApplet {

 //<>//










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

public void setup() {
  frameRate(15);
  
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

public void mousePressed(){
  soundEffect.play();
}

public void mouseReleased(){
  soundEffect.pause();
}

public void drawBuilding() {
  for (int i = 0; i < floorShapes.length; i++) {
    pushMatrix();
    translate(0, 0, i*floorZ);
    shape(floorShapes[i]);
    popMatrix();
  }
}

public void draw() {
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

public void visualizeCount() {
  for (PeopleCounter sensor : sensors) {
    GroupVisualiser visualiser = new GroupVisualiser(sensor);
    pushMatrix();
    translate(x, y-50, 0);
    visualiser.visualise(day, time);
    popMatrix();
  }
}

public void writeLevels(){
  for (int i = 0; i < floorShapes.length; i++) {
    writeLevel(i);
  }
}

public void writeLevel(int number){
  textSize(20);
  fill(255);
  pushMatrix();
  translate(x-100,y, number * floorZ);
  String level = "Level " + number;
  text(level, 0, guideY + 300);
  popMatrix();
}

public void writeGuide() {
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

public void writeDayAndTime() {
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

public void keyPressed()
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
class BackgroundMusic{
  AudioPlayer sound;
  
  public BackgroundMusic(Minim minim, String fileName){
    sound = minim.loadFile("./data/" + fileName, 512);
  }
  
  public void play(){
    sound.play();
    sound.loop();
  }
  
  public void pause(){
    sound.pause();
  }
  
  public void replay(){
    pause();
    play();
  }
  
  public void end(){
    sound.close();
  }
}
class DataCleaner {
  String inFileName;
  String outFileName;
  PeopleCounter sensor;
  final String DATE = "DATE";
  final String TIME = "TIME";
  final String IN = "In";
  final String OUT = "Out";

  DataCleaner(String inFileName, String outFileName, PeopleCounter sensor) {
    this.inFileName = inFileName;
    this.outFileName = outFileName;
    this.sensor = sensor;
  }

  public void cleanInData() {
    Table cleanTable = new Table();
    cleanTable.addColumn(DATE, Table.STRING);
    cleanTable.addColumn(TIME, Table.STRING);
    cleanTable.addColumn(IN, Table.INT);
    cleanTable.addColumn(OUT, Table.INT);

    Table rawInTable = loadTable(inFileName);
    Table rawOutTable = loadTable(outFileName);
    int dateTimeCol = 0;
    int countCol = 1;
    for (int rowNum = 0; rowNum < rawInTable.getRowCount(); rowNum++) {
      String dateTime = rawInTable.getString(rowNum, dateTimeCol);
      String[] splittedDateTime = dateTime.split(" ");

      TableRow row = cleanTable.addRow();
      row.setString(DATE, splittedDateTime[0]);
      row.setString(TIME, splittedDateTime[1]);
      row.setInt(IN, rawInTable.getInt(rowNum, countCol));
      row.setInt(IN, rawOutTable.getInt(rowNum, countCol));
    }

    println(cleanTable.getRowCount() + " total rows in cleanTable"); 

    saveDataInSensorObject(cleanTable);
  }

  private void saveDataInSensorObject(Table cleanTable) {
    ArrayList<PCDay> days = new ArrayList<PCDay>();
    PCTime pcTime = null;
    for (TableRow row : cleanTable.rows()) {
      PCDay pcDay = null;
      //checking for the any existing date
      for (PCDay d : days) {
        if (d.isThisDate(row.getString(DATE))) {
          pcDay = d;
        }
      }

      //if it doesn't exist yet, create one and add it to the list
      if (pcDay == null) {
        pcDay = new PCDay(row.getString(DATE));
        days.add(pcDay);
      }

      pcTime = new PCTime(row.getString(TIME));
      pcTime.inCount = row.getInt(IN);
      pcTime.outCount = row.getInt(OUT);
      pcDay.addTime(pcTime);
    }
    sensor.setDays(days);
  }
}
class GroupVisualiser {
  float pointX;
  float pointY;
  float pointZ;
  int numberOfPeople;
  private PeopleCounter sensor;
  int horizontalDirection = 3;
  int verticalDirection = 3;

  GroupVisualiser(float pointX, float pointY, int numberOfPeople ) {
    this.pointX = pointX;
    this.pointY = pointY;
    this.numberOfPeople = numberOfPeople;
  }

  GroupVisualiser(PeopleCounter sensor) {
    this.pointX = sensor.pointX();
    this.pointY = sensor.pointY();
    this.pointZ = sensor.pointZ();
    this.sensor = sensor;
  }

  public void visualise(int dayNum, int timeNum) {
    float XBoundLeft = pointX - 30;
    float XBoundRight = pointX + 30;
    float YBoundLeft = pointY - 30;
    float YBoundRight = pointY + 30;
    int i = 0;
    try {
      numberOfPeople = sensor.getDays().get(dayNum).getTimeline().get(timeNum).getCount();
    }
    catch(Exception e) {
      numberOfPeople = 0;
    }
    fill(0, 255, 0);
    stroke(140);
    translate(0,0,pointZ);
    while (i < numberOfPeople) {
      fill(0,255,0);
      stroke(140);
      ellipse(random(XBoundLeft, XBoundRight), random(YBoundLeft, YBoundRight), 5, 5);
      i++;
    }
    fill(153);
  }
}
class PCDay{
  private String date = "";
  private ArrayList<PCTime> pcTimeline; 
  
  PCDay(String date){
    this.date = date;
    this.pcTimeline = new ArrayList<PCTime>();
  }
  
  public void addTime(PCTime time){
    pcTimeline.add(time);
  }
  
  public void setTimeLine(ArrayList<PCTime> pcTimeline){
    this.pcTimeline = pcTimeline;    
  }    
  
  public ArrayList<PCTime> getTimeline(){
    return pcTimeline;
  }
  
  public int getTimelineLength(){
    return pcTimeline.size();
  }
  
  public String getDate(){
    return date;
  }
  
  public boolean isThisDate(String date){
    return this.date.equals(date);
  }
}
class PCTime{
  String time;
  int inCount;
  int outCount;
  
  PCTime(String time){
    this.time = time;
  }
  
  public String toString(){
    String s = "";
    s = "DateTime: " + time + "\n" + 
        "InCount: " + inCount + "\n" + 
        "outCount: " + outCount;
    return s;
  }
  
  public int getCount(){
    if(outCount >= inCount){
      return 0;
    }else{
      return inCount - outCount;
    }
  }
}
class PeopleCounter {
  private float pointX;
  private float pointY;
  private float pointZ;
  private ArrayList<PCDay> days;
  
  PeopleCounter(float pointX, float pointY, float pointZ){
    this.pointX = pointX;
    this.pointY = pointY;
    this.pointZ = pointZ;
    this.days = new ArrayList<PCDay>();
  }
  
  public float pointX(){
    return pointX;
  }
  
  public float pointY(){
    return pointY;
  }
  
  public float pointZ(){
    return pointZ + 5;
  }
  
  public void setDays(ArrayList<PCDay> days){
    this.days = days;
  }
  
  public ArrayList<PCDay> getDays(){
    return days;
  }
}
  public void settings() {  size(1000, 800, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
