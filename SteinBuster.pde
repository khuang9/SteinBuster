import g4p_controls.*;

//todo: if clueused, check if anything can be confirmed (if any only has one poss left, use subjectnumpossibilities)
//check after: negative, not at position, not at either end, not next to, any left of, any right of
//or just check when stuck
//todo: save initial state//done
//todo: if position doesn't matter, just ignore any position clues//done
//todo: m dimension//done
//todo: move hat: player: etc to start instead of end//done
//todo: gui working
//todo: suggestions, textbox class
//todo: save steps in array, make step class, in draw() animate steps[step], step+=1
int n = 0;//4;//number of rows, number of columns, and number of options
int m = 0;//5;
int[][][] optionsPossible;//bools
int[][][] prevOptionsPossible;
int[][][] initOptionsPossible;
int[][] subjectColumns;//indices
int[][] prevSubjectColumns;
int[][] initSubjectColumns;
int[][] subjectNumPossibilities;//num poss for subj
int[][] prevSubjectNumPossibilities;
int[][] initSubjectNumPossibilities;
int[][] gridNumPossibilities;//num poss for grid
int[][] prevGridNumPossibilities;
int[][] initGridNumPossibilities;
ArrayList<Clue> clues = new ArrayList<Clue>();
ArrayList<Clue> prevClues = new ArrayList<Clue>();
ArrayList<Clue> initClues = new ArrayList<Clue>();
int numClues = 0;

boolean positionMatters = false;

int numCluesFinished = 0;
int prevNumCluesFinished = 0;

//ArrayList<ArrayList<String>> subjects = new String[n][m+1];
ArrayList<ArrayList<String>> subjects = new ArrayList<ArrayList<String>>();
ArrayList<String> categories = new ArrayList<String>();
ArrayList<String> options = new ArrayList<String>();
ArrayList<String> positions = new ArrayList<String>();

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
//todo: if time, animate step by step process (animation speed slider), would have to show ones eliminated (in top corner, first letter with a red X if eliminated)

int gridX1;
int gridY1;
int gridX2;
int gridY2;

int gridWidth;
int gridHeight;
int cellWidth;
int cellHeight;

