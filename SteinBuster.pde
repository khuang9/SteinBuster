ArrayList<Clue> clues = new ArrayList<Clue>();
int numClues = 0;

boolean invalid = false;//invalid reset to false every time a new guess is made
//check if invalid after every clue process, if so, break

// Blank template class which will be used to store specific functions in a general object
class Function {
  void call() {}
}
// binary search, insertion sort for category/option suggestions
void setup() {
  
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
    atEitherEnd(subjA, subjB, 1);
  else if (ct.equals("not at either end"))
    atEitherEnd(subjA, subjB, 0);
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
