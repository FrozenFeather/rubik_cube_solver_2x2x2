// Definition of the cube
// including turning the cube
// and the settings of the cube

byte[][][][] face_map = {
    {{{2,0},{3,0}},
     {{0,0},{1,0}}
    },
    {{{0,1},{2,2}},
     {{4,2},{6,1}}
    },
    {{{0,2},{1,1}},
     {{4,1},{5,2}}
    },
    {{{1,2},{3,1}},
     {{5,1},{7,2}}
    },
    {{{2,1},{3,2}},
     {{6,2},{7,1}}
    },
    {{{6,0},{7,0}},
     {{4,0},{5,0}}
    }
};

class Cube{
  public static final byte U = 0, L = 1, F = 2, R = 3, B = 4, D = 5;
  public static final int CUBE_SIZE = 80;
  public static final int OFFSET = 160;
  
  private Block blocks[];
  public byte config[][];
  private byte faces[][][];
  
  public Cube(Block blocks[]){
    this.blocks = blocks;
    config = new byte[8][2];
    for(byte i = 0; i < 8; i++){
      config[i][0] = i;
      config[i][1] = 0;
    }
    this.faces = new byte[6][2][2];
  }
  
  public Block getBlock(byte i){
    Block b = blocks[config[i][0]];
    b.direction = config[i][1];
    return b;
  }
  public void setBlock(byte from, Block b){
    config[from][0] = b.index;
    config[from][1] = b.direction;
  }
  
  public void paintFaces(){
    for(byte face = 0; face < 6; face++){
      for(byte r = 0; r < 2; r++){
        for(byte c = 0; c < 2; c++){
          byte blockIndex = face_map[face][r][c][0];
          byte blockDirection = face_map[face][r][c][1];
          Block block = getBlock(blockIndex);
          byte final_direction = (byte)(blockDirection - config[blockIndex][1]);
          if(final_direction < 0){
            final_direction += 3;
          }else if(final_direction >= 3){
            final_direction -= 3;
          }
          faces[face][r][c] = block.colour[final_direction];
        }
      }
    }
  }
  
  void setColour(byte direction, int row, int col){
    color[] colours = {color(1,1,1),color(1,0.5,0),color(0,0.5,0),
                   color(1,0,0),color(0,0,1),color(1,1,0),
                   color(0,0,0)};
    fill(colours[faces[direction][row][col]]);
  }
  
  void paint(){
    background(1);
    paintFaces();
    
    for(byte i = 0; i < 2; i++){
      for(byte j = 0; j < 2; j++){
        setColour(U, 1-j, i);
        quad(width/2 + (i+j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-2) * CUBE_SIZE / 4,
             width/2 + (i+j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-1) * CUBE_SIZE / 4,
             width/2 + (i+j) * CUBE_SIZE * sin(PI/3) / 2,   height/2 + (i-j-2) * CUBE_SIZE / 4,
             width/2 + (i+j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-3) * CUBE_SIZE / 4);
             
        setColour(D, 1-j, i);
        quad(width/2 + (i+j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-2) * CUBE_SIZE / 4 + OFFSET / sin(PI/3),
             width/2 + (i+j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-1) * CUBE_SIZE / 4 + OFFSET / sin(PI/3),
             width/2 + (i+j) * CUBE_SIZE * sin(PI/3) / 2,   height/2 + (i-j-2) * CUBE_SIZE / 4 + OFFSET / sin(PI/3),
             width/2 + (i+j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (i-j-3) * CUBE_SIZE / 4 + OFFSET / sin(PI/3));
        
        setColour(F, i, j);
        quad(width/2 + (j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j - 2) * CUBE_SIZE / 4,
             width/2 + (j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j - 1) * CUBE_SIZE / 4,
             width/2 + (j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j + 1) * CUBE_SIZE / 4,
             width/2 + (j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j) * CUBE_SIZE / 4);
        
        setColour(B, i, j);
        quad(width/2 + (j-2) * CUBE_SIZE * sin(PI/3) / 2 + OFFSET, height/2 + (2*i + j - 2) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 + (j-1) * CUBE_SIZE * sin(PI/3) / 2 + OFFSET, height/2 + (2*i + j - 1) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 + (j-1) * CUBE_SIZE * sin(PI/3) / 2 + OFFSET, height/2 + (2*i + j + 1) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 + (j-2) * CUBE_SIZE * sin(PI/3) / 2 + OFFSET, height/2 + (2*i + j) * CUBE_SIZE / 4 - OFFSET/2);
        
        setColour(R, i, 1-j);
        quad(width/2 - (j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j - 2) * CUBE_SIZE / 4,
             width/2 - (j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j - 1) * CUBE_SIZE / 4,
             width/2 - (j-1) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j + 1) * CUBE_SIZE / 4,
             width/2 - (j-2) * CUBE_SIZE * sin(PI/3) / 2, height/2 + (2*i + j) * CUBE_SIZE / 4);
        
        setColour(L, i, 1-j);
        quad(width/2 - (j-2) * CUBE_SIZE * sin(PI/3) / 2 - OFFSET, height/2 + (2*i + j - 2) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 - (j-1) * CUBE_SIZE * sin(PI/3) / 2 - OFFSET, height/2 + (2*i + j - 1) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 - (j-1) * CUBE_SIZE * sin(PI/3) / 2 - OFFSET, height/2 + (2*i + j + 1) * CUBE_SIZE / 4 - OFFSET/2,
             width/2 - (j-2) * CUBE_SIZE * sin(PI/3) / 2 - OFFSET, height/2 + (2*i + j) * CUBE_SIZE / 4 - OFFSET /2);
        
      }
    }
  }
  
