import g4p_controls.*;

//todo: save steps in array, make step class, in draw() animate steps[step], step+=1
int n = 0;  // Number of rows, also number of categories
int m = 0;  // Number of columns, also number of options per category

int[][][] optionsPossible;      // Contains list of 0s and 1s corresponding to each grid cell (0 means subject with that assigned index cannot be put in that cell, 1 means it can be put there)
int[][][] prevOptionsPossible;  // Stores values from before last guess
int[][][] initOptionsPossible;  // Stores values from initialization
int[][] subjectColumns;      // Determined indices of each subject (if undetermined, it will be -1)
int[][] prevSubjectColumns;  // Stores values from before last guess
int[][] initSubjectColumns;  // Stores values from initialization
int[][] subjectNumPossibilities;      // Possible positions for each subject
int[][] prevSubjectNumPossibilities;  // Stores values from before last guess
int[][] initSubjectNumPossibilities;  // Stores values from initialization
int[][] cellNumPossibilities;      // Possible options in each grid cell
int[][] prevCellNumPossibilities;  // Stores values from before last guess
int[][] initCellNumPossibilities;  // Stores values from initialization
ArrayList<Clue> clues = new ArrayList<Clue>();      // Contains all unused/partially used clues
ArrayList<Clue> prevClues = new ArrayList<Clue>();  // Stores clues from before last guess (some currently used clues may have been unused back then)
ArrayList<Clue> initClues = new ArrayList<Clue>();  // Stores initial state of clues (contains every clue the user entered in proper order)

int numCluesFinished = 0;  // Used clues are not removed from the list, just replaced with used clues from the back of the list
                           // numCluesFinished keeps track of where to loop up to when checking through all clues
int prevNumCluesFinished = 0;
// No initNumCluesFinished needed because it's just 0

int numClues = 0;  // Length of clues array

int steps = 0;  // Tracks how many logical steps were taken (number of for loop iterations)
int guesses = 0;  // Tracks how many guesses were made (number of recursive calls)

boolean positionMatters = false;  // Some types of puzzles have positional clues with only one right answer, some have no positional clues with m! right answers (any permutation of the columns works)


ArrayList<ArrayList<String>> subjects = new ArrayList<ArrayList<String>>();  // Stores all subjects entered in rows corresponding to their respective categories
ArrayList<String> categories = new ArrayList<String>();  // Used to set items of categories drop list for entering options
String[] categSuggestions;  // Used to set items of suggestions drop down for entering categories
int[] categFrequency;       // Tracks how many times each suggestion is selected
String[] options = new String[0];  // Used to set items of subject drop lists for entering clues
String[] optSuggestions;  // Used to set items of suggestions drop down for entering options
int[] optFrequency;       // Tracks how many times each suggestion is selected
ArrayList<String> positions = new ArrayList<String>();  // Contains all position numbers (consective nums from 1 to m)

boolean invalid = false;  // Validity of current puzzle state (invalid resets to false every time a new guess is made, set to true whenever a clue is violated)

boolean solved = false;  // Set to true when valid solution found, set to false after solution displayed
boolean cluesUsed = false;  // Tracks whether or not any progress was made in an iteration

//todo: if time, animate step by step process (animation speed slider), would have to show ones eliminated (in top corner, first letter with a red X if eliminated)

// Edge coords of puzzle grid
int gridX1 = 100;
int gridY1 = 50;
int gridX2 = 750;
int gridY2 = 550;

// Measurements
int gridWidth = gridX2 - gridX1;
int gridHeight = gridY2 - gridY1;
int cellWidth;
int cellHeight;

String[] filler = {"-"};  // Prevents drop list nullpointers

void setup() {
  // Load in file data
  categSuggestions = split(loadStrings("SuggestionData/categories.txt")[0], ",");
  categFrequency = int(split(loadStrings("SuggestionData/categoryFrequency.txt")[0], ","));
  optSuggestions = split(loadStrings("SuggestionData/options.txt")[0], ",");
  optFrequency = int(split(loadStrings("SuggestionData/optionFrequency.txt")[0], ","));

  createGUI();
  
  // Initialize drop lists
  String[] clueTypes = {"affirmative", "negative", "at position", "not at position", "at either end", "not at either end", "next to", "not next to", "immediately left of", "somewhere left of", "immediately right of", "somewhere right of"};
  selectClueType.setItems(clueTypes, 0);
  
  selectCategory.setItems(filler, 0);
  selectSubjectA.setItems(filler, 0);
  selectSubjectB.setItems(filler, 0);
  categsugg.setItems(filler, 0);
  optsugg.setItems(filler, 0);
  
  size(800, 600);
 
  noLoop();  // Start without looping to allow user to enter information
}

