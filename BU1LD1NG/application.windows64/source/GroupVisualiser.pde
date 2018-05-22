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