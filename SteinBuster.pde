import g4p_controls.*;

//todo: if clueused, check if anything can be confirmed (if any only has one poss left, use subjectnumpossibilities)
//check after: negative, not at position, not at either end, not next to, any left of, any right of
//or just check when stuck
//todo: save initial state
//todo: if position doesn't matter, just ignore any position clues
//todo: gui working
//todo: suggestions, textbox class
//todo: save steps in array, make step class, in draw() animate steps[step], step+=1
int n = 4;//number of rows, number of columns, and number of options
int[][][] optionsPossible = new int[n][n][n];//bools
int[][][] prevOptionsPossible = new int[n][n][n];
int[][][] initOptionsPossible = new int[n][n][n];
int[][] subjectColumns = new int[n][n];//indices
int[][] prevSubjectColumns = new int[n][n];
int[][] initSubjectColumns = new int[n][n];
int[][] subjectNumPossibilities = new int[n][n];//num poss for subj
int[][] prevSubjectNumPossibilities = new int[n][n];
int[][] initSubjectNumPossibilities = new int[n][n];
int[][] gridNumPossibilities = new int[n][n];//num poss for grid
int[][] prevGridNumPossibilities = new int[n][n];
int[][] initGridNumPossibilities = new int[n][n];
ArrayList<Clue> clues = new ArrayList<Clue>();
ArrayList<Clue> prevClues = new ArrayList<Clue>();
ArrayList<Clue> initClues = new ArrayList<Clue>();
int numClues = 0;

boolean positionMatters = false;

int numCluesFinished = 0;
int prevNumCluesFinished = 0;

String[][] subjects = new String[n][n+1];

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
  
  String[] filler = {"filler", "filler", "filler"};
  selectCategory.setItems(filler, 0);
  selectSubjectA.setItems(filler, 0);
  selectSubjectB.setItems(filler, 0);
  selectClueType.setItems(filler, 0);
  
  size(800, 600);
  //background(0);
  
  gridX1 = 100;
  gridY1 = 50;
  gridX2 = 750;
  gridY2 = 550;
  
  gridWidth = gridX2 - gridX1;
  gridHeight = gridY2 - gridY1;
  cellWidth = gridWidth/n;
  cellHeight = gridHeight/n;
  
  //strokeWeight(3);
  //rect(gridX1, gridY1, gridWidth, gridHeight);
  
  
  
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      for (int k = 0; k < n; k++) {
        initOptionsPossible[i][j][k] = 1;
      }
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      initSubjectColumns[i][j] = -1;
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      initSubjectNumPossibilities[i][j] = n;
    }
  }
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      initGridNumPossibilities[i][j] = n;
    }
  }
  //todo: keep initial states, so can revert every new solve
  //todo: animate steps
  //initClues.add(new Clue(new int[]{3, 3}, "at position", new int[]{2, -1}));//todo: gives index error when position doesn't matter
  //initClues.add(new Clue(new int[]{2, 0}, "at position", new int[]{3, -1}));//todo: gives index error when position doesn't matter
  initClues.add(new Clue(new int[]{0, 1}, "at position", new int[]{2, -1}));
  initClues.add(new Clue(new int[]{1, 2}, "next to", new int[]{0, 3}));
  initClues.add(new Clue(new int[]{1, 2}, "immediately left of", new int[]{0, 1}));
  initClues.add(new Clue(new int[]{1, 0}, "affirmative", new int[]{3, 2}));
  initClues.add(new Clue(new int[]{2, 2}, "affirmative", new int[]{3, 3}));
  initClues.add(new Clue(new int[]{3, 0}, "somewhere right of", new int[]{0, 1}));
  initClues.add(new Clue(new int[]{1, 2}, "affirmative", new int[]{3, 1}));
  initClues.add(new Clue(new int[]{1, 1}, "at position", new int[]{2, -1}));
  initClues.add(new Clue(new int[]{1, 1}, "immediately left of", new int[]{0, 0}));
  initClues.add(new Clue(new int[]{3, 2}, "next to", new int[]{2, 1}));
  //numClues = clues.size();
  
  subjects[0] = new String[]{"blue", "pink", "white", "yellow", "Hat:"};
  subjects[1] = new String[]{"Eric", "Oscar", "Peter", "Richard", "Name:"};
  subjects[2] = new String[]{"Aguero", "Cruyff", "Pele", "Ronaldinho", "Player:"};
  subjects[3] = new String[]{"cousin", "friend", "nephew", "uncle", "Companion:"};
  
  
  resetState();
  //textAlign(RIGHT, CENTER);
  //textSize(20);
  //fill(255);
  
  //for (int i = 0; i < n; i++) {
  //  int x = gridX1 + i*cellWidth;
  //  int y = gridY1 + i*cellHeight;
    
  //  strokeWeight(1);
  //  line(gridX1, y, gridX2, y);
  //  strokeWeight(3);
  //  line(x, gridY1, x, gridY2);
    
  //  textSize(min(20, 20 * (gridX1 - 10)/textWidth(subjects[i][n])));
  //  text(subjects[i][n], gridX1 - 5, y + cellHeight/2);
    
  //  textSize(20);
  //}
  
  drawPuzzleGrid();
  
  saveState();
  
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

