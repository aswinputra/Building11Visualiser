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