// Initialization done before solving
void initialize() {  
  steps = 0;
  guesses = 0;
  
  // Reset cell width/height based on potentially new n and m values
  cellWidth = gridWidth/m;
  cellHeight = gridHeight/n;
  
  // Reinitialize all info arrays based on n and m values dictated by user
  optionsPossible = new int[n][m][m];
  prevOptionsPossible = new int[n][m][m];
  initOptionsPossible = new int[n][m][m];
  subjectColumns = new int[n][m];
  prevSubjectColumns = new int[n][m];
  initSubjectColumns = new int[n][m];
  subjectNumPossibilities = new int[n][m];
  prevSubjectNumPossibilities = new int[n][m];
  initSubjectNumPossibilities = new int[n][m];
  cellNumPossibilities = new int[n][m];
  prevCellNumPossibilities = new int[n][m];
  initCellNumPossibilities = new int[n][m];
  
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
      initCellNumPossibilities[i][j] = m;
    }
  }
  
  resetState();
  drawPuzzleGrid();
  saveState();
  
  noLoop();
}

void draw() {
  // Clues list
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
    
    // Display all unfinished clues
    fill(255);
    for (int i = -scrollOffset/clueSpacing; i < numClues - numCluesFinished; i++) {
      Clue cl = initClues.get(i);
      
      cl.display();
      
      if (cluePadding + scrollOffset + clueSpacing * cl.index > height)
        break;
    }
      
    return;  // Early return to prevent puzzle grid from being drawn on top of clues, also prevents noLoop() at end so it can keep drawing
  }
  
  
  // Solving and showing solution
  if (frameCount != 1) {
    if (solved) {  // Valid solution found
      drawPuzzleGrid();
      
      textAlign(CENTER, CENTER);
      fill(0);
      for (int i = 0; i < n; i++) {  // row
        for(int j = 0; j < m; j++) {  // column
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
    
    else {  // No valid solution found
      drawPuzzleGrid();
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      textSize(40);
      text("UNSOLVABLE", width/2, height/2);
    }
    
    resetState();
    saveState();
    
    solved = false;
    noLoop();
  }
}

// Prints solution to console
void printResult() {
  if (solved) {
    for (int i = 0; i < n; i++) {  // row
      print(subjects.get(i).get(0) + "\t\t");  // Prints category at start of each row
      
      for(int j = 0; j < m; j++) {  // column
        int subjIndex = indexInArray(optionsPossible[i][j], 1) + 1;
        if (subjIndex >= subjects.get(i).size())  // Catches same dimension-related errors as in draw()
          print("\t\t");
        else
          print(subjects.get(i).get(subjIndex) + "\t\t");
      }
      print("\n");
    }
    
    println("Logical steps taken:", steps);
    println("Guesses made:", guesses);
  }
  
  else
    println("Puzzle is unsolvable");
    
  loop();
}

// todo: add puzzle class
//todo: if time, add feature for figuring out how many solutions there are

// Draws the background grid (without the solution)
void drawPuzzleGrid() {
  background(0);
  
  strokeWeight(3);
  fill(255);
  rect(gridX1, gridY1, gridWidth, gridHeight);  // Background square of the background grid
  
  textAlign(RIGHT, CENTER);
  textSize(20);
  
  for (int i = 0; i < n; i++) {
    // Horizontal grid lines
    int y = gridY1 + i*cellHeight;
    strokeWeight(1);
    line(gridX1, y, gridX2, y);
    
    // Category name to left of grid
    textSize(min(20, 20 * (gridX1 - 10)/textWidth(subjects.get(i).get(0))));
    text(subjects.get(i).get(0), gridX1 - 5, y + cellHeight/2);
    
    textSize(20);
  }
  
  for (int j = 0; j < m; j++) {
    // Vertical grid lines
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

// Puzzle solving function
void solve() {
  while (true) {
    cluesUsed = false;  // Any progress made by any clue sets this to true (if still false by end of while loop, a guess needs to be made)
    
    for (int i = 0; i < numClues - numCluesFinished; i++) {
      steps += 1;
      Clue cl = clues.get(i);
      cl.process();
      
      //todo: animate printing out grid state instead
      
      if (invalid) {
        revertState();  // Revert to prev state
        invalid = false;
        return;
      }
    }
    
    // Milks the puzzle until truly stuck --> stuck() checks for progress opportunities and acts on them
    while (!stuck()) {}
    
    // Clue checking should only stop if the previous loop didn't see any progress
    if (!cluesUsed)
      break;
  }
  
  // Base Case 1
  if (arrayTotal(cellNumPossibilities) == n*m) {  // Sum of all integers in array
    solved = true;
    return;
  }
  
  // Base Case 2
  if (arrayTotal(cellNumPossibilities) < n*m) {  // If sum of all possible options is less than minimum valid value of n*m, solution must be invalid
    revertState();  // Revert to prev state
    return;
  }
  
  
  saveState(); // Save so that able to return to prev state if guess leads to dead end of invalid solutions
  
  int[] leastOptionsIndices = leastOptionsCellIndices();  // Find square with least number of possible options (but still >= 2 options)
  
  int row = leastOptionsIndices[0];
  int col = leastOptionsIndices[1];
  
  for (int guessIndex = 0; guessIndex < m; guessIndex++) {
    if (optionsPossible[row][col][guessIndex] == 1) {
      guesses += 1;
      setOption(row, col, guessIndex);  // Set cell at [row][col] to option guessed
      
      solve();  // Recursive call
      
      if (solved) {
        return;  // Early return if guess leads to valid solution
      }
      
      // Keep looping through guesses if no valid solution can be found from prior guesses
    }
  }
}
