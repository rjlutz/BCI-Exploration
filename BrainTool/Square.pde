public class Square {

  int x;
  int y;
  int red;
  int green;
  int blue;
  int _width = 50;
  int _height = 50;
  
  public Square(int x, int y, int red, int green, int blue) {
    this.x = x;
    this.y = y;
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  
  public Square(int x, int y) {
    this.x = x;
    this.y = y;
    this.red = 0;
    this.green = 0;
    this.blue = 0;
  }
  
  public void setColor(int red, int green, int blue) {
      this.red = red;
      this.green = green;
      this.blue = blue;
  }
  
  public int getRed() {
    return red;
  }
  
  public int getBlue() {
    return blue;
  }
  
  public int getGreen() {
    return green;
  }
  
  public void setX(int x) {
      this.x = x;
  }
  
  public void setY(int y) {
      this.y = y;
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  public int getHeight() {
     return _height;
  }
  
  public int getWidth() {
      return _width;
  }
  
  public void setFill() {
      fill(red,green,blue);
  }
  
  public void drawSquare() {
      fill(red,green,blue);
      rect(x,y, _width,_height);
  }
  
}