// Remove a subject as an option for a column
void removeOption(int row, int col, int i) {
  // Return if already not an option
  if (optionsPossible[row][col][i] == 0)
    return;
    
  cluesUsed = true;  // Removing options counts as progress
  
  optionsPossible[row][col][i] = 0;
  cellNumPossibilities[row][col] -= 1;
  subjectNumPossibilities[row][i] -= 1;
  
    if (cellNumPossibilities[row][col] <= 0 || subjectNumPossibilities[row][i] <= 0)  // If number of options/possibilities for anything goes below 1, solution is invalid
    invalid = true;
}

// Set subject as occupant of indicated column
void setOption(int row, int col, int i) {
  // If the indicated column does not have the indicated subject as an option, solution is invalid
  if (optionsPossible[row][col][i] == 0) {
    invalid = true;
    return;
  }
    
  optionsPossible[row][col] = new int[m];  // Set to new array of zeroes with same length as before (however many options there are)
  optionsPossible[row][col][i] = 1;
  cellNumPossibilities[row][col] = 1;
  subjectColumns[row][i] = col;
  
  for (int c = 0; c < m; c++) {  // Iterate through all other columns and remove indicated subject from their options
    if (c != col)
      removeOption(row, c, i);
  }
  
  
}


// Checks if position of a subject has been determined already
boolean positionKnown(int[] subj) {
  if (subjectColumns[subj[0]][subj[1]] != -1)//indices
    return true;
  
  return false;
}

// Adds up all integers in a 2D array
int arrayTotal(int[][] arr) {
  int sum = 0;
  
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[0].length; j++)
      sum += arr[i][j];
  }
  
  return sum;
}


// Copies 3D int array
void copyArray(int[][][] copyFrom, int[][][] copyTo) {
  for (int i = 0; i < copyFrom.length; i++) {
    for (int j = 0; j < copyFrom[0].length; j++) {
      for (int k = 0; k < copyFrom[0][0].length; k++) {
        copyTo[i][j][k] = copyFrom[i][j][k];
      }
    }
  }
}

// Copies 2D int array
void copyArray(int[][] copyFrom, int[][] copyTo) {
  for (int i = 0; i < copyFrom.length; i++) {
    for (int j = 0; j < copyFrom[0].length; j++) {
      copyTo[i][j] = copyFrom[i][j];
    }
  }
}

// Copies Clue ArrayList
void copyArray(ArrayList<Clue> copyFrom, ArrayList<Clue> copyTo) {
  //copyTo = new ArrayList<Clue>();
  int copyFromSize = copyFrom.size();
  int copyToSize = copyTo.size();
  
  for (int i = 0; i < copyFromSize; i++) {
    if (i < copyToSize)
      copyTo.set(i, copyFrom.get(i).copyClue());
    else
      copyTo.add(copyFrom.get(i).copyClue());
  }
}


// Finds the indices of the cell with least possible options but still >= 2 options
int[] leastOptionsCellIndices() {
  int minOptions = m + 1;
  int minRow = n;
  int minCol = m;
  
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < m; col++) {
      int numOptions = cellNumPossibilities[row][col];
      
      // 2 is minimum, return if found
      if (numOptions == 2)
        return new int[]{row, col};
        
      else if (numOptions < minOptions && numOptions > 2) {  // This function is used to find best cell to start guessing so potions has to be >= 2 or no guessing can be done
        minOptions = numOptions;
        minRow = row;
        minCol = col;
      }
    }
  }
  
  return new int[]{minRow, minCol};
}


// Removes index values from string using ")" index
String realWord(String word) {
  int brackIndex = word.indexOf(")");
  
  if (brackIndex == -1)  // No bracket means no index values in string
    return word;
  else
    return word.substring(brackIndex + 2);
}

// Finds the correct index for a word in a sorted list and inserts word into list at that index (maintains sortedness)
String[] addString(String[] arr, int[] linkedArr, String word) {
  int wordIndex = indexInArray(arr, word);
  int arrSize = arr.length;
  
  if (wordIndex != -1) {  // Word already in array
    linkedArr[wordIndex] += 1;
    return arr;
  }
  
  // If array is empty, just append
  if (arrSize == 0) {
    linkedArr[arrSize] = 1;  // linkedArr.length is one more than arr.length because it was expanded by 1 beforehand
    return append(arr, word);
  }
  
  else {
    int addIndex = binarySearch(arr, realWord(word), 0, arrSize - 1);  // Find right index using binary search
    
    // Expand array
    arr = append(arr, arr[arrSize - 1]);
    linkedArr[arrSize] = linkedArr[arrSize-1];
    
    // Shift all values after addIndex over by 1
    for (int i = arrSize - 1; i > addIndex; i--) {
      arr[i] = arr[i-1];
      linkedArr[i] = linkedArr[i-1];
    }
      
    // Add word in at addIndex
    arr[addIndex] = word;
    linkedArr[addIndex] = 1;
    
    return arr;
  }
}

// Used to find the index of the determined option for each grid cell (the index would be marked by a 1 in an array of 0s in optionsPossible)
int indexInArray(int[] arr, int el) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == el)
      return i;
  }
  
  return -1;
}

// Uses binary search to find the index of a word in a sorted array (returns -1 if not found)
int indexInArray(String[] arr, String el) {
  if (arr.length == 0)
    return -1;
    
  el = realWord(el);
  
  int elIndex = binarySearch(arr, el, 0, arr.length - 1);
  
  if (arr[elIndex].equals(el))
    return elIndex;
  else
    return -1;
}


// Copies puzzle info into backup arrays
void saveState() {
  copyArray(optionsPossible, prevOptionsPossible);
  copyArray(subjectColumns, prevSubjectColumns);
  copyArray(cellNumPossibilities, prevCellNumPossibilities);
  copyArray(subjectNumPossibilities, prevSubjectNumPossibilities);
  copyArray(clues, prevClues);
  prevNumCluesFinished = numCluesFinished;
}

// Retrieves and restores prev puzzle info from backup arrays
void revertState() {
  copyArray(prevOptionsPossible, optionsPossible);
  copyArray(prevSubjectColumns, subjectColumns);
  copyArray(prevCellNumPossibilities, cellNumPossibilities);
  copyArray(prevSubjectNumPossibilities, subjectNumPossibilities);
  copyArray(prevClues, clues);
  numCluesFinished = prevNumCluesFinished;
}

// Reverts all puzzle info to initial state
void resetState() {
  copyArray(initOptionsPossible, optionsPossible);
  copyArray(initSubjectColumns, subjectColumns);
  copyArray(initCellNumPossibilities, cellNumPossibilities);
  copyArray(initSubjectNumPossibilities, subjectNumPossibilities);
  copyArray(initClues, clues);
  numCluesFinished = 0;
}


// Saves all new info about suggestions (new suggestions, updated suggestion selection frequencies), called every time solve button is pressed
void saveSuggestions() {
  PrintWriter categs = createWriter("SuggestionData/categories.txt");
  PrintWriter catFreq = createWriter("SuggestionData/categoryFrequency.txt");
  PrintWriter opts = createWriter("SuggestionData/options.txt");
  PrintWriter optFreq = createWriter("SuggestionData/optionFrequency.txt");
  
  categs.println(join(categSuggestions, ","));
  categs.flush();
  categs.close();
  
  catFreq.println(join(str(categFrequency), ","));
  catFreq.flush();
  catFreq.close();
  
  opts.println(join(optSuggestions, ","));
  opts.flush();
  opts.close();
  
  optFreq.println(join(str(optFrequency), ","));
  optFreq.flush();
  optFreq.close();
}
