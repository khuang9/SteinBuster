boolean cluesUsed = false;
//int numCluesUsed = 0;

void affirmative(Clue cl, int[] subjA, int[] subjB) {
  if (positionKnown(subjA)) { //<>//
    setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);//indices
    cl.hide();
    // No numCluesUsed += 1 because already done in cl.hide()
  }
  else if (positionKnown(subjB)) { //<>//
    setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);//indices
    cl.hide();
  }
    
  else {
    int pairsFound = 0;
    int pairCol = -1;  // Invalid index makes errors easier to catch
    
    for (int c = 0; c < m; c++) {  // Iterate through all columns
      if (optionsPossible[subjA[0]][c][subjA[1]] == 1 && optionsPossible[subjB[0]][c][subjB[1]] == 1) {//bools
        pairsFound += 1;
        pairCol = c;
      }
      else if (optionsPossible[subjA[0]][c][subjA[1]] == 0) {//bools
        removeOption(subjB[0], c, subjB[1]);
        //cluesUsed = true;
      }
      else if (optionsPossible[subjB[0]][c][subjB[1]] == 0) {//bools
        removeOption(subjA[0], c, subjA[1]);
        //cluesUsed = true;
      }
        
      
    }
    
    if (pairsFound == 1) {
      setOption(subjA[0], pairCol, subjA[1]);
      setOption(subjB[0], pairCol, subjB[1]);
      cl.hide();
    }
    //else if (cluesUsed) {
    //  //numCluesUsed += 1;
    //  clueUsed = false;
    //}
  }
}

void negative(Clue cl, int[] subjA, int[] subjB) {
  if (positionKnown(subjA) && positionKnown(subjB)) {
    invalid = true; //<>//
    return;
  }
  
  if (positionKnown(subjA)) {
    removeOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);//indices
    cl.hide();
  }
  else if (positionKnown(subjB)) {
    removeOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);//indices
    cl.hide();
  }
}

void atPosition(Clue cl, int[] subjA, int[] subjB, int type) {
  if (type == 0) // not at position //<>//
    removeOption(subjA[0], subjB[0], subjA[1]);
  
  
  else  // at position
    setOption(subjA[0], subjB[0], subjA[1]);//subjB[0] will be column index instead of what it usually is
  
  cl.hide();
}

void atEitherEnd(Clue cl, int[] subj, int type) {
  if (type == 0) {  // not at either end //<>//
    removeOption(subj[0], 0, subj[1]);  // Remove option from first grid in row
    removeOption(subj[0], m - 1, subj[1]);  // Remove option from last grid in row
    cl.hide();
  }
  
  else {  // at either end
    if (optionsPossible[subj[0]][0][subj[1]] == 0) {//bools
      setOption(subj[0], m - 1, subj[1]);
      cl.hide();
    }
    
    else if (optionsPossible[subj[0]][m - 1][subj[1]] == 0) {//bools
      setOption(subj[0], 0, subj[1]);
      cl.hide();
    }
    
    else {
      for (int c = 1; c < m - 1; c++)  // Iterate through all non-end columns
        removeOption(subj[0], c, subj[1]);
      
      //numCluesUsed += 1;
      
    }
  }
}

void nextTo(Clue cl, int[] subjA, int[] subjB, int type) {
  if (!positionKnown(subjA) && !positionKnown(subjB)) { //<>//
    if (type == 1) {
      for (int c = 0; c < m; c++) {
        if (c == 0 && optionsPossible[subjB[0]][1][subjB[1]] == 0 ||
            c == m - 1 && optionsPossible[subjB[0]][c-1][subjB[1]] == 0) {//bools
          removeOption(subjA[0], c, subjA[1]);
          //clueUsed = true;
        }
        //else if (c == num columns - 1 && __[subjB[0]][c-1][subjB[1]] == 0)//bools
        //  removeOption(subjA[0], c, subjB[0]);
        else if (0 < c && c < m - 1) {
          if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0 && optionsPossible[subjB[0]][c+1][subjB[1]] == 0) {//bools
            removeOption(subjA[0], c, subjA[1]);
            //clueUsed = true;
          }
        }
        
        if (c == 0 && optionsPossible[subjA[0]][1][subjA[1]] == 0 ||
            c == m - 1 && optionsPossible[subjA[0]][c-1][subjA[1]] == 0) {//bools
          removeOption(subjB[0], c, subjB[1]);
          //clueUsed = true;
        }
        //else if (c == num columns - 1 && __[subjB[0]][c-1][subjB[1]] == 0)//bools
        //  removeOption(subjA[0], c, subjB[0]);
        else if (0 < c && c < m - 1) {
          if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0 && optionsPossible[subjA[0]][c+1][subjA[1]] == 0) {//bools
            removeOption(subjB[0], c, subjB[1]);
            //cluesUsed = true;
          }
        }
      }
      
      //if (clueUsed) {
      //  //numCluesUsed += 1;
      //  clueUsed = false;
      //}
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (abs(subjectColumns[subjA[0]][subjA[1]] - subjectColumns[subjB[0]][subjB[1]]) != 1)//indices
      invalid = true;
    else
      cl.hide();
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
  
  int knownCol = subjectColumns[subjKnown[0]][subjKnown[1]];//indices
  if (type == 0) {  // not next to
    if (knownCol == 0)
      removeOption(subjUnknown[0], 1, subjUnknown[1]);
    else if (knownCol == m - 1)
      removeOption(subjUnknown[0], m - 2, subjUnknown[1]);
    else {
      removeOption(subjUnknown[0], knownCol - 1, subjUnknown[1]);
      removeOption(subjUnknown[0], knownCol + 1, subjUnknown[1]);
    }
    
    cl.hide();
      
  }
  
  else {  // next to
    //int knownInd = subjectColumns[subjKnown[0]][subjKnown[1]];//indices
    if (knownCol == 0) {//indices
      setOption(subjUnknown[0], 1, subjUnknown[1]);
      cl.hide();
    }
    else if (knownCol == m - 1) {//indices
      setOption(subjUnknown[0], m - 2, subjUnknown[1]);
      cl.hide();
    }
    else {
      if (optionsPossible[subjUnknown[0]][knownCol - 1][subjUnknown[1]] == 0) {
        setOption(subjUnknown[0], knownCol + 1, subjUnknown[1]);
        cl.hide();
      }
      else if (optionsPossible[subjUnknown[0]][knownCol + 1][subjUnknown[1]] == 0) {
        setOption(subjUnknown[0], knownCol - 1, subjUnknown[1]);
        cl.hide();
      }
      else {
        for (int c = 0; c < m; c++) {
          if (c < knownCol - 1 || knownCol + 1 < c)
            removeOption(subjUnknown[0], c, subjUnknown[1]);
        }
        
        //numCluesUsed += 1;
      }
    }
  }
}

