class Clue {
  // FIELDS
  int[] subjectA;  // Indices of the first subject based on the order the user entered the subjects
  int[] subjectB;  // Indices of the second subject based on the order the user entered the subjects
  String clueType; // Type of clue (affirmative, negative, next to, somewhere right of, etc.)
  int index;       // Index of clue in clues ArrayList
  Function linkedFunction;
  
  // CONSTRUCTOR
  Clue(int[] a, String ct, int[] b) {
    this.subjectA = a;
    this.subjectB = b;
    this.clueType = ct;
    this.index = numClues;
    
    numClues += 1;
  }
  
  Clue(int[] a, String ct, int[] b, int i) {  // Constructor for copying clues
    this.subjectA = a;
    this.subjectB = b;
    this.clueType = ct;
    this.index = i;
  }
  
  // METHODS
  Clue copyClue() {
    return new Clue(this.subjectA, this.clueType, this.subjectB, this.index);
  }
  
  void display() {
    textAlign(LEFT, TOP);
    textSize(clueSize);
    
    String fullClue = (this.index + 1) + ") " + subjects.get(this.subjectA[0]).get(this.subjectA[1] + 1) + " <" + this.clueType + "> ";
    if (this.subjectB[1] == -1)
      fullClue += "#" + (this.subjectB[0] + 1);
    else if (!(this.clueType.equals("at either end") || this.clueType.equals("not at either end")))
      fullClue += subjects.get(this.subjectB[0]).get(this.subjectB[1] + 1);
        
    text(fullClue, cluePadding, cluePadding + scrollOffset + clueSpacing * this.index);
  }
  
  void hide() {
    Clue c = clues.get(numClues - 1 - numCluesFinished);
    println(c.clueType, numClues - 1 - numCluesFinished);
    
    // Replace clue to hide with last clue in list
    c.index = this.index;
    clues.set(this.index, c);
    println(clues.get(this.index).clueType, this.index);
    numCluesFinished += 1;
    cluesUsed = true;
  }
  
  
  void process() {
    if (!positionMatters) {
      if (!(this.clueType.equals("affirmative") || this.clueType.equals("negative"))) {
        this.hide();
        return;
      }
    }
    
    if (this.clueType.equals("affirmative"))
      affirmative(this, this.subjectA, this.subjectB);
    else if (this.clueType.equals("negative"))
      negative(this, this.subjectA, this.subjectB);
    else if (this.clueType.equals("at position"))
      atPosition(this, this.subjectA, this.subjectB, 1);
    else if (this.clueType.equals("not at position"))
      atPosition(this, this.subjectA, this.subjectB, 0);
    else if (this.clueType.equals("at either end"))
      atEitherEnd(this, this.subjectA, 1);
    else if (this.clueType.equals("not at either end"))
      atEitherEnd(this, this.subjectA, 0);
    else if (this.clueType.equals("next to"))
      nextTo(this, this.subjectA, this.subjectB, 1);
    else if (this.clueType.equals("not next to"))
      nextTo(this, this.subjectA, this.subjectB, 0);
    else if (this.clueType.equals("immediately left of"))
      leftOf(this, this.subjectA, this.subjectB, 0);
    else if (this.clueType.equals("somewhere left of"))
      leftOf(this, this.subjectA, this.subjectB, 1);
    else if (this.clueType.equals("immediately right of"))
      rightOf(this, this.subjectA, this.subjectB, 0);
    else if (this.clueType.equals("somewhere right of"))
      rightOf(this, this.subjectA, this.subjectB, 1);
  }
}
