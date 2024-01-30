import g4p_controls.*;

//todo: if clueused, check if anything can be confirmed (if any only has one poss left, use subjectnumpossibilities)//done
//check after: negative, not at position, not at either end, not next to, any left of, any right of
//or just check when stuck
//todo: save initial state//done
//todo: if position doesn't matter, just ignore any position clues//done
//todo: m dimension//done
//todo: move hat: player: etc to start instead of end//done
//todo: gui working//done
//todo: suggestions//done
//todo: include way of showing all clues//done
//todo: sort based on amount of times used//done
//binar sort to find index instead of linear
//sort: take all unsorted elements out of list, save indices
//for each unsorted el: binary search at all blank indices to figure out which island it is in
//  binar search in island to find which position
//  insert, shifting least amount of els possible (if shift causes islands to merge, update blank indices)
//num times used same index as suggestion, when taking sample of suggestions, create two arrays of length sample size, one for suggestions, one for times used
//add to num times used when typed suggestion found to be in suggestions already
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

int checks = 0;
int guesses = 0;

boolean positionMatters = false;

int numCluesFinished = 0;
int prevNumCluesFinished = 0;

ArrayList<ArrayList<String>> subjects = new ArrayList<ArrayList<String>>();
ArrayList<String> categories = new ArrayList<String>();
String[] categSuggestions;
int[] categFrequency;
String[] options = new String[0];
String[] optSuggestions;
int[] optFrequency;
ArrayList<String> positions = new ArrayList<String>();

boolean invalid = false;//invalid reset to false every time a new guess is made

boolean solved = false;


//todo: if time, animate step by step process (animation speed slider), would have to show ones eliminated (in top corner, first letter with a red X if eliminated)

int gridX1;
int gridY1;
int gridX2;
int gridY2;

int gridWidth;
int gridHeight;
int cellWidth;
int cellHeight;

ArrayList<String> filler = new ArrayList<String>();
String[] t;
void setup() {
  categSuggestions = split(loadStrings("SuggestionData/categories.txt")[0], ",");
  categFrequency = int(split(loadStrings("SuggestionData/categoryFrequency.txt")[0], ","));
  optSuggestions = split(loadStrings("SuggestionData/options.txt")[0], ",");
  optFrequency = int(split(loadStrings("SuggestionData/optionFrequency.txt")[0], ","));

  createGUI();
  
  filler.add("-");
  String[] clueTypes = {"affirmative", "negative", "at position", "not at position", "at either end", "not at either end", "next to", "not next to", "immediately left of", "somewhere left of", "immediately right of", "somewhere right of"};
  selectCategory.setItems(filler, 0);
  selectSubjectA.setItems(filler, 0);
  selectSubjectB.setItems(filler, 0);
  selectClueType.setItems(clueTypes, 0);
  categsugg.setItems(filler, 0);
  optsugg.setItems(filler, 0);
  
  size(800, 600);
  
  gridX1 = 100;
  gridY1 = 50;
  gridX2 = 750;
  gridY2 = 550;
  
 
  ////todo: animate steps
  noLoop();
  
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
  
  resetState();
  drawPuzzleGrid();
  saveState();
  
  noLoop();
}

