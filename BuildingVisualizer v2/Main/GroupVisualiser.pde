class GroupVisualiser {
  float pointX;
  float pointY;
  float pointZ;
  int numberOfPeople;
  private PeopleCounter sensor;

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
    float XBoundLeft = pointX - 50;
    float XBoundRight = pointX + 50;
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
    ellipse(pointX, pointY, numberOfPeople, numberOfPeople);

    fill(153);
  }
}