void setup() {
  createGUI();
  
  ArrayList<String> filler = new ArrayList<String>();
  filler.add("-");
  String[] clueTypes = {"affirmative", "negative", "at position", "not at position", "at either end", "not at either end", "next to", "not next to", "immediately left of", "somewhere left of", "immediately right of", "somewhere right of"};
  selectCategory.setItems(filler, 0);
  selectSubjectA.setItems(filler, 0);
  selectSubjectB.setItems(filler, 0);
  selectClueType.setItems(clueTypes, 0);
  
  size(800, 600);
  //background(0);
  
  gridX1 = 100;
  gridY1 = 50;
  gridX2 = 750;
  gridY2 = 550;
  
  //gridWidth = gridX2 - gridX1;
  //gridHeight = gridY2 - gridY1;
  //cellWidth = gridWidth/m;
  //cellHeight = gridHeight/n;
  
  ////strokeWeight(3);
  ////rect(gridX1, gridY1, gridWidth, gridHeight);
  
  
  
  
  //for (int i = 0; i < n; i++) {
  //  for (int j = 0; j < m; j++) {
  //    for (int k = 0; k < m; k++) {
  //      initOptionsPossible[i][j][k] = 1;
  //    }
  //  }
  //}
  
  //for (int i = 0; i < n; i++) {
  //  for (int j = 0; j < m; j++) {
  //    initSubjectColumns[i][j] = -1;
  //  }
  //}
  
  //for (int i = 0; i < n; i++) {
  //  for (int j = 0; j < m; j++) {
  //    initSubjectNumPossibilities[i][j] = m;
  //  }
  //}
  
  //for (int i = 0; i < n; i++) {
  //  for (int j = 0; j < m; j++) {
  //    initGridNumPossibilities[i][j] = m;
  //  }
  //}
  ////todo: keep initial states, so can revert every new solve
  ////todo: animate steps
  //initClues.add(new Clue(new int[]{3, 3}, "at position", new int[]{2, -1}));//todo: gives index error when position doesn't matter
  //initClues.add(new Clue(new int[]{2, 0}, "at position", new int[]{3, -1}));//todo: gives index error when position doesn't matter
  //initClues.add(new Clue(new int[]{0, 1}, "at position", new int[]{2, -1}));
  //initClues.add(new Clue(new int[]{1, 2}, "next to", new int[]{0, 3}));
  //initClues.add(new Clue(new int[]{1, 2}, "immediately left of", new int[]{0, 1}));
  //initClues.add(new Clue(new int[]{1, 0}, "affirmative", new int[]{3, 2}));
  //initClues.add(new Clue(new int[]{2, 2}, "affirmative", new int[]{3, 3}));
  //initClues.add(new Clue(new int[]{3, 0}, "somewhere right of", new int[]{0, 1}));
  //initClues.add(new Clue(new int[]{1, 2}, "affirmative", new int[]{3, 1}));
  //initClues.add(new Clue(new int[]{1, 1}, "at position", new int[]{2, -1}));
  //initClues.add(new Clue(new int[]{1, 1}, "immediately left of", new int[]{0, 0}));
  //initClues.add(new Clue(new int[]{3, 2}, "next to", new int[]{2, 1}));
  ////numClues = clues.size();
  
  ////subjects.get(0) = new ArrayList<String>("Hat:", "blue", "pink", "white", "yellow", "A");
  ////subjects.get(1) = new String[]{"Name:", "Eric", "Oscar", "Peter", "Richard", "B"};
  ////subjects.get(2) = new String[]{"Player:", "Aguero", "Cruyff", "Pele", "Ronaldinho", "C"};
  ////subjects.get(3) = new String[]{"Companion:", "cousin", "friend", "nephew", "uncle", "D"};
  
  ////subjects.add(new ArrayList<String>();
  ////subjects.get(1) = new String[]{"Name:", "Eric", "Oscar", "Peter", "Richard", "B"};
  ////subjects.get(2) = new String[]{"Player:", "Aguero", "Cruyff", "Pele", "Ronaldinho", "C"};
  ////subjects.get(3) = new String[]{"Companion:", "cousin", "friend", "nephew", "uncle", "D"};
  
  
  //resetState(); //<>//
  ////textAlign(RIGHT, CENTER);
  ////textSize(20);
  ////fill(255);
  
  ////for (int i = 0; i < n; i++) {
  ////  int x = gridX1 + i*cellWidth;
  ////  int y = gridY1 + i*cellHeight;
    
  ////  strokeWeight(1);
  ////  line(gridX1, y, gridX2, y);
  ////  strokeWeight(3);
  ////  line(x, gridY1, x, gridY2);
    
  ////  textSize(min(20, 20 * (gridX1 - 10)/textWidth(subjects[i][n])));
  ////  text(subjects[i][n], gridX1 - 5, y + cellHeight/2);
    
  ////  textSize(20);
  ////}
  
  //drawPuzzleGrid();
  
  //saveState();
  
  noLoop();
  
  //if (!positionMatters) {
  //  for (int col = 0; col < n; col++)
  //    setOption(0, col, col);
  //}
  //println("A");
  //solve(); //<>//
  //println("B");
  //if (solved) {
  //  textAlign(CENTER, CENTER);
  //  fill(0);
    
  //  for (int i = 0; i < n; i++) {
  //    print(subjects[i][n] + "\t\t");
  //    for(int j = 0; j < n; j++) {
  //      String subject = subjects[i][indexInArray(optionsPossible[i][j], 1)];
  //      textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));
  //      text(subject, gridX1 + (j + 0.5) * cellWidth, gridY1 + (i + 0.5) * cellHeight);
  //      print(subject + "\t\t");
        
  //      textSize(20);
  //    }
  //    print("\n");
  //  }
    
  //  println("Clue checks:", checks);
  //  println("Guesses made:", guesses);
  //}
  
  //else
  //  println("Puzzle is unsolvable");
    
  
}

