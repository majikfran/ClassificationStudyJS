public class IntegerSet
{
  public ArrayList<Integer> data = new ArrayList<Integer>();
  
  public void add(int value)
  {
    if(!data.contains(value))
    {
      data.add(value);
    }
  }
  
  public boolean equals(IntegerSet comparator)
  {    
    if(comparator.size() != data.size())
      return false;
      
      
      
    for(int i = 0; i < data.size(); i++)
    {
      boolean tempMatch = false;
      for(int e = 0; e < data.size(); e++)
      {
        if(comparator.data.get(i) == data.get(e))
        {
          tempMatch = true;
        }
      }
      if(!tempMatch)
        return false;
    }   

    return true;
  }
  
  public int size()
  {
    return data.size();
  }
}
