// Class definition of a single block
class Block {
  public static final byte WHITE = 0, ORANGE = 1, GREEN = 2;
  public static final byte RED = 3, BLUE = 4, YELLOW = 5;
  
  private byte index;
  private byte[] colour;
  public byte direction;
  
  public Block(byte i, byte[] colour, byte direction){
    this.index = i;
    this.colour = colour;
    this.direction = direction;
  }
  
  byte getIndex(){
    return this.index;
  }
  byte getColour(byte face){
    return colour[face];
  }
  byte getDirection(byte direction){
    return direction;
  }
}