void initialize() {
  gridWidth = gridX2 - gridX1;
  gridHeight = gridY2 - gridY1;
  cellWidth = gridWidth/m;
  cellHeight = gridHeight/n;
  
  optionsPossible = new int[n][m][m];//bools
  prevOptionsPossible = new int[n][m][m];
  initOptionsPossible = new int[n][m][m];
  subjectColumns = new int[n][m];//indices
  prevSubjectColumns = new int[n][m];
  initSubjectColumns = new int[n][m];
  subjectNumPossibilities = new int[n][m];//num poss for subj
  prevSubjectNumPossibilities = new int[n][m];
  initSubjectNumPossibilities = new int[n][m];
  gridNumPossibilities = new int[n][m];//num poss for grid
  prevGridNumPossibilities = new int[n][m];
  initGridNumPossibilities = new int[n][m];
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      for (int k = 0; k < m; k++) {
        initOptionsPossible[i][j][k] = 1;
      }
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      initSubjectColumns[i][j] = -1;
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      initSubjectNumPossibilities[i][j] = m;
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      initGridNumPossibilities[i][j] = m;
    }
  }
  
  println(n, m);
  resetState();
  
  drawPuzzleGrid();
  
  saveState();
  
  noLoop();
}

void printResult() {
  //println(checks, positionMatters);
  if (solved) {
    for (int i = 0; i < n; i++) {
      print(subjects.get(i).get(0) + "\t\t");
      for(int j = 0; j < m; j++) {
        int subjIndex = indexInArray(optionsPossible[i][j], 1) + 1;
        if (subjIndex >= subjects.get(i).size())
          print("\t\t");
        else {
          //String subject = subjects.get(i).get(subjIndex);
          print(subjects.get(i).get(subjIndex) + "\t\t");
        }
      }
      print("\n");
    }
    
    println("Clue checks:", checks);
    println("Guesses made:", guesses);
  }
  
  else
    println("Puzzle is unsolvable");
    
    
  loop();
}
//todo: bind enter key to enter button event//nvm, unless can figure out how to know which button should be bound to enter key (know which textbox selected)
void draw() {
  //noLoop();
  if (frameCount != 1) {
    solve();
    
    if (solved) {
      drawPuzzleGrid();
      
      textAlign(CENTER, CENTER);
      fill(0);
      for (int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
          int subjIndex = indexInArray(optionsPossible[i][j], 1) + 1;

          if (subjIndex >= subjects.get(i).size()) {
            drawPuzzleGrid();
            textAlign(CENTER, CENTER);
            fill(255, 0, 0);
            textSize(40);
            text("UNSOLVABLE", width/2, height/2);
          }
          else {
            String subject = subjects.get(i).get(subjIndex);
            textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));
            text(subject, gridX1 + (j + 0.5) * cellWidth, gridY1 + (i + 0.5) * cellHeight);
            
            textSize(20);
          }
        }
      }
      
      printResult();
    }
    
    else {
      drawPuzzleGrid();
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      textSize(40);
      text("UNSOLVABLE", width/2, height/2);
    }
    resetState();
    saveState();
    //for (Clue cl : clues)
    //  println(cl.subjectA[0], cl.clueType);
    solved = false;
    noLoop();
  }
}
//void mousePressed() {
//  rect(0, 0, 100, 100);
//}
// todo: add puzzle class
// todo: draw screen refreshing
//todo: gui
//todo: if time, add feature for figuring out how many solutions there are
void keyPressed() {
  if (keyCode == ENTER)
    solve();
}


void drawPuzzleGrid() {
  background(0);
  
  strokeWeight(3);
  fill(255);
  rect(gridX1, gridY1, gridWidth, gridHeight);
  
  textAlign(RIGHT, CENTER);
  textSize(20);
  
  for (int i = 0; i < n; i++) {
    int y = gridY1 + i*cellHeight;
    
    strokeWeight(1);
    line(gridX1, y, gridX2, y);
    
    textSize(min(20, 20 * (gridX1 - 10)/textWidth(subjects.get(i).get(0))));
    text(subjects.get(i).get(0), gridX1 - 5, y + cellHeight/2);
    
    textSize(20);
  }
  
  for (int j = 0; j < m; j++) {
    int x = gridX1 + j*cellWidth;
    
    strokeWeight(3);
    line(x, gridY1, x, gridY2);
  }
  
}


