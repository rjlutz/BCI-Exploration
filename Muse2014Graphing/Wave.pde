import java.util.LinkedList;

public class Wave extends LinkedList<Float> {
  
  private String name;  // alpha, beta etc 
  private int colr;     // note that 'color' is a reserved word in processing
  
  private int historyLength;
  private int movingAverageSize;
  private float movingAverageTotal;  // total of the last movingAverageSize observations
  
  public Wave(String _name, int _color) {
    name = _name;
    colr = _color;
    super.add(0f);  // plumb list with a couple values to use until there is data
    super.add(0f);
    historyLength = 100; // needs to be bigger than movingAverageSize!
    movingAverageSize = 50;
  }
  
  
  public int getColor() {
    return colr;  
  }
  
   public String getName() {
    return name;  
  }
  
  public boolean add(Float f) {
    
    int retire = 0;
    if (size() <= 1 || Float.isNaN(f)) {
      movingAverageTotal = 0.0f;
    } else {
      if  (movingAverageSize < size()) {
        // substitute the earliest value in the running total with the newest one
        // if overall size = 105 and moving avg size = 10 
        // we would remove item 95 (size() - movingAverageSize)
        // 0 .. 90 91 92 93 94 | 95 96 97 98 99 100 101 102 103 104
        //                        1  2  3  4  5   6   7   8   9  10                     
        //                       xx
        retire  = size()- movingAverageSize;
      } else { // size() < movingAverageSize) 
        // size = 8, moving average size = 10
        //
        // 0  1  2  3  4  5  6  7 list
        // 3  4  5  6  7  8  9 10 indexes of the last 10 items
        //xx
        retire = 0;
      }
      movingAverageTotal = movingAverageTotal - get(retire) + f;
    }
    if (size() >= historyLength) removeFirst();
    super.addLast(f);
    return true;
  }
  
  public float getMovingAverage() {
    float ma;
    if (size() > movingAverageSize) {
      ma = movingAverageTotal/Math.min(movingAverageSize, size());
    } else {
      ma = 0.00f;
    }
    return ma;
  }
  
}

