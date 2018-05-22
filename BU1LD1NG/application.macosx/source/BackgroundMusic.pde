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