void printResult() {
  //println(checks, positionMatters);
  if (solved) {
    for (int i = 0; i < n; i++) {
      print(subjects[i][n] + "\t\t");
      for(int j = 0; j < n; j++) {
        String subject = subjects[i][indexInArray(optionsPossible[i][j], 1)];
        print(subject + "\t\t");
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
        for(int j = 0; j < n; j++) {
          String subject = subjects[i][indexInArray(optionsPossible[i][j], 1)];
          textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));
          text(subject, gridX1 + (j + 0.5) * cellWidth, gridY1 + (i + 0.5) * cellHeight);
          
          textSize(20);
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
    int x = gridX1 + i*cellWidth;
    int y = gridY1 + i*cellHeight;
    
    strokeWeight(1);
    line(gridX1, y, gridX2, y);
    strokeWeight(3);
    line(x, gridY1, x, gridY2);
    
    textSize(min(20, 20 * (gridX1 - 10)/textWidth(subjects[i][n])));
    text(subjects[i][n], gridX1 - 5, y + cellHeight/2);
    
    textSize(20);
  }
  
}


void drawPuzzleState() {
  textAlign(CENTER, CENTER); //<>//
  fill(0);
  for (int i = 0; i < n; i++) {
    for(int j = 0; j < n; j++) {
      if (gridNumPossibilities[i][j] == 1) {
        String subject = subjects[i][indexInArray(optionsPossible[i][j], 1)];
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
        currentClue = subjects[cl.subjectA[0]][cl.subjectA[1]] + " <" + cl.clueType + "> #" + cl.subjectB[0];
      else
        currentClue = subjects[cl.subjectA[0]][cl.subjectA[1]] + " <" + cl.clueType + "> " + subjects[cl.subjectB[0]][cl.subjectB[1]];
      println(currentClue);
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
  
  if (arrayTotal(gridNumPossibilities) == n*n) {//sum of everything in array of num possibilr for grid
    solved = true;
    return;
  }
  
  if (arrayTotal(gridNumPossibilities) < n*n) {
    revertState();  // Revert to prev state
    return;
  }
  
  
  saveState(); //(if invalid, can return to prev state)
  int[] leastOptionsIndices = leastOptionsSquareIndices();  // no errors will occur here due to previous two if statements (pigeon hole)  //<>//
  //find square with least num possible options >= 2;
  //let's say found at numGridPossibilities[row][col]
  
  int row = leastOptionsIndices[0];
  int col = leastOptionsIndices[1];
  for (int guessIndex = 0; guessIndex < n; guessIndex++) {
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
