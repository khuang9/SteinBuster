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
    
    
    clues.add(this);
    numClues += 1;
  }
  
  // METHODS
  void hide() {
    numCluesFinished += 1;
    
    Clue c = clues.get(numClues - 1 - numCluesFinished);
    
    // Replace clue to hide with last clue in list
    c.index = this.index;
    clues.set(this.index, c);
    
    // Remove last clue in list
    //clues.remove(numClues - 1);
  }
  
  //void linkFunction() {
  //  String ct = this.clueType;
  //  final int[] subjA = this.subjectA;
  //  final int[] subjB = this.subjectB;
    
  //  if (ct.equals("affirmative")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        affirmative(subjA, subjB);
  //      }
  //    };
  //  }
      
  //  else if (ct.equals("negative")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        negative(subjA, subjB);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("at position")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        atPosition(subjA, subjB, 1);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("not at position")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        atPosition(subjA, subjB, 0);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("at either end")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        atEitherEnd(subjA, subjB, 1);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("not at either end")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        atEitherEnd(subjA, subjB, 0);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("next to")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        nextTo(subjA, subjB, 1);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("not next to")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        nextTo(subjA, subjB, 0);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("immediately left of")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        leftOf(subjA, subjB, 0);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("somewhere left of")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        leftOf(subjA, subjB, 1);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("immediately right of")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        rightOf(subjA, subjB, 0);
  //      }
  //    };
  //  }
    
  //  else if (ct.equals("somewhere right of")) {
  //    this.linkedFunction = new Function() {
  //      public void call() {
  //        rightOf(subjA, subjB, 1);
  //      }
  //    };
  //  }
    
  //}
}
