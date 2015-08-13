static class MathUtil
{
  float dif(float x, float y)
  {
    if (x >= y)
    {
      return x - y;
    }
    else 
    {
      return y - x;
    }
  }
  
  float cartDist(PVector a, PVector b)
  {
    float xDist = dif(a.x, b.x);
    float yDist = dif(a.y, b.y);
    
    return sqrt((xDist * xDist) + (yDist *yDist));
  }
  
  PVector midPoint(PVector a, PVector b)
  {
    return new PVector((a.x + b.x)/2,
    (a.y + b.y)/2);
  }
  
  float difSigned(float x, float y)
  {
      return x - y;
  }
}
