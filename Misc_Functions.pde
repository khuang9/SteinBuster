void removeOption(int row, int col, int i) {
  if (__[row][col][i] == 0)//bools
    return;
    
  __[row][col][i] = 0;  // bools
  __[row][col] -= 1; // num possible positions
  
  if (__[row][col] <= 0)//num possible positions
    invalid = true;
}

void setOption(int row, int col, int i) {
  if (__[row][col][i] == 0) {
    invalid = true;
    return;
  }
    
  __[row][col] = new int[however many options];  //bools
  __[row][col][i] = 1;  //bools
  __[row][col] = 1;  //num possible positions
  __[row][i] = col;//indices (all unset options are -1)
  
  for (int c = 0; c < num columns; c++) {
    if (c != col)
      removeOption(row, c, i);
  }
  
  
}

boolean positionKnown(int[] subj) {
  if (__[subj[0]][subj[1]] != -1)//indices
    return true;
  
  return false;
}
