int n = 4;//number of rows, number of columns, and number of options
int[][][] optionsPossible = new int[n][n][n];//bools
int[][][] prevOptionsPossible = new int[n][n][n];
int[][] subjectColumns = new int[n][n];//indices
int[][] prevSubjectColumns = new int[n][n];
//int[][] subjectNumPossibilities = new int[n][n];//num poss for subj
int[][] gridNumPossibilities = new int[n][n];//num poss for grid
int[][] prevGridNumPossibilities = new int[n][n];
ArrayList<Clue> clues = new ArrayList<Clue>();
ArrayList<Clue> prevClues = new ArrayList<Clue>();
int numClues = 0;

int numCluesFinished = 0;
int prevNumCluesFinished = 0;

String[][] subjects = new String[n][n];

boolean invalid = false;//invalid reset to false every time a new guess is made
// todo: check if invalid after every clue process, if so, break
//todo: store suggestions in text file

boolean solved = false;

// Blank template class which will be used to store specific functions in a general object
class Function {
  void call() {}
}
// todo: binary search, insertion sort for category/option suggestions
// search to find place in list based on letters typed and add new suggestion into right place
// sort relevant suggestions by times used
void setup() {
  for (int i = 0; i < optionsPossible.length; i++) {
    for (int j = 0; j < optionsPossible[0].length; j++) {
      for (int k = 0; k < optionsPossible[0][0].length; k++) {
        optionsPossible[i][j][k] = 1;
      }
    }
  }
  
  for (int i = 0; i < subjectColumns.length; i++) {
    for (int j = 0; j < subjectColumns[0].length; j++) {
      subjectColumns[i][j] = -1;
    }
  }
  
  //for (int i = 0; i < subjectNumPossibilities.length; i++) {
  //  for (int j = 0; j < subjectNumPossibilities[0].length; j++) {
  //    subjectNumPossibilities[i][j] = n;
  //  }
  //}
  
  for (int i = 0; i < gridNumPossibilities.length; i++) {
    for (int j = 0; j < gridNumPossibilities[0].length; j++) {
      gridNumPossibilities[i][j] = n;
    }
  }
  
  clues.add(new Clue(new int[]{3, 3}, "at position", new int[]{2, -1}));
  clues.add(new Clue(new int[]{2, 0}, "at position", new int[]{3, -1}));
  clues.add(new Clue(new int[]{0, 1}, "at position", new int[]{2, -1}));
  clues.add(new Clue(new int[]{1, 2}, "next to", new int[]{0, 3}));
  clues.add(new Clue(new int[]{1, 2}, "immediately left of", new int[]{0, 1}));
  clues.add(new Clue(new int[]{1, 0}, "affirmative", new int[]{3, 2}));
  clues.add(new Clue(new int[]{2, 2}, "affirmative", new int[]{3, 3}));
  clues.add(new Clue(new int[]{3, 0}, "somewhere right of", new int[]{0, 1}));
  clues.add(new Clue(new int[]{1, 2}, "affirmative", new int[]{3, 1}));
  clues.add(new Clue(new int[]{1, 1}, "at position", new int[]{2, -1}));
  clues.add(new Clue(new int[]{1, 1}, "immediately left of", new int[]{0, 0}));
  clues.add(new Clue(new int[]{3, 2}, "next to", new int[]{2, 1}));
  //numClues = clues.size();
  
  subjects[0] = new String[]{"blue", "pink", "white", "yellow"};
  subjects[1] = new String[]{"Eric", "Oscar", "Peter", "Richard"};
  subjects[2] = new String[]{"Aguero", "Cruyff", "Pele", "Ronaldinho"};
  subjects[3] = new String[]{"cousin", "friend", "nephew", "uncle"};
  
  saveState();
  
  solve();
  
  if (solved) {
    
  }
}

void solve() {
  while (true) {
    //numCluesUsed = 0;
    cluesUsed = false;
    
    for (int i = numCluesFinished; i < numClues; i++) {
      Clue cl = clues.get(i - numCluesFinished);
      processClue(cl);
      //todo: add way to check if nothing amounted from clue
      if (invalid) {
        revertState();  // Revert to prev state
        return;
      }
    }
    
    if (!cluesUsed)
      break;
  }
  
  if (arrayTotal(gridNumPossibilities) == n*n) {//sum of everything in array of num possibilr for grid
    solved = true;
    return;
  }
  
  if (arrayTotal(gridNumPossibilities) < n*n) { //<>//
    revertState();  // Revert to prev state
    return;
  }
  
  
  saveState(); //(if invalid, can return to prev state)
  int[] leastOptionsIndices = leastOptionsSquareIndices();  // no errors will occur here due to previous two if statements (pigeon hole) 
  //find square with least num possible options >= 2;
  //let's say found at numGridPossibilities[row][col]
  
  int row = leastOptionsIndices[0];
  int col = leastOptionsIndices[1];
  for (int guessIndex = 0; guessIndex < optionsPossible[row][col].length; guessIndex++) {
    if (optionsPossible[row][col][guessIndex] == 1) {
      setOption(row, col, guessIndex);
      solve();
      if (solved) {
        println("Solved");
        return;
      }
        
    }
  }
}
Clue clue;
void processClue(Clue cl) {
  clue = cl;
  String ct = cl.clueType;
  int[] subjA = cl.subjectA;
  int[] subjB = cl.subjectB;
  
  if (ct.equals("affirmative"))
    affirmative(cl, subjA, subjB);
  else if (ct.equals("negative"))
    negative(cl, subjA, subjB);
  else if (ct.equals("at position"))
    atPosition(cl, subjA, subjB, 1);
  else if (ct.equals("not at position"))
    atPosition(cl, subjA, subjB, 0);
  else if (ct.equals("at either end"))
    atEitherEnd(cl, subjA, 1);
  else if (ct.equals("not at either end"))
    atEitherEnd(cl, subjA, 0);
  else if (ct.equals("next to"))
    nextTo(cl, subjA, subjB, 1);
  else if (ct.equals("not next to"))
    nextTo(cl, subjA, subjB, 0);
  else if (ct.equals("immediately left of"))
    leftOf(cl, subjA, subjB, 0);
  else if (ct.equals("somewhere left of"))
    leftOf(cl, subjA, subjB, 1);
  else if (ct.equals("immediately right of"))
    rightOf(cl, subjA, subjB, 0);
  else if (ct.equals("somewhere right of"))
    rightOf(cl, subjA, subjB, 1);
    
  //c.linkedFunction.call();
}
