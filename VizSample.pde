public class VizSample
{
  PVector targetPos;
  PVector pos;
  PApplet app;
  float headingX = 0;
  float headingY = 0;
  MathUtil math;
  float mass = 2;
  float diameter = Settings.SAMPLE_DIAMETER;
  boolean move = true;
  boolean colliding = true;
  float DeadZone = Settings.DEAD_ZONE;
  float internalEnergyConserved = 1;
  boolean thisSelected = false; 
  float imageWidth = 66.7;
  float imageHeight = 44.5;
  float hoverWidth = 66.7;
  float hoverHeight = 44.5;
  float imageRatio = 0;
  PImage imageFile;
  String Id;
  
  VizSample(PApplet pApplet, PVector target, PImage _image, String id)
  {
    targetPos = target;
    pos = target;
    math = new MathUtil();
    app = pApplet;
    imageFile = _image;
    Id = id;
    
    image(imageFile, 0, 0);
    
  }
  
  String getId()
  {
    return Id;  
  }
  
  boolean mouseOver()
  {
      if(mouseX > pos.x - (hoverWidth / 2)
      && mouseX < pos.x + (hoverWidth / 2)
      && mouseY > pos.y - (hoverHeight / 2)
      && mouseY < pos.y + (hoverHeight / 2))
        return true; 
 
    return false;
  }
  

  void draw()
  {
    move = true;
    noStroke();
    if(mouseOver() || thisSelected)
    {      
      if(mousePressed && mouseButton == LEFT)
      {
        if(!LockTest.locked || thisSelected)
        {
          LockTest.locked = true;
          thisSelected = true;
          fill(Colors.RED);
          move = false;
          //pos.x += mouseX - pmouseX;
          //pos.y += mouseY - pmouseY;
          pos.x = mouseX;
          pos.y = mouseY;
        }
      }
      else if(mousePressed && mouseButton == RIGHT)
      {
        if(!LockTest.locked)
        {
           LockTest.locked = true;
           Settings.zoomImage = imageFile;
           Settings.zoom = true;
           Settings.ratio = imageRatio;
        }
      }
    }
  
    
   
    
    if(move)
    {
      if(getSpeed() > Settings.MAX_SPEED  )
      {
        float xProp = abs(headingX) / (abs(headingX) + abs(headingY));
        float yProp = 1 - xProp;
  
        headingX *= Settings.ENERGY_CONSERVED;  
        headingY *= Settings.ENERGY_CONSERVED;
  
        headingX = (headingX > 0) ? xProp * Settings.MAX_SPEED : xProp * -Settings.MAX_SPEED;
        headingY = (headingY > 0) ? yProp * Settings.MAX_SPEED : yProp * -Settings.MAX_SPEED;
      }
    
    
    
    
      headingX *= internalEnergyConserved;
      headingY *= internalEnergyConserved;
      pos.x += headingX;
      pos.y += headingY;
      update();
    }
    
    
  
    if(imageRatio == 0)
    {
      fill(Colors.DARKGREY);
      rect(pos.x - (imageWidth /2), pos.y - (imageHeight/2), 66.7, 44.5);
      if(imageFile.width > 0 && imageFile.height > 0)
      {
        imageRatio = (float)imageFile.width / (float)imageFile.height;
      }
    }
    else
    {
      

      if(imageRatio <= 1)
      {
        if(mouseOver())
        imageHeight = 75;
      else
        imageHeight = 44.5;
        image(imageFile, pos.x - ((imageHeight / imageRatio) /2), pos.y - (imageHeight  /2), imageHeight / imageRatio, imageHeight);
      }
      else
      {
        if(mouseOver())
        imageWidth = 150;
      else
        imageWidth = 66.7;
        
        image(imageFile, pos.x - (imageWidth /2), pos.y - ((imageWidth / imageRatio) /2), imageWidth, imageWidth / imageRatio);
      }
    }
  }

  void released()
  {
    thisSelected = false;
    boolean found = false;
    int sampleGroupIndex = 0;
    boolean dontMove = false;
    PVector currentPosition = new PVector(mouseX, mouseY);
 
    Settings.app.panel.getVizSamples().remove(this);
    for(int i = 0; i < Settings.app.Groups.size(); i++)
    {
      if(Settings.app.Groups.get(i).VizSamples.contains(this))
      {
        sampleGroupIndex = i;
        Settings.app.Groups.get(i).VizSamples.remove(this);
      }
    }
    
    if(Settings.app.panel.contains(currentPosition))
    {
      found = true;
      Settings.app.panel.addSample(this);
    }

    if(Settings.app.Groups.size() >0)
    {
      if(Settings.app.Groups.get(sampleGroupIndex).contains(currentPosition))
      {
        Settings.app.Groups.get(sampleGroupIndex).addSample(this);
        found = true;
      }
      else
      {
        for(int i = 0; i < Settings.app.Groups.size(); i++)
        {
          if(Settings.app.Groups.get(i).contains(currentPosition) && !found)
          {
            Settings.app.Groups.get(i).addSample(this);
            found = true;
          }
        }
      }
    }

    if(!found && !dontMove)
    {
      Group newGroup = new Group(currentPosition.x, currentPosition.y, "Group", Settings.app);
      
      newGroup.addSample(this);
      newGroup.setIndex(Settings.app.Groups.size() + 1);
      Settings.app.Groups.add(newGroup); 
    }
  }

  void update()
  {
    if(math.cartDist(pos, targetPos) > DeadZone)
    {
      internalEnergyConserved = 1;
      move = true;
      applyForce(-15000.0, targetPos, true);
    }
    else if(colliding)
    {
      internalEnergyConserved = .99f;
      move = true;
    }
    else
    {
      internalEnergyConserved = .75f;
      //move = false;
    }
    colliding = false;
  }
  
  void applyForce(float f, PVector targetPos, boolean deadZone)
  {
    float force = f;
    float vector = 0;
    float time = 1 / frameRate;
    float distance = sqrt((math.dif(targetPos.x, pos.x) * math.dif(targetPos.x, pos.x)) +  (math.dif(targetPos.y, pos.y) * math.dif(targetPos.y, pos.y)));
    float intensity = force / (1 + distance);

    if (targetPos.x < pos.x && targetPos.y > pos.y)
    {
      vector =atan(math.dif(targetPos.x, pos.x) / math.dif(targetPos.y, pos.y));
    }
    if (targetPos.x < pos.x && targetPos.y < pos.y)
    {
      vector = PI - atan(math.dif(targetPos.x, pos.x) / math.dif(targetPos.y, pos.y));
    }
    if (targetPos.x > pos.x && targetPos.y < pos.y)
    {
      vector = PI + atan(math.dif(targetPos.x, pos.x) / math.dif(targetPos.y, pos.y));
    }
    if (targetPos.x > pos.x && targetPos.y > pos.y)
    {
      vector = TWO_PI - atan(math.dif(targetPos.x, pos.x) / math.dif(targetPos.y, pos.y));
    }

    float accl = intensity / mass;
    float tempSpeed = accl * time;
    if(math.cartDist(pos, targetPos) < Settings.DEAD_ZONE && deadZone)
    {
      tempSpeed *= (math.cartDist(pos, targetPos) / Settings.DEAD_ZONE);
    }

    float tempInvVector = 0;
    float tempVector = 0;
    float tempX = 0;
    float tempY = 0;

    int quadrant = (int)(vector / HALF_PI);   
    if (quadrant == 0)
    {
      tempInvVector = HALF_PI - vector;
      tempVector = vector;
      headingX += cos(tempInvVector) * tempSpeed;
      headingY -= cos(tempVector) * tempSpeed;
    }
    else if (quadrant == 1)
    {
      tempInvVector = PI - vector;
      tempVector = vector - HALF_PI;
      headingX += cos(tempVector) * tempSpeed;
      headingY += cos(tempInvVector) * tempSpeed;
    }
    else if (quadrant == 2)
    {
      tempInvVector = (HALF_PI * 3) - vector;
      tempVector = vector - PI;
      headingX -= cos(tempInvVector) * tempSpeed;
      headingY += cos(tempVector) * tempSpeed;
    }
    else
    {
      tempInvVector = TWO_PI - vector;    
      tempVector = vector - (HALF_PI * 3);
      headingX -= cos(tempVector) * tempSpeed;
      headingY -= cos(tempInvVector) * tempSpeed;
    }
  }
  
  void updatePositionAndSize(PVector position, float size)
  {
    targetPos = position;
    DeadZone = size - Settings.SAMPLE_DIAMETER / 2;
  }
  
  float getDiameter()
  {
    return diameter;
  }
  
  float getSpeed()
  {
    float tempHx = 0;
    float tempHy = 0;
    if (headingX < 0)
    {
      tempHx = -headingX;
    }
    else
    {
      tempHx = headingX;
    }
    if (headingY < 0)
    {
      tempHy = -headingY;
    }
    else
    {
      tempHy = headingY;
    }

    return sqrt((tempHx * tempHx) + (tempHy * tempHy));
  }
}
