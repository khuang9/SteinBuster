void affirmative(int[] subjA, int[] subjB) {
  if (positionKnown(subjA)) {
    setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);//indices
    //todo: hide clue
  }
  else if (positionKnown(subjB)) {
    setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);//indices
    //todo: hide clue
  }
    
  else {
    int pairsFound = 0;
    int pairCol = -1;  // Invalid index makes errors easier to catch
    
    for (int c = 0; c < n; c++) {  // Iterate through all columns
      if (optionsPossible[subjA[0]][c][subjA[1]] == 1 && optionsPossible[subjB[0]][c][subjB[1]] == 1) {//bools
        pairsFound += 1;
        pairCol = c;
      }
      else if (optionsPossible[subjA[0]][c][subjA[1]] == 0)//bools
        removeOption(subjB[0], c, subjB[1]);
      else if (optionsPossible[subjB[0]][c][subjB[1]] == 0)//bools
        removeOption(subjA[0], c, subjA[1]);
        
      
    }
    
    if (pairsFound == 1) {
      setOption(subjA[0], pairCol, subjA[1]);
      setOption(subjB[0], pairCol, subjB[1]);
      //todo: hide clue
    }
  }
}

void negative(int[] subjA, int[] subjB) {
  if (positionKnown(subjA) && positionKnown(subjB)) {
    invalid = true;
    return;
  }
  
  if (positionKnown(subjA)) {
    removeOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);//indices
    //todo: hide clue
  }
  else if (positionKnown(subjB)) {
    removeOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);//indices
    //todo: hide clue
  }
}

void atPosition(int[] subjA, int[] subjB, int type) {
  if (type == 0) // not at position
    removeOption(subjA[0], subjB[0], subjA[1]);
  
  
  else  // at position
    setOption(subjA[0], subjB[0], subjA[1]);//subjB[0] will be column index instead of what it usually is
  
  //todo: hide clue
}

void atEitherEnd(int[] subj, int type) {
  if (type == 0) {  // not at either end
    removeOption(subj[0], 0, subj[1]);  // Remove option from first grid in row
    removeOption(subj[0], n - 1, subj[1]);  // Remove option from last grid in row
    //todo: hide clue
  }
  
  else {  // at either end
    if (optionsPossible[subj[0]][0][subj[1]] == 0) {//bools
      setOption(subj[0], n - 1, subj[1]);
      //todo: hide clue
    }
    
    else if (optionsPossible[subj[0]][n - 1][subj[1]] == 0) {//bools
      setOption(subj[0], 0, subj[1]);
      //todo: hide clue
    }
    
    else {
      for (int c = 1; c < n - 1; c++)  // Iterate through all non-end columns
        removeOption(subj[0], c, subj[1]);
      
    }
  }
}

