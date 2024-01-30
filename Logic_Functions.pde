void affirmative(Clue cl, int[] subjA, int[] subjB) {  // Clue is fully used up if positions of both subjects are determined
  // subj[0] is the row (category) the subject belongs to
  // subj[1] is the subject's assigned index based on order the user enters the subjects
  
  // If one subject's position is known, set the other's column to be the same
  if (positionKnown(subjA)) {
    setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);
    cl.hide();
  }
  else if (positionKnown(subjB)) {
    setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);
    cl.hide();
  }
    
  // When both positions unknown:
  // If any given column, any one of the subjects is not an option, then the other can't be an option either
  // If there is only a single 'pair' column (column where both are valid options) that column must be where both subjects should be situated
  else {
    int pairsFound = 0;
    int pairCol = -1;  // Invalid index makes errors easier to catch
    
    for (int c = 0; c < m; c++) {  // Iterate through all columns
      if (optionsPossible[subjA[0]][c][subjA[1]] == 1 && optionsPossible[subjB[0]][c][subjB[1]] == 1) {
        pairsFound += 1;
        pairCol = c;
      }
      else if (optionsPossible[subjA[0]][c][subjA[1]] == 0) {
        removeOption(subjB[0], c, subjB[1]);
      }
      else if (optionsPossible[subjB[0]][c][subjB[1]] == 0) {
        removeOption(subjA[0], c, subjA[1]);
      }
        
      
    }
    
    if (pairsFound == 1) {
      setOption(subjA[0], pairCol, subjA[1]);
      setOption(subjB[0], pairCol, subjB[1]);
      cl.hide();
    }
  }
}

void negative(Clue cl, int[] subjA, int[] subjB) {
  // subj[0] is the row (category) the subject belongs to
  // subj[1] is the subject's assigned index based on order the user enters the subjects
  
  // If subjects' detemined positions are in the same column, current solution is invalid
  if (positionKnown(subjA) && positionKnown(subjB) && subjectColumns[subjA[0]][subjA[1]] == subjectColumns[subjB[0]][subjB[1]]) {
    invalid = true;
    return;
  }
  
  // If one known, remove the other as an option in the same column
  if (positionKnown(subjA))
    removeOption(subjB[0], subjectColumns[subjA[0]][subjA[1]], subjB[1]);
  else if (positionKnown(subjB))
    removeOption(subjA[0], subjectColumns[subjB[0]][subjB[1]], subjA[1]);
  
  cl.hide();  // Clue is fully used no matter what if either subject's position is known
}

void atPosition(Clue cl, int[] subjA, int[] subjB, int type) {  //subjB[0] will be column index indicating position instead of what it usually is (row index based on category)
  // subj[0] is the row (category) the subject belongs to
  // subj[1] is the subject's assigned index based on order the user enters the subjects
  
  if (type == 0) // not at position
    removeOption(subjA[0], subjB[0], subjA[1]);
    
  else  // at position
    setOption(subjA[0], subjB[0], subjA[1]);
  
  cl.hide();  // Clue is fully used no matter what
}

void atEitherEnd(Clue cl, int[] subj, int type) {  // Clue fully used up if subject's position is determined for 'at' or no matter what for 'not at'
  if (type == 0) {  // not at either end
    removeOption(subj[0], 0, subj[1]);  // Remove option from first grid in row
    removeOption(subj[0], m - 1, subj[1]);  // Remove option from last grid in row
    cl.hide();
  }
  
  else {  // at either end
    // If subject cannot be at one end, it must be at the other
    if (optionsPossible[subj[0]][0][subj[1]] == 0) {
      setOption(subj[0], m - 1, subj[1]);
      cl.hide();
    }
    
    else if (optionsPossible[subj[0]][m - 1][subj[1]] == 0) {
      setOption(subj[0], 0, subj[1]);
      cl.hide();
    }
    
    else {
      for (int c = 1; c < m - 1; c++)  // Iterate through all non-end columns and remove subject as an option
        removeOption(subj[0], c, subj[1]);
      
    }
  }
}

void nextTo(Clue cl, int[] subjA, int[] subjB, int type) {  // Clue used up if both positions determined (next to) or no matter what if at least one's position is known already (not next to)
  // If both unknown, and clue is 'next to':
  // For end columns, if second/second last does not have one subject as an option, end columns cannot have the other as an option
  // For all other columns, if both surrounding columns do not have one subject as an option, the indicated column cannot have the other as an option either
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 1) {
      for (int c = 0; c < m; c++) {
        if (c == 0 && optionsPossible[subjB[0]][1][subjB[1]] == 0 ||
            c == m - 1 && optionsPossible[subjB[0]][c-1][subjB[1]] == 0) {
          removeOption(subjA[0], c, subjA[1]);
        }
        
        else if (0 < c && c < m - 1) {
          if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0 && optionsPossible[subjB[0]][c+1][subjB[1]] == 0) {
            removeOption(subjA[0], c, subjA[1]);
          }
        }
        
        if (c == 0 && optionsPossible[subjA[0]][1][subjA[1]] == 0 ||
            c == m - 1 && optionsPossible[subjA[0]][c-1][subjA[1]] == 0) {
          removeOption(subjB[0], c, subjB[1]);
        }
        
        else if (0 < c && c < m - 1) {
          if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0 && optionsPossible[subjA[0]][c+1][subjA[1]] == 0) {
            removeOption(subjB[0], c, subjB[1]);
          }
        }
      }
    }
    
    // No extra work needed for type == 0
    return;
  }
  
    
  // If one position(s) known
  int[] subjKnown;
  int[] subjUnknown;
  
  if (positionKnown(subjA)) {
    subjKnown = subjA;
    subjUnknown = subjB;
  } else {
    subjKnown = subjB;
    subjUnknown = subjA;
  }
  
  int knownCol = subjectColumns[subjKnown[0]][subjKnown[1]];
  
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
    // If one subject is at either end, the other subject has only one possibility
    if (knownCol == 0) {
      setOption(subjUnknown[0], 1, subjUnknown[1]);
      cl.hide();
    }
    else if (knownCol == m - 1) {
      setOption(subjUnknown[0], m - 2, subjUnknown[1]);
      cl.hide();
    }
    
    
    else {
      // If any one of the columns adjacent to known column does not have unknown subject as option, it can only be at the other side's column
      if (optionsPossible[subjUnknown[0]][knownCol - 1][subjUnknown[1]] == 0) {
        setOption(subjUnknown[0], knownCol + 1, subjUnknown[1]);
        cl.hide();
      }
      else if (optionsPossible[subjUnknown[0]][knownCol + 1][subjUnknown[1]] == 0) {
        setOption(subjUnknown[0], knownCol - 1, subjUnknown[1]);
        cl.hide();
      }
      else {
        // If both columns are valid, disregard all columns except for those two
        for (int c = 0; c < m; c++) {
          if (c < knownCol - 1 || knownCol + 1 < c)
            removeOption(subjUnknown[0], c, subjUnknown[1]);
        }
      }
    }
  }
}

