void removeOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0)//bools
    return;
    
  optionsPossible[row][col][i] = 0;  // bools
  gridNumPossibilities[row][col] -= 1; // num possible options
  
  if (gridNumPossibilities[row][col] <= 0)//num possible options
    invalid = true;
}

void setOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0) {
    invalid = true;
    return;
  }
    
  optionsPossible[row][col] = new int[n];  //bools, set to new array of zeroes with same length as before (however many options there are)
  //optionsPossible[row][col][i] = 1;  //bools//don't need i think
  gridNumPossibilities[row][col] = 1;  //num possible options
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