void nextTo(int[] subjA, int[] subjB, int type) {
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 1) {
      for (int c = 0; c < n; c++) {
        if (c == 0 && optionsPossible[subjB[0]][1][subjB[1]] == 0 ||
            c == n - 1 && optionsPossible[subjB[0]][c-1][subjB[1]] == 0
            )//bools
          removeOption(subjA[0], c, subjA[1]);
        //else if (c == num columns - 1 && __[subjB[0]][c-1][subjB[1]] == 0)//bools
        //  removeOption(subjA[0], c, subjB[0]);
        else if (0 < c && c < n - 1) {
          if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0 && optionsPossible[subjB[0]][c+1][subjB[1]] == 0)//bools
            removeOption(subjA[0], c, subjA[1]);
        }
        
        if (c == 0 && optionsPossible[subjA[0]][1][subjA[1]] == 0 ||
            c == n - 1 && optionsPossible[subjA[0]][c-1][subjA[1]] == 0
            )//bools
          removeOption(subjB[0], c, subjB[1]);
        //else if (c == num columns - 1 && __[subjB[0]][c-1][subjB[1]] == 0)//bools
        //  removeOption(subjA[0], c, subjB[0]);
        else if (0 < c && c < n - 1) {
          if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0 && optionsPossible[subjA[0]][c+1][subjA[1]] == 0)//bools
            removeOption(subjB[0], c, subjB[1]);
        }
      }
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (abs(subjectColumns[subjA[0]][subjA[1]] - subjectColumns[subjB[0]][subjB[1]]) != 1)//indices
      invalid = true;
    else
      todo hide clue;
    return;
  }
    
  int[] subjKnown;
  int[] subjUnknown;
  
  if (positionKnown(subjA)) {
    subjKnown = subjA;
    subjUnknown = subjB;
  } else {
    subjKnown = subjB;
    subjUnknown = subjA;
  }
  
  int col = subjectColumns[subjKnown[0]][subjKnown[1]];//indices
  if (type == 0) {  // not next to
    if (col == 0)
      removeOption(subjUnknown[0], 1, subjUnknown[1]);
    else if (col == n - 1)
      removeOption(subjUnknown[0], n - 2, subjUnknown[1]);
    else {
      removeOption(subjUnknown[0], col - 1, subjUnknown[1]);
      removeOption(subjUnknown[0], col + 1, subjUnknown[1]);
    }
      
  }
  
  else {  // next to
    int knownInd = subjectColumns[subjKnown[0]][subjKnown[1]];//indices
    if (knownInd == 0)//indices
      setOption(subjUnknown[0], 1, subjUnknown[1]);
    else if (knownInd == n - 1)//indices
      setOption(subjUnknown[0], n - 2, subjUnknown[1]);
    else {
      for (int c = 0; c < n; c++) {
        if (c < knownInd - 1 || knownInd + 1 < c)
          removeOption(subjUnknown[0], c, subjUnknown[1]);
      }
    }
  }
}

void leftOf(int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], n - 1, subjA[1]);
  removeOption(subjB[0], 0, subjB[1]);
  
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < n - 1; c++) {
        if (optionsPossible[subjB[0]][c+1][subjB[1]] == 0)//bools
          removeOption(subjA[0], c, subjA[1]);
      }
      
      for (int c = 1; c < n; c++) {
        if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0)//bools
          removeOption(subjB[0], c, subjB[1]);
      }
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (subjectColumns[subjA[0]][subjA[1]] >= subjectColumns[subjB[0]][subjB[1]])//indices
      invalid = true;
    else
      todo hide clue;
    return;
  }
  
  if (type == 0) {  // immediately left of
    if (positionKnown(subjA)) {
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] + 1, subjB[1]);//indices
      //hide clue
    }
    
    else {
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] - 1, subjA[1]);//indices
      //hide clue
    }
  }
  
  else {  // somewhere left of
    if (positionKnown(subjA)) {
      for (int c = 0; c < subjectColumns[subjA[0]][subjA[1]] + 1; c++)//indices
        removeOption(subjB[0], c, subjB[1]);
    }
    
    else {
      for (int c = subjectColumns[subjB[0]][subjB[1]]; c < n; c++)//indices
        removeOption(subjA[0], c, subjA[1]);
    }
  }
}
//todo: precalculate indices and other aspects of subjA and B and store in variables
void rightOf(int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], 0, subjA[1]);
  removeOption(subjB[0], n - 1, subjB[1]);
  
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < n - 1; c++) {
        if (optionsPossible[subjA[0]][c+1][subjA[1]] == 0)//bools
          removeOption(subjB[0], c, subjB[1]);
      }
      
      for (int c = 1; c < n; c++) {
        if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0)//bools
          removeOption(subjA[0], c, subjA[1]);
      }
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (subjectColumns[subjA[0]][subjA[1]] <= subjectColumns[subjB[0]][subjB[1]])//indices
      invalid = true;
    else
      todo hide clue
    return;
  }
  
  if (type == 0) {  // immediately right of
    if (positionKnown(subjA)) {
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] - 1, subjB[1]);//indices
      //hide clue
    }
    
    else if (positionKnown(subjB)) {
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] + 1, subjA[1]);//indices
      //hide clue
    }
  }
  
  else {  // somewhere right of
    if (positionKnown(subjA)) {
      for (int c = 0; c < subjectColumns[subjB[0]][subjB[1]] + 1; c++)//indices
        removeOption(subjA[0], c, subjA[1]);
    }
    
    else {
      for (int c = subjectColumns[subjA[0]][subjA[1]]; c < n; c++)//indices
        removeOption(subjB[0], c, subjB[1]);
    }
  }
}
