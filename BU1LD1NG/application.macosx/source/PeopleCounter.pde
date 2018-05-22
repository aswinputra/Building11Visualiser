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