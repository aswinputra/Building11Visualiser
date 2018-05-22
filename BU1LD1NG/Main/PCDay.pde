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