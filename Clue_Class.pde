class Clue {
  // FIELDS
  int[] subjectA;  // Indices of the first subject based on the order the user entered the subjects
  int[] subjectB;  // Indices of the second subject based on the order the user entered the subjects
  String clueType; // Type of clue (affirmative, negative, next to, somewhere right of, etc.)
  int index;       // Index of clue in clues ArrayList
  
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
  // Manually copies clues so that clues in clues, prevClues, and initClues aren't linked
  Clue copyClue() {
    return new Clue(this.subjectA, this.clueType, this.subjectB, this.index);
  }
  
  // Draws clue to screen
  void display() {
    textAlign(LEFT, TOP);
    textSize(clueSize);
    
    String fullClue = (this.index + 1) + ") " + subjects.get(this.subjectA[0]).get(this.subjectA[1] + 1) + " <" + this.clueType + "> ";  // Same first half for all three main forms of clues
    
    if (this.subjectB[1] == -1)
      fullClue += "#" + (this.subjectB[0] + 1);  // At/not at certain position
    else if (!(this.clueType.equals("at either end") || this.clueType.equals("not at either end")))  // At/not at either end only needs first half
      fullClue += subjects.get(this.subjectB[0]).get(this.subjectB[1] + 1);
        
    text(fullClue, cluePadding, cluePadding + scrollOffset + clueSpacing * this.index);  // Draw at position determined by padding, scrolling, line spacing and index in clues array
  }
  //todo: move solve() out of draw()
  // Discards clue from examination process
  void hide() {
    // Last unfinished clue in list
    Clue c = clues.get(numClues - 1 - numCluesFinished);
    
    // Replace clue with last unfinished clue in list
    c.index = this.index;
    clues.set(this.index, c);
    
    numCluesFinished += 1;
    cluesUsed = true;
  }
  
  // Calls appropriate logic function based on clue type
  void process() {
    if (!positionMatters) {
      // Skip positional clues is position doesn't matter
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