void drawPuzzleState() {
  textAlign(CENTER, CENTER); //<>//
  fill(0);
  for (int i = 0; i < n; i++) {
    for(int j = 0; j < m; j++) {
      if (gridNumPossibilities[i][j] == 1) {
        String subject = subjects.get(i).get(indexInArray(optionsPossible[i][j], 1) + 1);
        textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));
        text(subject, gridX1 + (j + 0.5) * cellWidth, gridY1 + (i + 0.5) * cellHeight);
        
        textSize(20);
      }
    }
  }
}

void solve() {
  while (true) {
    //numCluesUsed = 0;
    cluesUsed = false; //<>//
    fill(255);
    rect(0, 0, 100, 100);
    for (int i = numCluesFinished; i < numClues; i++) {
      checks += 1;
      Clue cl = clues.get(i - numCluesFinished);
      //processClue(cl);
      cl.process();
      
      //drawPuzzleGrid(); //<>//
      //drawPuzzleState();
      //todo: print out grid state instead
      String currentClue;
      if (cl.subjectB[1] == -1)
        currentClue = subjects.get(cl.subjectA[0]).get(cl.subjectA[1] + 1) + " <" + cl.clueType + "> #" + cl.subjectB[0];
      else
        currentClue = subjects.get(cl.subjectA[0]).get(cl.subjectA[1] + 1) + " <" + cl.clueType + "> " + subjects.get(cl.subjectB[0]).get(cl.subjectB[1] + 1);
      println(currentClue); //<>//
      for (Clue clue : clues)
        println(clue.subjectA[0], clue.clueType);
      //fill(0);
      //textAlign(CENTER, CENTER);
      //textSize(20);
      //text(currentClue, width/2, 20);
      //delay(1000);
      
      //todo: add way to check if nothing amounted from clue
      if (invalid) {
        revertState();  // Revert to prev state
        invalid = false;
        return;
      }
    }
    
    while (!stuck()) {}
    
    if (!cluesUsed)
      break;
  }
  
  if (arrayTotal(gridNumPossibilities) == n*m) {//sum of everything in array of num possibilr for grid
    solved = true;
    return;
  }
  
  if (arrayTotal(gridNumPossibilities) < n*m) {
    revertState();  // Revert to prev state
    return;
  }
  
  
  saveState(); //(if invalid, can return to prev state)
  int[] leastOptionsIndices = leastOptionsSquareIndices();  // no errors will occur here due to previous two if statements (pigeon hole)  //<>//
  //find square with least num possible options >= 2;
  //let's say found at numGridPossibilities[row][col]
  
  int row = leastOptionsIndices[0];
  int col = leastOptionsIndices[1];
  for (int guessIndex = 0; guessIndex < m; guessIndex++) {
    if (optionsPossible[row][col][guessIndex] == 1) {
      guesses += 1;
      
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
int checks = 0;
int guesses = 0;
//void processClue(Clue cl) {
//  //clue = cl;
//  checks += 1;
  
//  cl.process();
//  //String ct = cl.clueType;
//  //int[] subjA = cl.subjectA;
//  //int[] subjB = cl.subjectB;
  
//  //if (ct.equals("affirmative"))
//  //  affirmative(cl, subjA, subjB);
//  //else if (ct.equals("negative"))
//  //  negative(cl, subjA, subjB);
//  //else if (ct.equals("at position"))
//  //  atPosition(cl, subjA, subjB, 1);
//  //else if (ct.equals("not at position"))
//  //  atPosition(cl, subjA, subjB, 0);
//  //else if (ct.equals("at either end"))
//  //  atEitherEnd(cl, subjA, 1);
//  //else if (ct.equals("not at either end"))
//  //  atEitherEnd(cl, subjA, 0);
//  //else if (ct.equals("next to"))
//  //  nextTo(cl, subjA, subjB, 1);
//  //else if (ct.equals("not next to"))
//  //  nextTo(cl, subjA, subjB, 0);
//  //else if (ct.equals("immediately left of"))
//  //  leftOf(cl, subjA, subjB, 0);
//  //else if (ct.equals("somewhere left of"))
//  //  leftOf(cl, subjA, subjB, 1);
//  //else if (ct.equals("immediately right of"))
//  //  rightOf(cl, subjA, subjB, 0);
//  //else if (ct.equals("somewhere right of"))
//  //  rightOf(cl, subjA, subjB, 1);
    
//  //c.linkedFunction.call();
//}
