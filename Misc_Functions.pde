void removeOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0)//bools //<>// //<>//
    return;
    
  cluesUsed = true;
  
  optionsPossible[row][col][i] = 0;  // bools
  gridNumPossibilities[row][col] -= 1; // num possible options by grid
  subjectNumPossibilities[row][i] -= 1;  // num possible options by subject
  
  if (gridNumPossibilities[row][col] <= 0 || subjectNumPossibilities[row][i] <= 0)//num possible options
    invalid = true;
}

void setOption(int row, int col, int i) {
  if (optionsPossible[row][col][i] == 0) { //<>// //<>//
    invalid = true;
    return;
  }
    
  optionsPossible[row][col] = new int[m];  // Set to new array of zeroes with same length as before (however many options there are)
  optionsPossible[row][col][i] = 1;  //bools
  gridNumPossibilities[row][col] = 1;  //num possible options by grid
  subjectColumns[row][i] = col;//indices (all unset options are -1)
  
  for (int c = 0; c < m; c++) {  // Iterate through all other columns and remove indicated subject from their possibilities
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
  //copyTo = new ArrayList<Clue>(); //<>// //<>//
  int copyFromSize = copyFrom.size();
  int copyToSize = copyTo.size();
  
  for (int i = 0; i < copyFromSize; i++) {
    if (i < copyToSize)
      copyTo.set(i, copyFrom.get(i).copyClue());
    else
      copyTo.add(copyFrom.get(i).copyClue());
  }
}

// Finds the indices of the cell with least possible options
int[] leastOptionsSquareIndices() {
  int minOptions = m + 1;
  int minRow = n;
  int minCol = m;
  
  for (int row = 0; row < n; row++) {
    for (int col = 0; col < m; col++) {
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


// Removes index values from string using ")" index
String realWord(String word) {
  int brackIndex = word.indexOf(")");
  
  if (brackIndex == -1)
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
  
  
  if (arrSize == 0) {
    linkedArr[arrSize] = 1;
    return append(arr, word);
  }
  
  else {
    int addIndex = binarySearch(arr, realWord(word), 0, arrSize - 1);
    
    arr = append(arr, arr[arrSize - 1]);
    linkedArr[arrSize] = linkedArr[arrSize-1];
    
    for (int i = arrSize - 1; i > addIndex; i--) {
      arr[i] = arr[i-1];
      linkedArr[i] = linkedArr[i-1];
    }
      
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

// Uses binary search to find the index of a word in a sorted array
int indexInArray(String[] arr, String el) {
  if (arr.length == 0)
    return -1;
    
  el = realWord(el);
  
  int elIndex = binarySearch(arr, el, 0, arr.length - 1); //<>// //<>//
  
  if (arr[elIndex].equals(el))
    return elIndex;
  else
    return -1;
}


// Copies puzzle info into backup arrays
void saveState() {
  copyArray(optionsPossible, prevOptionsPossible);
  copyArray(subjectColumns, prevSubjectColumns);
  copyArray(gridNumPossibilities, prevGridNumPossibilities);
  copyArray(subjectNumPossibilities, prevSubjectNumPossibilities);
  copyArray(clues, prevClues);
  prevNumCluesFinished = numCluesFinished;
}

// Retrieves and restores prev puzzle info from backup arrays
void revertState() {
  copyArray(prevOptionsPossible, optionsPossible);
  copyArray(prevSubjectColumns, subjectColumns);
  copyArray(prevGridNumPossibilities, gridNumPossibilities);
  copyArray(prevSubjectNumPossibilities, subjectNumPossibilities);
  copyArray(prevClues, clues);
  numCluesFinished = prevNumCluesFinished;
}

// Reverts all puzzle info to initial state
void resetState() {
  copyArray(initOptionsPossible, optionsPossible);
  copyArray(initSubjectColumns, subjectColumns);
  copyArray(initGridNumPossibilities, gridNumPossibilities);
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
