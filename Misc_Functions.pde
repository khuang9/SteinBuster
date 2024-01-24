void removeOption(int row, int col, int i) {
  //println(clue.clueType);
  if (optionsPossible[row][col][i] == 0)//bools
    return;
    
  cluesUsed = true;
  
  optionsPossible[row][col][i] = 0;  // bools
  gridNumPossibilities[row][col] -= 1; // num possible options by grid
  subjectNumPossibilities[row][i] -= 1;  // num possible options by subject
  
  if (gridNumPossibilities[row][col] <= 0 || subjectNumPossibilities[row][i] <= 0)//num possible options
    invalid = true;
}

void setOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0) {
    invalid = true;
    return;
  }
    
  optionsPossible[row][col] = new int[n];  //bools, set to new array of zeroes with same length as before (however many options there are)
  optionsPossible[row][col][i] = 1;  //bools
  gridNumPossibilities[row][col] = 1;  //num possible options by grid
  //subjectNumPossibilities[row][i] = 1;  //num possible options by subject//prob don't need (-1 done in remove)
  subjectColumns[row][i] = col;//indices (all unset options are -1)
  
  for (int c = 0; c < n; c++) {  // Iterate through all columns
    if (c != col)
      removeOption(row, c, i);
  }
  
  
}

boolean positionKnown(int[] subj) {
  if (subjectColumns[subj[0]][subj[1]] != -1)//indices
    return true;
  
  return false;
}

int arrayTotal(int[][] arr) {
  int sum = 0;
  
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[0].length; j++)
      sum += arr[i][j];
  }
  
  return sum;
}

void copyArray(int[][][] copyFrom, int[][][] copyTo) {
  for (int i = 0; i < copyFrom.length; i++) {
    for (int j = 0; j < copyFrom[0].length; j++) {
      for (int k = 0; k < copyFrom[0][0].length; k++) {
        copyTo[i][j][k] = copyFrom[i][j][k];
      }
    }
  }
}

void copyArray(int[][] copyFrom, int[][] copyTo) {
  for (int i = 0; i < copyFrom.length; i++) {
    for (int j = 0; j < copyFrom[0].length; j++) {
      copyTo[i][j] = copyFrom[i][j];
    }
  }
}

void copyArray(ArrayList<Clue> copyFrom, ArrayList<Clue> copyTo) {
  copyTo = new ArrayList<Clue>();
  
  for (int i = 0; i < copyFrom.size(); i++) {
    copyTo.add(copyFrom.get(i));
  }
}


int[] leastOptionsSquareIndices() {
  int minOptions = n + 1; //<>//
  int minRow = n;
  int minCol = n;
  
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < n; col++) {
      int numOptions = gridNumPossibilities[row][col];
      
      if (numOptions == 2)
        return new int[]{row, col};
        
      else if (numOptions < minOptions && numOptions > 2) {
        minOptions = numOptions;
        minRow = row;
        minCol = col;
      }
    }
  }
  
  return new int[]{minRow, minCol};
}

int indexInArray(int[] arr, int el) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == el)
      return i;
  }
  
  return -1;
}

void saveState() {
  copyArray(optionsPossible, prevOptionsPossible);
  copyArray(subjectColumns, prevSubjectColumns);
  copyArray(gridNumPossibilities, prevGridNumPossibilities);
  copyArray(subjectNumPossibilities, prevSubjectNumPossibilities);
  copyArray(clues, prevClues);
  prevNumCluesFinished = numCluesFinished;
}

void revertState() {
  copyArray(prevOptionsPossible, optionsPossible);
  copyArray(prevSubjectColumns, subjectColumns);
  copyArray(prevGridNumPossibilities, gridNumPossibilities);
  copyArray(prevSubjectNumPossibilities, subjectNumPossibilities);
  copyArray(prevClues, clues);
  numCluesFinished = prevNumCluesFinished;
}
