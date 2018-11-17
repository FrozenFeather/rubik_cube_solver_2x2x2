// Main Program
// Define User Interfaces
//
// Guide
// '0':   random shuffle the cube
// SPACE: try to solve the cube

int DEPTH_12_WITH_RANDOM_5_MOVES = 0;  // Explore one more depth need more time (~13s)
int DEPTH_11_WITH_RANDOM_2_MOVES = 1;  // Allow quick restart may fall from optimal (~2s)
// Define the solving mode
int SOLVING_MODE = DEPTH_12_WITH_RANDOM_5_MOVES;

// The cube to be dealt with
Cube cube;

void setup(){
    size(400,400);
    
    colorMode(RGB,1);
    background(1);
    
    // A Perfect Setting of the Solved Block
    Block blocks[] = {
      new Block((byte)0, new byte[]{Block.WHITE,  Block.ORANGE, Block.GREEN},  (byte)0),
      new Block((byte)1, new byte[]{Block.WHITE,  Block.GREEN,  Block.RED},    (byte)0),
      new Block((byte)2, new byte[]{Block.WHITE,  Block.BLUE,   Block.ORANGE}, (byte)0),
      new Block((byte)3, new byte[]{Block.WHITE,  Block.RED,    Block.BLUE},   (byte)0),
      new Block((byte)4, new byte[]{Block.YELLOW, Block.GREEN,  Block.ORANGE}, (byte)0),
      new Block((byte)5, new byte[]{Block.YELLOW, Block.RED,    Block.GREEN},  (byte)0),
      new Block((byte)6, new byte[]{Block.YELLOW, Block.ORANGE, Block.BLUE},   (byte)0),
      new Block((byte)7, new byte[]{Block.YELLOW, Block.BLUE,   Block.RED},    (byte)0)
    };
    
    if(SOLVING_MODE == DEPTH_12_WITH_RANDOM_5_MOVES){
      maxDepth = 11;
    }else{
      maxDepth = 10;
    }
    
    cube = new Cube(blocks);
    cube.paint();
}

void draw(){
}

void keyPressed(){
  switch(key){
    case 't':
      cube.turn(Cube.U,(byte)1);
      break;
    case 'y':
      cube.turn(Cube.U,(byte)-1);
      break;
    case 'v':
      cube.turn(Cube.D,(byte)1);
      break;
    case 'b':
      cube.turn(Cube.D,(byte)-1);
      break;
    case 'q':
      cube.turn(Cube.F,(byte)1);
      break;
    case 'z':
      cube.turn(Cube.F,(byte)-1);
      break;
    case 'w':
      cube.turn(Cube.B,(byte)1);
      break;
    case 'x':
      cube.turn(Cube.B,(byte)-1);
      break;
    case 'o':
      cube.turn(Cube.L,(byte)-1);
      break;
    case 'm':
      cube.turn(Cube.L,(byte)1);
      break;
    case 'p':
      cube.turn(Cube.R,(byte)-1);
      break;
    case ',':
      cube.turn(Cube.R,(byte)1);
      break;
    case '0':
      randomMove(200);
      break;
    case '1':
      randomMove(3);
      break;
    case ' ':
      long time = millis();
      int noOfSteps = 0;
      while(solveByIDAStar(cube) != FOUND){
        int noOfRandomMove = 2;
        if(SOLVING_MODE == DEPTH_12_WITH_RANDOM_5_MOVES){
          noOfRandomMove = 5;
        }
        for(int i=0; i<noOfRandomMove; i++){
          int m = (int)random(6);
          int d = (int)random(2);
          d = d * 2 - 1;
          cube.turn((byte)m,(byte)d);
          printMove(m,d);
          noOfSteps ++;
        }
      //println("time ellapsed: " + (millis()-time));
      }
      for(int i = 0; i < maxDepth + 1; i++){
        if(path[i][1] == 0) break;
        printMove(path[i][0], path[i][1]);
        noOfSteps++;
      }
      println();
      println(noOfSteps + " steps");
      println("time ellapsed: " + (millis()-time));
      println();
      //cube.config = originalConfig;
  }
  //println("heuristic: " + h(cube.config));
  cube.paint();
}

void randomMove(int k){
  for(int i=0; i<k; i++){
    int m = (int)random(6);
    int d = (int)random(2);
    d = d * 2 - 1;
    cube.turn((byte)m,(byte)d);
  }
}

void printMove(int orientation, int direction){
  switch(orientation){
    case Cube.U:
      print("U");
      break;
    case Cube.D:
      print("D");
      break;
    case Cube.L:
      print("L");
      break;
    case Cube.R:
      print("R");
      break;
    case Cube.F:
      print("F");
      break;
    case Cube.B:
      print("B");
      break;
  }
  switch(direction){
    case 1:
      print("a");
      break;
    case -1:
      print("c");
  }
  print(" ");
}