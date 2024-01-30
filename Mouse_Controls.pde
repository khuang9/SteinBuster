// Clues list related variables
boolean showClues = false;
int cluePadding = 10;
int clueSize = 15;
int clueSpacing = 25;

int scrollOffset = 0;
int scrollSpeed = 15;

// Vertical length of entire clues list in pixels
float listLength() {
  return clueSpacing*(numClues - 1) + clueSize + 2*cluePadding;
}

void mousePressed() {
  // Right Mouse Button toggles clues list
  if (mouseButton == RIGHT) {
    showClues = !showClues;
    
    if (showClues)
      loop();  // Turning on initiates draw() looping
    else {
      noLoop();
      drawPuzzleGrid();  // Turning off stops looping and redraws background grid
    }
  }
}

void mouseWheel(MouseEvent event) {
  // Scrolling has no effect if clues not showing
  if (!showClues)
    return;
  
  int direction = event.getCount();  // Up/down scroll
  
  if (scrollOffset - direction*scrollSpeed >= 0)  // Top of clues list will not go below top of screen
    scrollOffset = 0;
  else if (-(scrollOffset - direction*scrollSpeed) + height >= listLength())  // Bottom of clues list will not go above bottom of screen (except if list is short enough to fit on screen)
    scrollOffset = min(0, (int) -(listLength() - height));
  else
    scrollOffset -= direction * scrollSpeed;
}
