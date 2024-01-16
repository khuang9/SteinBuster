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
    
    clues.add(this);
    numClues += 1;
  }
  
  // METHODS
  void hide() {
    Clue c = clues.get(numClues - 1);
    
    // Replace clue to hide with last clue in list
    c.index = this.index;
    clues.set(this.index, c);
    
    // Remove last clue in list
    clues.remove(numClues - 1);
  }
}
