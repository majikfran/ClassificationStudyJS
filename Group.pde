public class Group {
  PVector position;
  float diameter;
  final float initDiameter = 40;
  String label;
  PApplet app;
  color groupColor;
  int strokeWidth = 10;
  int padding = 1;
  ArrayList<VizSample> VizSamples;
  MathUtil math;
  PVector oldMouse;
  boolean thisSelected = false;
  color fillColor = color(00,70,120);
  color rollOver = color(00,80,250);
  color strokeColor = color(00,70,120);
  int groupIndex;
  int groupColorIndex = 0;
  boolean wasSet = false;
  ArrayList<Integer> collidesWith;
  color labelColor = Colors.WHITE;
  int colorSubtract = 0;
  
  float getDiameter()
  {
    return diameter;
  }

  Group(float posX, float posY, String label, PApplet app)
  {
    math = new MathUtil();
    collidesWith = new ArrayList<Integer>();
    VizSamples = new ArrayList<VizSample>();
    position = new PVector();
    position.x = posX;
    position.y = posY;
    this.label = label; 
    this.app = app;

    diameter = initDiameter;
  }
  
  void setIndex(int index)
  {
    groupIndex = index;
  }

  void draw()
  {
    if(groupColorIndex >= Colors.RINGROLLOVERS.length)
        colorSubtract = Colors.RINGROLLOVERS.length;
      else
        colorSubtract = 0;
        
    if(mouseOver())
    {
      fill(Colors.RINGROLLOVERS[groupColorIndex - colorSubtract]);
      strokeColor = Colors.RINGROLLOVERS[groupColorIndex - colorSubtract];
      labelColor = Colors.BLACK;
    }
    else
    {
      fill(Colors.RINGCOLORS[groupColorIndex - colorSubtract]);
      strokeColor = Colors.RINGCOLORS[groupColorIndex - colorSubtract];
      labelColor = Colors.WHITE;
    }
      
    drawBounds();
    drawLabel();
    
    for(VizSample v : VizSamples)
      v.draw();
      
    
    if(mouseOver() || thisSelected)
    {
      if(mousePressed)
      {
        if(!LockTest.locked || thisSelected)
        {
          LockTest.locked = true;
          thisSelected = true;
          Settings.GroupMove = true;
          
          if(position.x > diameter + 10 && position.x < Settings.app.width - Settings.app.panel.getWidth() - diameter - 10 && position.y > diameter + 20 && position.y < Settings.app.height - diameter - 10)
          {
            position.x += mouseX - pmouseX;
            position.y += mouseY - pmouseY;
          }
          else
          {
            if(position.x <= diameter + 10)
              position.x = diameter + 11;
            else if(position.x >= Settings.app.width  - Settings.app.panel.getWidth() - diameter -10)
              position.x = Settings.app.width - Settings.app.panel.getWidth() - diameter -11;
            else if(position.y <= diameter +20)
              position.y = diameter + 21;  
            else if(position.y >= Settings.app.height - diameter -10)
              position.y = Settings.app.height - diameter -11;
          }
        }
      }      
    }
    updateContent();
  }
  
  boolean contains(PVector p)
  {
    if(math.cartDist(position, p) < diameter)
      return true;
      
    return false;
  }


  void drawBounds()
  {

    calcSize();
    //stroke(Colors.RED);
    //strokeWeight(strokeWidth);
    ring(position.x, position.y, diameter, diameter - strokeWidth);
    //ellipse(position.x, position.y, diameter, diameter);
  }
  
  void ring(float centreX, float centreY, float radiusOuter, float radiusInner)
  {
    beginShape();
      buildLabel(centreX, centreY, radiusOuter);
    endShape();
    
    pushMatrix();
    noFill();
    strokeWeight(10);
    stroke(strokeColor);
    ellipse(centreX, centreY, radiusOuter*2, radiusOuter*2);
    popMatrix();
    /*beginShape();
      buildCircle(centreX, centreY, radiusOuter, true);
      buildCircle(centreX, centreY, radiusInner, false);
    endShape();*/
  }
  
  void calcSize()
  {
    float totalArea = (float)( PI * Math.pow(Settings.SAMPLE_DIAMETER, 2)) * VizSamples.size();
    diameter = sqrt(totalArea) / PI + (Settings.SAMPLE_DIAMETER/4);
    //diameter = sqrt(VizSamples.size()) * (Settings.SAMPLE_DIAMETER - (VizSamples.size() / Settings.SAMPLE_DIAMETER)) ;
  }

void buildLabel(float centreX, float centreY, float radius)
{
  noStroke();
  float labelWidth = textWidth(label + " " + groupIndex) + 10;
  float labelHeight = 20;
  float yCor = (float) (centreY - Math.sqrt(Math.pow(radius, 2) - Math.pow(labelWidth/2, 2))  );
  float xCor = centreX - (labelWidth/2);
  vertex(xCor, yCor);
  vertex(xCor, centreY - radius - labelHeight);
  vertex(xCor + labelWidth, centreY - radius - labelHeight);
  vertex(xCor + labelWidth, yCor);
}

boolean labelContains()
{
  float labelWidth = textWidth(label + " " + groupIndex) + 10;
  float labelHeight = 20;
  float yCor = (float) (position.y - Math.sqrt(Math.pow(diameter, 2) - Math.pow(labelWidth/2, 2)));
  float xCor = position.x - (labelWidth/2);
  
  if(mouseX > xCor && mouseX < xCor + labelWidth && mouseY < yCor && mouseY > yCor - labelHeight)
    return true;
  
  return false;
}

void buildCircle(float cx, float cy, float r, boolean isClockwise)
{
  int numSteps = 10;
  float inc = TWO_PI/numSteps;
     
  if (isClockwise)
  {
    // First control point should be penultimate point on circle.
    curveVertex(cx+r*cos(-inc),cy+r*sin(-inc));
    
    for (float theta=0; theta<TWO_PI-0.01; theta+=inc)
    {
      curveVertex(cx+r*cos(theta),cy+r*sin(theta));
    }
    curveVertex(cx+r,cy);
    
    // Last control point should be second point on circle.
    curveVertex(cx+r*cos(inc),cy+r*sin(inc));
    
    // Move to start position to keep curves in circle.
    //vertex(cx+r,cy);
  }
  else
  {
    // Move to start position to keep curves in circle.
   // vertex(cx+r,cy);
    
    // First control point should be penultimate point on circle.
    vertex(cx+r*cos(inc),cy+r*sin(inc));
        
    for (float theta=TWO_PI; theta>0.01; theta-=inc)
    {
      curveVertex(cx+r*cos(theta),cy+r*sin(theta));
    }
    curveVertex(cx+r,cy);
     
    // Last control point should be second point on circle.
    curveVertex(cx+r*cos(TWO_PI-inc),cy+r*sin(TWO_PI -inc));
  }  
}

  PVector cornerCoords()
  {
    return new PVector(position.x - (diameter/2), position.y - (diameter/2));
  }

  void updateContent()
  {
    for (VizSample v: VizSamples)
    {
      v.updatePositionAndSize(position, diameter);
    }
    
    detectCollision();
  }

  void drawLabel()
  {
    
    float yCoord = position.y - (diameter) - padding;
    textAlign(CENTER, BOTTOM);
    //rect(position.x - ((textWidth(label)+4)/2), yCoord + 5, textWidth(label) + 4, -20);
    fill(labelColor);
    text(label + " " + groupIndex, position.x, yCoord);
  }

  float calculateLayout()
  {
    return 0f;
  }

  void addSample(VizSample sample)
  {
    VizSamples.add(sample);
  }
  
  boolean mouseOver()
  {
    
   if(math.cartDist(new PVector(mouseX, mouseY), position) < diameter || labelContains())
      return true; 
 

    return false;
  }

  void detectCollision()
  { 
    for (int e = 0; e < VizSamples.size(); e++)
    {
      for (int i = 0; i < VizSamples.size(); i++)
      {
        if (i != e && ((VizSamples.get(e).getDiameter() / 2) + (VizSamples.get(i).getDiameter()/2)) >= math.cartDist(VizSamples.get(e).pos, VizSamples.get(i).pos))
        {
          float force = ((VizSamples.get(e).getDiameter() + VizSamples.get(i).getDiameter()) * (VizSamples.get(e).getSpeed() + VizSamples.get(i).getSpeed()));
          VizSamples.get(e).applyForce(force * 10, math.midPoint(VizSamples.get(e).pos, VizSamples.get(i).pos), false);
          VizSamples.get(e).colliding = true;
        }
      }
    }
  }
}

