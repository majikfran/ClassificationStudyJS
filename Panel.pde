public class Panel
{
  public ArrayList<VizSample> VizSamples;
  PVector position;
  public PVector dimensions;
  String align;
  int columns;
  float padding = 30;
  String panelName = "";
  
  public ArrayList<VizSample> getVizSamples()
  {
    return VizSamples;
  }
  
  Panel(String alignment, int noColumns)
  {
    panelName = name;
    VizSamples = new ArrayList<VizSample>();
    align = alignment;
    position = new PVector();
    dimensions = new PVector();
    columns = noColumns;
    calcPositionAndSize();
  }
  
  public void setPanelName(string name)
  {
    panelName = name;
  }
  
  public float getWidth()
  {
    return dimensions.x;
  }
  
  public float getHeight()
  {
    return dimensions.y;
  }
  
  void addSample(VizSample sample)
  {
    VizSamples.add(sample);
  }
  
  void updateContent()
  {
    if(VizSamples.size() > 15)
    {
      columns = 4;
      calcPositionAndSize();
    }
    else if(VizSamples.size() > 10)
    {
      columns = 3;
      calcPositionAndSize();
    }
    else if(VizSamples.size() > 5)
    {
      columns = 2;
      calcPositionAndSize();
    }
    else if(VizSamples.size() > 0)
    {
      columns = 1;
      calcPositionAndSize();
    }
    else
    {
      columns = 0;
      calcPositionAndSize();
    }
    
    
    int i = 0;
    int row = -1;
    int column = 0;
    for (VizSample v: VizSamples)
    {
      if(i % columns == 0)
      {
         column = 0;
         row ++;
      }
      else
      {
          column++;
      }
      float xCor = position.x + (column * Settings.SAMPLE_DIAMETER) + (Settings.SAMPLE_DIAMETER/2) + (padding * (column + 1));
      float yCor = position.y + row * (Settings.SAMPLE_DIAMETER + 10) + (Settings.SAMPLE_DIAMETER/2) + (padding / (VizSamples.size() / (columns))) + 10;
      v.updatePositionAndSize(new PVector(xCor, yCor), Settings.SAMPLE_DIAMETER * .75);
      
      i++;
    }
    
  }
  
  void draw()
  {
    noStroke();
    fill(Colors.MIDGREY);
    rect(position.x, position.y, dimensions.x, dimensions.y);
    
    if(columns > 1)
    {
    textAlign(CENTER);
    textSize(72);
    fill(Colors.DARKGREY);
    text(panelName, position.x + (dimensions.x / 2), dimensions.y/2);
    
    textSize(12);
    }
    
    for(VizSample v : VizSamples)
      v.draw();
    
    updateContent();
    
  }
  
  boolean contains(PVector p)
  {
    if(p.x > position.x
    && p.x < position.x + dimensions.x
    && p.y > position.y
    && p.y < position.y + dimensions.y)
      return true;
      
    return false;
  }
  
  void calcPositionAndSize()
  {
      if (align == "LEFT"){
        dimensions.x = Settings.SAMPLE_DIAMETER * columns + (padding * (columns + 1));
        dimensions.y = height;
        position.x = width - dimensions.x;
        position.y = 0; 
      }
      else if(align == "RIGHT"){
      
      }
      else if(align == "BOTTOM"){
      
      }
      else if(align == "TOP"){
      
      }
    
  }
 
}