  void turn(byte direction, byte magnitude){
    switch(direction){
      case U:
        if(magnitude == 1){
          exchangeBlocks(new byte[]{0,1,3,2}, new byte[]{2,0,1,3});
        }else{
          exchangeBlocks(new byte[]{0,1,3,2}, new byte[]{1,3,2,0});
        }
        break;
      case D:
        if(magnitude == 1){
          exchangeBlocks(new byte[]{4,5,7,6}, new byte[]{6,4,5,7});
        }else{
          exchangeBlocks(new byte[]{4,5,7,6}, new byte[]{5,7,6,4});
        }
        break;
      case F:
        rotateBlocks(0,  1);
        rotateBlocks(1, -1);
        rotateBlocks(4, -1);
        rotateBlocks(5,  1);
        if(magnitude == 1){
          exchangeBlocks(new byte[]{0,1,5,4}, new byte[]{4,0,1,5});
        }else{
          exchangeBlocks(new byte[]{0,1,5,4}, new byte[]{1,5,4,0});
        }
        break;
      case B:
        rotateBlocks(3,  1);
        rotateBlocks(2, -1);
        rotateBlocks(7, -1);
        rotateBlocks(6,  1);
        if(magnitude == 1){
          exchangeBlocks(new byte[]{2,3,7,6}, new byte[]{6,2,3,7});
        }else{
          exchangeBlocks(new byte[]{2,3,7,6}, new byte[]{3,7,6,2});
        }
        break;
      case L:
        rotateBlocks(2,  1);
        rotateBlocks(0, -1);
        rotateBlocks(6, -1);
        rotateBlocks(4,  1);
        if(magnitude == 1){
          exchangeBlocks(new byte[]{0,2,6,4}, new byte[]{4,0,2,6});
        }else{
          exchangeBlocks(new byte[]{0,2,6,4}, new byte[]{2,6,4,0});
        }
        break;
      case R:
        rotateBlocks(1,  1);
        rotateBlocks(3, -1);
        rotateBlocks(5, -1);
        rotateBlocks(7,  1);
        if(magnitude == 1){
          exchangeBlocks(new byte[]{1,3,7,5}, new byte[]{5,1,3,7});
        }else{
          exchangeBlocks(new byte[]{1,3,7,5}, new byte[]{3,7,5,1});
        }
        break;
    }
  }
  
  private void exchangeBlocks(byte[] original, byte[] after){
    Block originalBlock[] = new Block[original.length];
    for(int i = 0; i < original.length; i++){
      originalBlock[i] = getBlock(original[i]);
    }
    for(int i = 0; i < original.length; i++){
      setBlock(after[i], originalBlock[i]);
    }
  }
  
  private void rotateBlocks(int blockIndex, int direction){
    byte bDirection = config[blockIndex][1];
    bDirection -= direction;
    if(bDirection < 0){
      bDirection += 3;
    }else if(bDirection >= 3){
      bDirection -= 3;
    }
    config[blockIndex][1] = bDirection;
  }
  
}
byte opposite(byte orientation){
  switch(orientation){
    case Cube.U: return Cube.D;
    case Cube.D: return Cube.U;
    case Cube.L: return Cube.R;
    case Cube.R: return Cube.L;
    case Cube.F: return Cube.B;
    case Cube.B: return Cube.F;
  }
  return -1;
}