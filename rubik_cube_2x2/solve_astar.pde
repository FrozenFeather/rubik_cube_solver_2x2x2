// Main Solve
// Usin IDA*(Iterative Deepening A*)
// To explore steps up to 10
// If no solution, add a few random move and then explore again
// Heuristic: Mainly ManhattanDistance of the blocks, add some special cases

int manhattanDistance(byte a, byte b){
  int diff = a ^ b;
  int d = ((diff & 4) >> 2) + ((diff & 2) >> 1) + (diff & 1);
  return d;
}

byte[] specialCase = {1,3,0,2,6,4,7,5};
int h(byte[][] cubeConfig){
  int h = 0;
  int totalD = 3, maxD = 0;
  int allp = 7, alln = 0;
  for(int i = 0; i < 8; i++){
    byte bIndex = cubeConfig[i][0];
    byte bDirection = cubeConfig[i][1];
    // Get the manhattanDistance
    int d = manhattanDistance((byte)i, bIndex);
    if(d == 0 && bDirection != 0)
      // If the block is in correct position but wrong orientation
      // At least 2 moves are needed
      d += 2;
    else if(d == 1){
      // If the block is next to its position
      // There are 3 orientations that must take 3 moves.
      if((i & 4) != (bIndex & 4)){
        if(bDirection == 0)
          d += 2;
      }else if(specialCase[bIndex] == i){
        if(bDirection == 1)
          d += 2;
      }else{
        if(bDirection == 2)
          d += 2;
      }
    }
    totalD += d;
    if(d > maxD){
      maxD = d;
      allp = i;
      alln = i;
    }else if(d == maxD){
      allp &= i;
      alln |= i;
    }
  }
  // Idea: Since 1 turn can only move 4 blocks
  // So at least total distance / 4 is needed (+3 in advance to simulate math.ceil
  // Introduce the maximum manhattan distance of 1 particular block
  // Use Max to find out which heuristic is better
  int avgD = totalD / 4;
  if(avgD > maxD)
    h = avgD;
  else{
    h = maxD;
    // If max manhattan distance is chosen
    // Then if all block with max dist are not on the same plane
    // Then at least 1 more move is needed as any move may move only one of them
    if(maxD > 0 && allp == 0 && alln == 7){
      h++;
    }
  }
  return h;
}

int maxDepth = 10;
byte FOUND = -1;
long time = 0;
final long maxTime = 20000;

byte path[][] = new byte[maxDepth+1][2];

// IDA* algorithm
// Follows the pseudocode in wikipedia
// Reference: https://en.wikipedia.org/wiki/Iterative_deepening_A*
int solveByIDAStar(Cube cubeGiven){
  cube = cubeGiven;
  path = new byte[maxDepth+1][2];
  byte[][] config = cube.config;
  int bound = h(config);
  time = millis();
  while(true){
    int t = search(config, 0, bound);
    if(t == FOUND)
      return FOUND;
    if(t > maxDepth){
      cube.config = config;
      return maxDepth;
    }
    bound = t;
  }
}

int search(byte[][] config, int g, int bound){
  int hValue = h(config);
  if(hValue == 0)
    return FOUND;
  int f = g + hValue;
  if(f > bound)
    return f;
  int minValue = 100;
  nextOrientation:
  for(int orientation = 0; orientation < 6; orientation++){
    for(int direction = -1; direction <= 1; direction += 2){
      int k = 1;
      byte anotherSide = opposite((byte)orientation);
      while(g - k >= 0 && anotherSide == path[g-k][0]){
        if(anotherSide > orientation)
          continue nextOrientation;
        k++;
      }
      if(g - k >= 0 && orientation == path[g-k][0]){
        if(direction != path[g-k][1])
          continue;
        if(direction == 1)
          continue;
        k++;
        while(g - k >= 0 && anotherSide == path[g-k][0])
          k++;
        if(g - k >= 0 && orientation == path[g-k][0])
          continue nextOrientation;
      }
      byte[][] temp_c = new byte[8][2];
      for(int i = 0; i < 8; i++){
        for(int j = 0; j < 2; j++){
          temp_c[i][j] = config[i][j];
        }
      }
      cube.config = temp_c;
      cube.turn((byte)orientation, (byte)direction);
      temp_c = cube.config;
      
      path[g][0] = (byte)orientation;
      path[g][1] = (byte)direction;
      
      int t = search(temp_c, g+1, bound);
      if(t == FOUND)
        return FOUND;
      if(t < minValue)
        minValue = t;
      
      path[g][0] = -2;
      path[g][1] = -2;
    }
  }
  return minValue;
}