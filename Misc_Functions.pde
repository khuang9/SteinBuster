void removeOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0)//bools
    return;
    
  optionsPossible[row][col][i] = 0;  // bools
  __[row][col] -= 1; // num possible positions
  
  if (__[row][col] <= 0)//num possible positions
    invalid = true;
}

void setOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0) {
    invalid = true;
    return;
  }
    
  optionsPossible[row][col] = new int[n];  //bools, set to new array of zeroes with same length as before (however many options there are)
  //optionsPossible[row][col][i] = 1;  //bools
  __[row][col] = 1;  //num possible positions
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
