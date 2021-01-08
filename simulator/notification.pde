enum NotificationType { muscle, align, weightdist }

class Notification {
   
  int timestamp;
  NotificationType type;
  String muscle;
  float contraction;
  String flag;
  int priority;
  float percent;
  float xpos;
  float ypos;
  float zpos;
  
  public Notification(JSONObject json) {
    this.timestamp = json.getInt("timestamp");
    //time in milliseconds for playback from sketch start
    
    String typeString = json.getString("type");
    
    try {
      this.type = NotificationType.valueOf(typeString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(typeString + " is not a valid value for enum NotificationType.");
    }
    
    this.priority = json.getInt("priority");
    //1-3 levels (1 is highest, 3 is lowest) 
    
    switch(type) {
      case muscle:
        if (json.isNull("muscle")) {
        this.muscle = "";
        }
        else {
          this.muscle = json.getString("muscle");
        }
    
        if (json.isNull("contraction")) {
          this.contraction = 0.0;
        }
        else {
          this.contraction = json.getFloat("contraction");    
        }
        if (json.isNull("flag")) {
          this.flag = "";
        } 
        else {
          this.flag = json.getString("flag"); 
        }
        break;
      case align:
        if (json.isNull("percent")) {
        this.percent = 0.0;
        }
        else {
          this.percent = json.getFloat("percent");
        }
        if (json.isNull("flag")) {
          this.flag = "";
        } 
        else {
          this.flag = json.getString("flag"); 
        }
        break;
      case weightdist: //<>//
        if (json.isNull("xpos")) {
          this.xpos = 0.0;
        }
        else {
          this.xpos = json.getFloat("xpos");
        }
        if (json.isNull("ypos")) {
          this.ypos = 0.0;
        }
        else {
          this.ypos = json.getFloat("ypos");
        }
        if (json.isNull("zpos")) {
          this.zpos = 1.0;
        }
        else {
          this.zpos = json.getFloat("zpos");
        }
        break;
    }   
  }
  
  public int getTimestamp() { return timestamp; }
  public NotificationType getType() { return type; }
  public String getMuscle() { return muscle; }
  public float getContraction() { return contraction; }
  public float getPercent() { return percent; }
  public float getXpos() { return xpos; }
  public float getYpos() { return ypos; }
  public float getZpos() { return zpos; }
  public String getFlag() { return flag; }
  public int getPriorityLevel() { return priority; }
  
  public String toString() {
      String output = getType().toString() + ": ";
      output += "(priority: " + getPriorityLevel() + ") ";
      switch(type) {
        case muscle:
          output += "(muscle: " + getMuscle() + ") ";
          output += "(contraction: " + getContraction() + ") ";
          output += "(flag: " + getFlag() + ") ";
          break;
        case align:
          output += "(percent: " + getPercent() + ") ";
          output += "(flag: " + getFlag() + ") ";
          break;
        case weightdist:
          //output += "(xpos: " + getXpos() + ") ";
          //output += "(ypos: " + getYpos() + ") ";
          //output += "(zpos: " + getZpos() + ") ";
          break;
      }
      return output;
    }
}
