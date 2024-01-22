int n = 5;//number of rows, number of columns, and number of options
int[][][] optionsPossible = new int[n][n][n];//bools
int[][] subjectColumns = new int[n][n];//indices
int[][] subjectNumPossibilities = new int[n][n];//num poss for subj
int[][] gridNumPossibilities = new int[n][n];//num poss for grid
ArrayList<Clue> clues = new ArrayList<Clue>();
int numClues = 0;

boolean invalid = false;//invalid reset to false every time a new guess is made
// todo: check if invalid after every clue process, if so, break
//todo: store suggestions in text file

boolean solved = false;

// Blank template class which will be used to store specific functions in a general object
class Function {
  void call() {}
}
// todo: binary search, insertion sort for category/option suggestions
void setup() {
  for (int i = 0; i < optionsPossible.length; i++) {
    for (int j = 0; j < optionsPossible[0].length, j++) {
      for (int k = 0; k < optionsPossible[0][0].length, k++) {
        optionsPossible[i][j][k] = 1;
      }
    }
  }
  
  for (int i = 0; i < subjectColumns.length; i++) {
    for (int j = 0; j < subjectColumns[0].length; j++) {
      subjectColumns[i][j] = -1;
    }
  }
  
  for (int i = 0; i < subjectNumPossibilities.length; i++) {
    for (int j = 0; j < subjectNumPossibilities[0].length; j++) {
      subjectNumPossibilities[i][j] = n;
    }
  }
  
  for (int i = 0; i < gridNumPossibilities.length; i++) {
    for (int j = 0; j < gridNumPossibilities[0].length, j++) {
      gridNumPossibilities[i][j] = n;
    }
  }
}

void solve() {
  if (sum of everything in array of num possibilr for grid == n*n) {
    solved = true;
    return;
  }
  
  if (sum of evrytin < n*n) {
    revert to prev state
    return;
  }
  
  while (num nothing amounted clues != clues.size()) {
    for (Clue cl : clues) {
      processClue(cl);
      //todo: add way to check if nothing amounted from clue
      if (invalid) {
        revert to prev state
        return;
      }
    }
  }
  
  save prev state; //(if invalid, return to prev state)
  find square with least num possible options;
  make random guess;
  solve();
}

void processClue(Clue c) {
  String ct = c.clueType;
  int[] subjA = c.subjectA;
  int[] subjB = c.subjectB;
  
  if (ct.equals("affirmative"))
    affirmative(subjA, subjB);
  else if (ct.equals("negative"))
    negative(subjA, subjB);
  else if (ct.equals("at position"))
    atPosition(subjA, subjB, 1);
  else if (ct.equals("not at position"))
    atPosition(subjA, subjB, 0);
  else if (ct.equals("at either end"))
    atEitherEnd(subjA, 1);
  else if (ct.equals("not at either end"))
    atEitherEnd(subjA, 0);
  else if (ct.equals("next to"))
    nextTo(subjA, subjB, 1);
  else if (ct.equals("not next to"))
    nextTo(subjA, subjB, 0);
  else if (ct.equals("immediately left of"))
    leftOf(subjA, subjB, 0);
  else if (ct.equals("somewhere left of"))
    leftOf(subjA, subjB, 1);
  else if (ct.equals("immediately right of"))
    rightOf(subjA, subjB, 0);
  else if (ct.equals("somewhere right of"))
    rightOf(subjA, subjB, 1);
    
  //c.linkedFunction.call();
}