void leftOf(Clue cl, int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], m - 1, subjA[1]); //<>//
  removeOption(subjB[0], 0, subjB[1]);
  
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < m - 1; c++) {
        if (optionsPossible[subjB[0]][c+1][subjB[1]] == 0) {//bools
          removeOption(subjA[0], c, subjA[1]);
          //clueUsed = true;
        }
      }
      
      for (int c = 1; c < m; c++) {
        if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0) {//bools
          removeOption(subjB[0], c, subjB[1]);
          //clueUsed = true;
        }
      }
      
      //if (clueUsed) {
      //  //numCluesUsed += 1;
      //  clueUsed = false;
      //}
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (subjectColumns[subjA[0]][subjA[1]] >= subjectColumns[subjB[0]][subjB[1]])//indices
      invalid = true;
    else
      cl.hide();
    return;
  }
  
  if (type == 0) {  // immediately left of
    if (positionKnown(subjA))
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] + 1, subjB[1]);//indices
    else
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] - 1, subjA[1]);//indices
    
    cl.hide();
  }
  
  else {  // somewhere left of
    if (positionKnown(subjA)) {
      for (int c = 0; c < subjectColumns[subjA[0]][subjA[1]] + 1; c++)//indices
        removeOption(subjB[0], c, subjB[1]);
    }
    
    else {
      for (int c = subjectColumns[subjB[0]][subjB[1]]; c < m; c++)//indices
        removeOption(subjA[0], c, subjA[1]);
    }
    
    //numCluesUsed += 1;
  }
}
//todo: precalculate indices and other aspects of subjA and B and store in variables
void rightOf(Clue cl, int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], 0, subjA[1]);
  removeOption(subjB[0], m - 1, subjB[1]);
  
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < m - 1; c++) {
        if (optionsPossible[subjA[0]][c+1][subjA[1]] == 0) {//bools
          removeOption(subjB[0], c, subjB[1]);
          //clueUsed = true;
        }
      }
      
      for (int c = 1; c < m; c++) {
        if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0) {//bools
          removeOption(subjA[0], c, subjA[1]);
          //clueUsed = true;
        }
      }
      
      //if (clueUsed) {
      //  //numCluesUsed += 1;
      //  clueUsed = false;
      //}
    }
    
    return;
  }
  
  else if (positionKnown(subjA) && positionKnown(subjB)) {
    if (subjectColumns[subjA[0]][subjA[1]] <= subjectColumns[subjB[0]][subjB[1]])//indices
      invalid = true;
    else
      cl.hide();
    return;
  }
  
  if (type == 0) {  // immediately right of
    if (positionKnown(subjA))
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] - 1, subjB[1]);//indices
    else if (positionKnown(subjB))
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] + 1, subjA[1]);//indices
    
    cl.hide();
  }
  
  else {  // somewhere right of
    if (positionKnown(subjA)) {
      for (int c = subjectColumns[subjA[0]][subjA[1]]; c < m; c++)//indices
        removeOption(subjB[0], c, subjB[1]);
    }
    
    else {
      for (int c = 0; c < subjectColumns[subjB[0]][subjB[1]] + 1; c++)//indices
        removeOption(subjA[0], c, subjA[1]);
    }
    
    //numCluesUsed += 1;
  }
}


boolean stuck() {
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < m; col++) {
      if (gridNumPossibilities[row][col] == 1) {
        int subjIndex = indexInArray(optionsPossible[row][col], 1);
        
        if (subjectColumns[row][subjIndex] == -1) {
          subjectColumns[row][subjIndex] = col;
          return false;
        }
      }
        
        
    }
    
    for (int subjIndex = 0; subjIndex < n; subjIndex++) {
      if (subjectNumPossibilities[row][subjIndex] == 1 && subjectColumns[row][subjIndex] == -1) {
        for (int col = 0; col < n; col++) {
          if (optionsPossible[row][col][subjIndex] == 1) {
            setOption(row, col, subjIndex);
            return false;
          }
        }
      }
    }
  }
  
  return true;
}
