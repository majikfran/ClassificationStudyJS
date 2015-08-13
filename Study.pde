import java.util.HashSet;

int screenWidth = window.innerWidth;
int screenHeight = window.innerHeight;
float screenRatio = screenWidth/screenHeight;
color BG = color(20, 20, 30);
ArrayList<Group> Groups;
public static boolean selected = false;
PFont myFont = createFont("Verdana", 14);
public Panel panel;
boolean emptyGroup = false;
boolean zoom;
PImage zoomImage;
String studyT;
String SampleT;
public SubmitButton sb;
MathUtil math;
float rotateAngle = 0;
float rotateAngle2 = 0;


void setup()
{
  screenWidth = window.innerWidth;
  screenHeight = window.innerHeight;
  textFont(myFont);
  size(screenWidth, screenHeight);
  frameRate(60);
  smooth();
  
  
  math = new MathUtil();
  
  Packing.init();
  Groups = new ArrayList<Group>();
  zoom=false;
  panel = new Panel("LEFT", 3);
  sb = new SubmitButton("Submit", width - 150, height - 120, 150, 80);
 
  Settings.app = this;
  Settings.app.panel = panel;
  Settings.app.Groups = Groups;
 
}

void resize(int aWidth, int aHeight)
{
  screenWidth = aWidth;
  screenHeight = aHeight;
  setup();
}

void loadImages(String images, String studyType, String sampleType)
{
  studyT = studyType;
  sampleT = sampleType;
  panel.setPanelName(sampleT);
  PImage tempImage;
  String[] imageArray = images.split(";");
  for(String s : imageArray)
  {
    tempImage = loadImage("image.php?f="+s, "");
    panel.addSample(new VizSample(this, new PVector(random(panel.position.x, screenWidth), random(0, screenHeight)), tempImage, s));
  }
}

void draw()
{
  background(BG);
  if(sb.clicked)
  {
    fill(Colors.RINGCOLORS[6]);
    pushMatrix();
      translate(width / 2, height /2);
      rotate(rotateAngle2);
      rect(-40,-40,80,80);
      rotateAngle2 -= 0.03;
    popMatrix();
    fill(Colors.White);
    pushMatrix();
      translate(width / 2, height /2);
      rotate(rotateAngle);
      rect(-30,-30,60,60);
      rotateAngle += 0.06;
    popMatrix();
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Uploading Please Wait...", width / 2, (height /2) + 100);
  }
  else
  {
  
  if(Settings.zoom)
  {
    if(Settings.ratio <= screenRatio)
      image(Settings.zoomImage, (width - (height  - 200) * Settings.ratio)/2 , 100, (height  - 200) * Settings.ratio, height - 200);
    else
      image(Settings.zoomImage, (width - (width  - 200))/2 , 100 , width - 200, (width - 200) / Settings.ratio);
  }
  else
  {  
    if(panel.VizSamples.size() == 0)
      sb.enabled = true;
    else
      sb.enabled = false;
    
    textAlign(CENTER);
    textSize(72);
    fill(Colors.LIGHTBLUE);
    text(studyT, (width - panel.getWidth()) / 2, height/2);
    
    
    textSize(16);
    textAlign(LEFT);
    fill(Colors.WHITE);
    text("Left Click + Move = Drag\nRight Click + Hold = Zoom", 20, 20);
    fill(Colors.LIGHTBLUE);
    textSize(12);
    textAlign(CENTER);
    panel.draw();
    
    for(int i = 0; i < Groups.size(); i++)
    {  
      if(Groups.get(i).VizSamples.size() > 0)
        Groups.get(i).draw();
      
      else 
      {
        if(emptyGroup)
          emptyGroup = false;
          
        Groups.remove(i);
        updateGroupIndicies();
        
      }
    }
    checkSuperGroups();
  }
  
  sb.draw();
  }
}

void updateGroupIndicies()
{
  int count= 1;
  for(Group g : Groups)
  {
    g.setIndex(count);
    count++;
  }
}

