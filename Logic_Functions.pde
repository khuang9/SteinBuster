void affirmative(int[] subjA, int[] subjB) {
  if (positionKnown(subjA)) {
    setOption(subjB[0], __[subjA[0]][subjA[1]], subjB[1]);//indices
    //todo: hide clue
  }
  else if (positionKnown(subjB)) {
    setOption(subjA[0], __[subjB[0]][subjB[1]], subjA[1]);//indices
    //todo: hide clue
  }
    
  else {
    int pairsFound = 0;
    int pairCol;
    
    for (int c = 0; c < num columns; c++) {
      if (__[subjA[0]][c][subjA[1]] == 1 && __[subjB[0]][c][subjB[1]] == 1) {//bools
        pairsFound += 1;
        pairCol = c;
      }
      else if (__[subjA[0]][c][subjA[1]] == 0)//bools
        removeOption(subjB[0], c, subjB[1]);
      else if (__[subjB[0]][c][subjB[1]] == 0)//bools
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
    removeOption(subjB[0], __[subjA[0]][subjA[1]], subjB[1]);//indices
    //todo: hide clue
  }
  else if (positionKnown(subjB)) {
    removeOption(subjA[0], __[subjB[0]][subjB[1]], subjA[1]);//indices
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
    removeOption(subj[0], 0, subj[1]);
    removeOption(subj[0], num columns - 1, subj[1]);
    //todo: hide clue
  }
  
  else {  // at either end
    if (__[subj[0]][0][subj[1]] == 0) {//bools
      setOption(subj[0], num columns - 1, subj[1]);
      //todo: hide clue
    }
    
    else if (__[subj[0]][num columns - 1][subj[1]] == 0) {//bools
      setOption(subj[0], 0, subj[1]);
      //todo: hide clue
    }
    
    else {
      for (int c = 1; c < num columns - 1; c++)
        removeOption(subj[0], c, subj[1]);
      
    }
  }
}

void nextTo(int[] subjA, int[] subjB, int type) {
  if (type == 0) {  // not next to
    
  }
  
  else {  // next to
    
  }
}

void leftOf(int[] subjA, int[] subjB, int type) {
  if (type == 0) {  // immediately left of
    
  }
  
  else {  // somewhere left of
    
  }
}

void rightOf(int[] subjA, int[] subjB, int type) {
  if (type == 0) {  // immediately right of
    
  }
  
  else {  // somewhere right of
    
  }
}
