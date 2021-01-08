class Example implements NotificationListener {
  
  public Example() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + " ms");
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case muscle:
        debugOutput += "Muscle: ";
        if (!minInv) {
          if (notification.getMuscle().equals("calf")) {
            //calfSlider(notification.getContraction());
            calfSlider.setValue(notification.getContraction());
            calfSlider(notification.getContraction());
          } else if (notification.getMuscle().equals("hamstring")) {
            innerLegSlider.setValue(notification.getContraction());
            innerLegSlider(notification.getContraction());
          } else if (notification.getMuscle().equals("outer leg")) {
            outerLegSlider.setValue(notification.getContraction());
            outerLegSlider(notification.getContraction());
          } else if (notification.getMuscle().equals("glutes")) {
            gluteSlider.setValue(notification.getContraction());
            gluteSlider(notification.getContraction());
          }
        }
        if (notification.getFlag().equals("bad")) {
          ttsExamplePlayback(notification.getMuscle());
        }
        break;
      case align:
        alignmentSlider.setValue(notification.getPercent());
        alignmentSlider(notification.getPercent());
        align();
        //debugOutput += "Person moved at home: ";
        break;
      case weightdist:
        GainSlider.setValue(notification.getZpos() * 80);
        GainSlider(notification.getZpos()*80);
        xyGrid.setValue(notification.getXpos(), notification.getYpos());
        xyGrid();
      //  break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    //println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}