void mouseReleased()
{
  LockTest.locked = false;
  Settings.zoom = false;
  
  sb.thisSelected = false;
    
  if(!Settings.GroupMove)
  {
    for(int i = 0; i < Groups.size(); i++)
    {    
      Groups.get(i).thisSelected = false;
      
      if(Groups.get(i).VizSamples.size() > 0)
      {
        for(int j = 0; j < Groups.get(i).VizSamples.size(); j++)
        {
          if( Groups.get(i).VizSamples.get(j).thisSelected)
          {
              Groups.get(i).VizSamples.get(j).thisSelected = false;
              Groups.get(i).VizSamples.get(j).released();
          }
        }
        
      }
      else
        emptyGroup = true;
    }
    
    for(int i = 0; i < panel.VizSamples.size(); i++)
    {
      if(panel.VizSamples.get(i).thisSelected)
      {
         panel.VizSamples.get(i).thisSelected = false;
         panel.VizSamples.get(i).released();
      }      
    }
  }
  else
  {
    
    //checkSuperGroups();
    for(int i = 0; i < Groups.size(); i++)
    {    
      Groups.get(i).thisSelected = false;
    }
  }
  Settings.GroupMove = false;
  checkSuperGroups();
}

void checkSuperGroups()
{
   for (int e = 0; e < Groups.size(); e++)
   {
   Groups.get(e).groupColorIndex = 0;
   Groups.get(e).wasSet = false;
   }
   
  ArrayList<IntegerSet> groupings = new ArrayList<IntegerSet>();
  
  int arrayIndex = -1;
  for (int e = 0; e < Groups.size(); e++)
  {
    IntegerSet chain = buildCollisionChain(e);
    if(!ArrayListContains(groupings, chain) && chain.size() > 1)
      groupings.add(chain);
  }
  
  int colorIndex = 1;
  for(int i = 0 ; i < groupings.size(); i++)
  {
   
    for(int e = 0 ; e < groupings.get(i).size(); e++)
    {
      Groups.get(groupings.get(i).data.get(e)).groupColorIndex = colorIndex;
    }
    colorIndex++;
  }
  
   
   /*int colorIndex = 1;
   for (int e = 0; e < Groups.size(); e++)
  {
    for (int i = 0; i < Groups.size(); i++)
    {
      if (i != e && (Groups.get(e).getDiameter() + Groups.get(i).getDiameter()) >= math.cartDist(Groups.get(e).position, Groups.get(i).position))
      {
        if(Groups.get(i).wasSet && !Groups.get(e).wasSet)
        {
          Groups.get(e).groupColorIndex = Groups.get(i).groupColorIndex;
          Groups.get(e).wasSet = true;
        }
        else if(Groups.get(e).groupColorIndex != 0)
        {
            Groups.get(i).groupColorIndex = Groups.get(e).groupColorIndex;
            Groups.get(i).wasSet = true;
        }
        else
        {
            Groups.get(e).groupColorIndex = colorIndex;
            Groups.get(e).wasSet = true;

            Groups.get(i).groupColorIndex = colorIndex;
            Groups.get(i).wasSet = true;
     
          colorIndex++;
        }
      }
    }
  } */
}

boolean ArrayListContains(ArrayList<Integer> a, IntegerSet i)
{
  for(IntegerSet s : a)
  {
    if(s.equals(i))
    {
      return true;
    }
  }
  return false;
}

IntegerSet checkCollision(int group)
{
  IntegerSet indicies = new IntegerSet();
  
   for (int i = 0; i < Groups.size(); i++)
    {
      if (i != group && (Groups.get(group).getDiameter() + Groups.get(i).getDiameter()) >= math.cartDist(Groups.get(group).position, Groups.get(i).position))
      {
        indicies.add(i);
      }
    }
    
    return indicies;
}

IntegerSet buildCollisionChain(int group)
{
  IntegerSet groups = checkCollision(group);
  boolean found = true;

  while(found)
  {
    found = false;
    int groupSize = groups.size();

    for(Integer g: groups.data)
    {
      IntegerSet temp = checkCollision(g);
      for(Integer i : temp.data)
      {
        groups.add(i);
      }
    }
    
    if(groups.size() > groupSize)
    {

      found = true;
    }
    else
    {

      groups.add(group);
    }
  }
  
  return groups;
}