void printResult() {
  if (solved) {
    for (int i = 0; i < n; i++) {
      print(subjects.get(i).get(0) + "\t\t");
      for(int j = 0; j < m; j++) {
        int subjIndex = indexInArray(optionsPossible[i][j], 1) + 1;
        if (subjIndex >= subjects.get(i).size())
          print("\t\t");
        else
          print(subjects.get(i).get(subjIndex) + "\t\t");
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

void draw() {
  if (showClues) {
    background(0);
    
    strokeWeight(0);
    // Scroll bar background
    fill(170);
    rect(785, 0, 15, height);
    
    // Scroll bar
    fill(100);
    float scrollBarY1 = height * -scrollOffset/listLength();
    float scrollBarY2 = height * (-scrollOffset + height)/listLength();
    rect(785, scrollBarY1, 15, scrollBarY2 - scrollBarY1);
    strokeWeight(1);
    
    // Clues
    fill(255);
    for (int i = -scrollOffset/clueSpacing; i < numClues; i++) {
      Clue cl = initClues.get(i);
      
      cl.display();
      
      if (cluePadding + scrollOffset + clueSpacing * cl.index > height)
        break;
    }
      
    return;  // Early return to prevent puzzle grid from being drawn on top of clues
  }
  
  if (frameCount != 1) {
    solve();
    
    if (solved) {  // Valid solution found
      drawPuzzleGrid();
      
      textAlign(CENTER, CENTER);
      fill(0);
      for (int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
          int subjIndex = indexInArray(optionsPossible[i][j], 1) + 1;

          if (subjIndex >= subjects.get(i).size()) {  // Occurs if user makes dimension-related mistakes (ex: 5 options provided for one category, only 3 provided for another)
            drawPuzzleGrid();
            textAlign(CENTER, CENTER);
            fill(255, 0, 0);
            textSize(40);
            text("UNSOLVABLE", width/2, height/2);
          }
          else {
            String subject = subjects.get(i).get(subjIndex);
            textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));  // Scale text size to width of grid cell (max size 20)
            text(subject, gridX1 + (j + 0.5)*cellWidth, gridY1 + (i + 0.5)*cellHeight);  // Write subject text at centre of cell, (+ 0.5)'s are to get to the middle
            
            textSize(20);  // Reset textSize so textWidth gives correct value next loop
          }
        }
      }
      
      printResult();  // Print to console
    }
    
    else {
      drawPuzzleGrid();
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      textSize(40);
      text("UNSOLVABLE", width/2, height/2);
    }
    
    saveSuggestions();
    resetState();
    saveState();
    
    solved = false;
    noLoop();
  }
}

// todo: add puzzle class
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


//void drawPuzzleState() {
//  textAlign(CENTER, CENTER);
//  fill(0);
//  for (int i = 0; i < n; i++) {
//    for(int j = 0; j < m; j++) {
//      if (gridNumPossibilities[i][j] == 1) {
//        String subject = subjects.get(i).get(indexInArray(optionsPossible[i][j], 1) + 1);
//        textSize(min(20, 20 * (cellWidth - 10)/textWidth(subject)));
//        text(subject, gridX1 + (j + 0.5) * cellWidth, gridY1 + (i + 0.5) * cellHeight);
        
//        textSize(20);
//      }
//    }
//  }
//}

void solve() {
  while (true) {
    cluesUsed = false;
    fill(255);
    
    for (int i = numCluesFinished; i < numClues; i++) {
      checks += 1;
      Clue cl = clues.get(i - numCluesFinished);
      cl.process();
      
      //todo: animate printing out grid state instead
      String currentClue;
      if (cl.subjectB[1] == -1)
        currentClue = subjects.get(cl.subjectA[0]).get(cl.subjectA[1] + 1) + " <" + cl.clueType + "> #" + cl.subjectB[0];
      else
        currentClue = subjects.get(cl.subjectA[0]).get(cl.subjectA[1] + 1) + " <" + cl.clueType + "> " + subjects.get(cl.subjectB[0]).get(cl.subjectB[1] + 1);
      println(currentClue);
      for (Clue clue : clues)
        println(clue.subjectA[0], clue.clueType);
      
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
  
  if (arrayTotal(gridNumPossibilities) == n*m) {  // Sum of everything in array of num possibilities for grid
    solved = true;
    return;
  }
  
  if (arrayTotal(gridNumPossibilities) < n*m) {
    revertState();  // Revert to prev state
    return;
  }
  
  
  saveState(); // If invalid, can return to prev state
  int[] leastOptionsIndices = leastOptionsSquareIndices();  // Find square with least number of possible options >= 2 options
  
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
