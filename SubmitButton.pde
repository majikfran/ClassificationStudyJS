public class SubmitButton
{
  String textString;
  int positionX;
  int positionY;
  int _width;
  int _height;
  public boolean thisSelected= false;
  public boolean enabled = false;
  boolean clicked = false;
  
  public SubmitButton(String aText, int posx, int posy, int aWidth, int aHeight)
  {
    textString = aText;
    positionX = posx;
    positionY = posy;
    _width = aWidth;
    _height = aHeight;
  }
  
  void draw()
  {
    fill(Colors.DARKERGREY);
    if(enabled && !clicked)
    {
      if(mouseOver())
      {
        fill(Colors.MIDGREY);
        
        if(mousePressed && mouseButton == LEFT)
        {
          if(!LockTest.locked || thisSelected)
          {
            fill(Colors.BLUE);
            LockTest.locked = true;
            thisSelected = true;
            
            IntegerSet superGroups = new IntegerSet();
            
            if(Settings.app.Groups.size() > 0)
            {
              //Groupings
              String groupString = "";
              String groupLocations = "";
              for(Group g : Settings.app.Groups)
              {
                groupLocations += g.groupIndex + "," + g.position.x + "," + g.position.y + ";";
                superGroups.add(g.groupColorIndex);
                groupString += g.groupIndex;
                for(VizSample v : g.VizSamples)
                {
                  groupString += "," + v.getId();
                }
                groupString += ";";
              }
              
              //SuperGroupings
              String superGroupString = "";
              for(Integer i : superGroups.data)
              {
                superGroupString += i;
                for(Group g : Settings.app.Groups)
                {
                  if(g.groupColorIndex == i)
                  {
                      superGroupString += "," + g.groupIndex;
                  }
                }
                superGroupString += ";";
              }
            }
            
            
            submit(groupString, superGroupString, groupLocations);
            clicked =true;
          }
        }
      }
    
    //positionX  = width - _width;
    
    rect(positionX -(_width/2), positionY, _width, _height);
    
    fill(Colors.White);
   
    textSize(32);
    textAlign(CENTER, CENTER);
    text(textString, positionX, positionY + (_height / 2));
    }
  }
  
  boolean mouseOver()
  {
      if(mouseX > positionX - (_width /2)
      && mouseX < positionX + (_width /2)
      && mouseY > positionY
      && mouseY < positionY + _height)
        return true; 
 
    return false;
  }
}