void leftOf(Clue cl, int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], m - 1, subjA[1]);  // If A is left of something, it cannot be the rightmost subject
  removeOption(subjB[0], 0, subjB[1]);  // If B is right of something, it cannot be the leftmost subject
  
  // If both subject positions unknown and clue type is 'immediately left of':
  // Remove A as option for all columns where next column to right cannot contain B
  // Remove B as option for all columns where prev column to left cannot contain A
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < m - 1; c++) {
        if (optionsPossible[subjB[0]][c+1][subjB[1]] == 0) {
          removeOption(subjA[0], c, subjA[1]);
        }
      }
      
      for (int c = 1; c < m; c++) {
        if (optionsPossible[subjA[0]][c-1][subjA[1]] == 0) {
          removeOption(subjB[0], c, subjB[1]);
        }
      }
      
    }
    
    return;
  }
  
  // If position(s) known
  if (type == 0) {  // immediately left of
    if (positionKnown(subjA))
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] + 1, subjB[1]);
    else
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] - 1, subjA[1]);
    
    cl.hide();
  }
  
  // If clue is 'somewhere left of' and one position is known: remove B as option for all columns left of A or remove A as option for all columns right of B, depending on which position known
  else {  // somewhere left of
    if (positionKnown(subjA)) {
      for (int c = 0; c < subjectColumns[subjA[0]][subjA[1]] + 1; c++)
        removeOption(subjB[0], c, subjB[1]);
    }
    
    else {
      for (int c = subjectColumns[subjB[0]][subjB[1]]; c < m; c++)
        removeOption(subjA[0], c, subjA[1]);
    }
  }
}

//todo: precalculate indices and other aspects of subjA and B and store in variables
void rightOf(Clue cl, int[] subjA, int[] subjB, int type) {
  removeOption(subjA[0], 0, subjA[1]);  // If A is right of something, it cannot be the leftmost subject
  removeOption(subjB[0], m - 1, subjB[1]);  // If B is left of something, it cannot be the rightmost subject
  
  // If both subject positions unknown and clue type is 'immediately right of':
  // Remove A as option for all columns where prev column to left cannot contain B
  // Remove B as option for all columns where next column to right cannot contain A
  if (!positionKnown(subjA) && !positionKnown(subjB)) {
    if (type == 0) {
      for (int c = 0; c < m - 1; c++) {
        if (optionsPossible[subjA[0]][c+1][subjA[1]] == 0) {
          removeOption(subjB[0], c, subjB[1]);
        }
      }
      
      for (int c = 1; c < m; c++) {
        if (optionsPossible[subjB[0]][c-1][subjB[1]] == 0) {
          removeOption(subjA[0], c, subjA[1]);
        }
      }
    }
    
    return;
  }
  
  // If position(s) known
  if (type == 0) {  // immediately right of
    if (positionKnown(subjA))
      setOption(subjB[0], subjectColumns[subjA[0]][subjA[1]] - 1, subjB[1]);
    else if (positionKnown(subjB))
      setOption(subjA[0], subjectColumns[subjB[0]][subjB[1]] + 1, subjA[1]);
    
    cl.hide();
  }
  
  // If clue is 'somewhere right of' and one position is known: remove B as option for all columns right of A or remove A as option for all columns left of B, depending on which position known
  else {  // somewhere right of
    if (positionKnown(subjA)) {
      for (int c = subjectColumns[subjA[0]][subjA[1]]; c < m; c++)
        removeOption(subjB[0], c, subjB[1]);
    }
    
    else {
      for (int c = 0; c < subjectColumns[subjB[0]][subjB[1]] + 1; c++)
        removeOption(subjA[0], c, subjA[1]);
    }
  }
}


boolean stuck() {
  for (int row = 0; row < n; row++) {
    // Check if any cells have only one possible option
    for (int col = 0; col < m; col++) {
      if (cellNumPossibilities[row][col] == 1) {
        int subjIndex = indexInArray(optionsPossible[row][col], 1);
        
        if (subjectColumns[row][subjIndex] == -1) {
          subjectColumns[row][subjIndex] = col;
          return false;
        }
      }
    }
    
    // Check if any subjects have only one possible position
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
