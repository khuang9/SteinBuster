boolean showClues = false;
int cluePadding = 10;
int clueSize = 15;
int clueSpacing = 25;

int scrollOffset = 0;
int scrollSpeed = 15;

float listLength() {
  return clueSpacing*(numClues - 1) + clueSize + 2*cluePadding;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    showClues = !showClues;
    
    if (showClues)
      loop();
    else {
      noLoop();
      drawPuzzleGrid();
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (!showClues)
    return;
    
  int direction = event.getCount();
  
  if (scrollOffset - direction*scrollSpeed >= 0)
    scrollOffset = 0;
  else if (-(scrollOffset - direction*scrollSpeed) + height >= listLength())
    scrollOffset = min(0, (int) -(listLength() - height));
  else
    scrollOffset -= direction * scrollSpeed;
}
