/* ========================================================= //<>//
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw2(PApplet appc, GWinData data) { //_CODE_:window1:620608:
  appc.background(230);
} //_CODE_:window1:620608:

public void optionfield_change(GTextField source, GEvent event) { //_CODE_:optionfield:899112:
  int start = binarySearch(optSuggestions, optionfield.getText(), 0, optSuggestions.length - 1);  // Start index of suggestions sample
  int end = binarySearch(optSuggestions, optionfield.getText() + "{", 0, optSuggestions.length - 1);  // '{' has ascii 123 vs 'z' ascii 122 (ex: using start marker "ab" and end marker "ab{" would get all words from aba- to abz-)
  
  if (start == end)  // No suggestions starting with the text entered into the textfield
    optsugg.setItems(filler, 0);
  else {
    // Set suggestions drop list to contain all suggestions starting with text entered into textfield, sorted by selection frequency
    String[] suggested = subset(optSuggestions, start, end-start);
    int[] freqs = subset(optFrequency, start, end-start);
    
    insertionSort(freqs, suggested);
    
    optsugg.setItems(suggested, 0);
  }
} //_CODE_:optionfield:899112:

public void optionbutton_click(GButton source, GEvent event) { //_CODE_:optionbutton:609713:
  // Adds an option based on the selected category and text entered into options textfield
  
  int categIndex = int(selectCategory.getSelectedText().substring(0, selectCategory.getSelectedText().indexOf(")"))) - 1;  // Index of selected category (also row number)
  int categOptions = subjects.get(categIndex).size();  // Number of options currently in that category (actually +1 due to the category name taking up index 0)
  
  // If current number of options + 1 category name > m, number of options after adding option will > m as well meaning m (max number of columns) will increase
  if (categOptions > m) {
    m = categOptions;
    positions.add(str(m));
  }
    
  subjects.get(categIndex).add(optionfield.getText());  // Add option name to subjects
  options = addString(options, new int[options.length+1], categIndex + 1 + "." + categOptions + ") " + optionfield.getText());  // Also add option to alpha-sorted options list (call with placeholder int[] to abide by function parameters)
  
  if (indexInArray(optSuggestions, optionfield.getText()) == -1)  // If option is not already in suggestions, expand optFrequency to make room for one more suggestion
    optFrequency = expand(optFrequency, optFrequency.length + 1);
    
  optSuggestions = addString(optSuggestions, optFrequency, optionfield.getText());  // Add new option to suggestions
  
  // Update suggestions in dropdown lists for selecting subject A and B in clue entering section
  int start = binarySearch(options, subjAfield.getText(), 0, options.length - 1);
  int end = binarySearch(options, subjAfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122 (ex: using start marker "ab" and end marker "ab{" would get all words starting with "ab")
  
  if (start == end)  // No words starting with text entered into textfield
    selectSubjectA.setItems(filler, 0);
  else
    selectSubjectA.setItems(subset(options, start, end-start), 0);

  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    selectSubjectB.setItems(positions, 0);  // positions: array containing consecutive numbers from 1 to m
  else {
    // Same process as for subject A related fields/dropdowns
    start = binarySearch(options, subjBfield.getText(), 0, options.length - 1);
    end = binarySearch(options, subjBfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
    
    if (start == end)
      selectSubjectB.setItems(filler, 0);
    else
      selectSubjectB.setItems(subset(options, start, end-start), 0);
    
  }
    
  optionfield.setText("");  // Clear text in options textfield (for convenience)
} //_CODE_:optionbutton:609713:

public void selectCategory_click(GDropList source, GEvent event) { //_CODE_:selectCategory:866543:
  // Does nothing on click, selected text is used in enter option button instead
} //_CODE_:selectCategory:866543:

public void categoryfield_change(GTextField source, GEvent event) { //_CODE_:categoryfield:602102:
  int start = binarySearch(categSuggestions, categoryfield.getText(), 0, categSuggestions.length - 1);
  int end = binarySearch(categSuggestions, categoryfield.getText() + "{", 0, categSuggestions.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    categsugg.setItems(filler, 0);
  else {
    // Set category suggestions drop list to contain sample suggestions sorted by selection frequency
    String[] suggested = subset(categSuggestions, start, end-start);
    int[] freqs = subset(categFrequency, start, end-start);
    
    insertionSort(freqs, suggested);
    
    categsugg.setItems(suggested, 0);
  }
} //_CODE_:categoryfield:602102:

public void categorybutton_click(GButton source, GEvent event) { //_CODE_:categorybutton:627222:
  n += 1;  // n is number of rows, also number of categories, increases every time a category is added
  
  subjects.add(new ArrayList<String>());  // new 'row'
  subjects.get(n-1).add(categoryfield.getText() + ":");  // Add category name into subjects row
  
  categories.add(n + ") " + categoryfield.getText());  // Add to categories array as well
  
  if (indexInArray(categSuggestions, categoryfield.getText()) == -1)  // If category is not already in suggestions, expand categFrequency to make room for one more suggestion
    categFrequency = expand(categFrequency, categFrequency.length + 1);
    
  categSuggestions = addString(categSuggestions, categFrequency, categoryfield.getText());  // Add new category to suggestions
  selectCategory.setItems(categories, 0);  // Update suggestions drop list contents
  
  categoryfield.setText("");  // Don't need to manually delete everything in textfield before entering something new
} //_CODE_:categorybutton:627222:

public void selectSubjectA_click(GDropList source, GEvent event) { //_CODE_:selectSubjectA:321873:
  subjAfield.setText(realWord(selectSubjectA.getSelectedText()));  // Autofill
} //_CODE_:selectSubjectA:321873:

public void selectClueType_click(GDropList source, GEvent event) { //_CODE_:selectClueType:313781:
  // Update subject B selections based on clue type selected
  
  // For at/not at position clues, subject B is integers from 1 to m
  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    selectSubjectB.setItems(positions, 0);
    
  // Otherwise, subject B is subjects starting with whatever letters is entered into the subject B textfield
  else {
    int start = binarySearch(options, subjBfield.getText(), 0, options.length - 1);
    int end = binarySearch(options, subjBfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
    
    if (start == end)
      selectSubjectB.setItems(filler, 0);
    else
      selectSubjectB.setItems(subset(options, start, end-start), 0);
  }
} //_CODE_:selectClueType:313781:

public void selectSubjectB_click(GDropList source, GEvent event) { //_CODE_:selectSubjectB:449193:
  subjBfield.setText(realWord(selectSubjectB.getSelectedText()));  // Autofill
} //_CODE_:selectSubjectB:449193:

public void addClue_click1(GButton source, GEvent event) { //_CODE_:addClue:480002:
  String A = selectSubjectA.getSelectedText();
  String B = selectSubjectB.getSelectedText();
  
  // Start to dot: row index, dot to bracket: assigned subject index based on order entered by user
  int brackIndexA = A.indexOf(")");
  int dotIndexA = A.indexOf(".");
  int brackIndexB = B.indexOf(")");
  int dotIndexB = B.indexOf(".");
  
  // {row index, subject index}
  int[] subjA = new int[]{int(A.substring(0, dotIndexA)) - 1, int(A.substring(dotIndexA + 1, brackIndexA)) - 1};
  int[] subjB;
  
  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    subjB = new int[]{int(B) - 1, -1};  // For position clues, subject B has placeholder -1 at index 1
  else
    subjB = new int[]{int(B.substring(0, dotIndexB)) - 1, int(B.substring(dotIndexB + 1, brackIndexB)) - 1};
    
  // Add to initClues not clues because initClues is what keeps a record of the initial state of the clues
  initClues.add(new Clue(subjA, selectClueType.getSelectedText(), subjB));
  
  // Clear textfields
  subjAfield.setText("");
  subjBfield.setText("");
} //_CODE_:addClue:480002:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:slider1:696747:
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:slider1:696747:

public void toggleSolveMode_clicked(GCheckbox source, GEvent event) { //_CODE_:toggleSolveMode:598382:
  positionMatters = !positionMatters;
} //_CODE_:toggleSolveMode:598382:

public void solveButton_click(GButton source, GEvent event) { //_CODE_:solveButton:982509:
  showClues = false;  // Turn off clues list to show solution
  
  initialize();  // Prepare for solving first

  // When position doesn't matter, subjects of any one row can be set in whatever order when starting the puzzle
  if (!positionMatters) {
    for (int col = 0; col < m; col++)
      setOption(0, col, col);  // col as subject index sets the subjects in whatever order they were entered by the user
  }
  
  solve();  // Find solution (if any)
  loop();  // Initiate looping of draw() to draw solution
  
} //_CODE_:solveButton:982509:

public void checkbox2_clicked1(GCheckbox source, GEvent event) { //_CODE_:checkbox2:596463:
  println("checkbox2 - GCheckbox >> GEvent." + event + " @ " + millis());
} //_CODE_:checkbox2:596463:

public void categsugg_click(GDropList source, GEvent event) { //_CODE_:categsugg:954426:
  // Suggestion autofill
  categoryfield.setText(categsugg.getSelectedText());
} //_CODE_:categsugg:954426:

public void optsugg_click(GDropList source, GEvent event) { //_CODE_:optsugg:668932:
  // Suggestion autofill
  optionfield.setText(optsugg.getSelectedText());
} //_CODE_:optsugg:668932:

public void subjAfield_change(GTextField source, GEvent event) { //_CODE_:subjAfield:305438:
  // Updates subject A droplist based on text entered into subject A textfield
  int start = binarySearch(options, subjAfield.getText(), 0, options.length - 1);
  int end = binarySearch(options, subjAfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    selectSubjectA.setItems(filler, 0);
  else
    selectSubjectA.setItems(subset(options, start, end-start), 0);
} //_CODE_:subjAfield:305438:

public void subjBfield_change(GTextField source, GEvent event) { //_CODE_:subjBfield:531472:
  // Updates subject A droplist based on text entered into subject A textfield
  int start = binarySearch(options, subjBfield.getText(), 0, options.length - 1);
  int end = binarySearch(options, subjBfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    selectSubjectB.setItems(filler, 0);
  else
    selectSubjectB.setItems(subset(options, start, end-start), 0);
} //_CODE_:subjBfield:531472:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  window1 = GWindow.getWindow(this, "Window title", 0, 0, 400, 300, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw2");
  optionfield = new GTextField(window1, 140, 75, 120, 30, G4P.SCROLLBARS_HORIZONTAL_ONLY);
  optionfield.setPromptText("Enter category options");
  optionfield.setOpaque(true);
  optionfield.addEventHandler(this, "optionfield_change");
  optionbutton = new GButton(window1, 270, 75, 44, 21);
  optionbutton.setText("Enter");
  optionbutton.addEventHandler(this, "optionbutton_click");
  selectCategory = new GDropList(window1, 10, 75, 90, 80, 3, 10);
  selectCategory.setItems(loadStrings("list_866543"), 0);
  selectCategory.addEventHandler(this, "selectCategory_click");
  categoryfield = new GTextField(window1, 141, 6, 120, 30, G4P.SCROLLBARS_HORIZONTAL_ONLY);
  categoryfield.setPromptText("Enter category");
  categoryfield.setOpaque(true);
  categoryfield.addEventHandler(this, "categoryfield_change");
  categorybutton = new GButton(window1, 270, 6, 44, 21);
  categorybutton.setText("Enter");
  categorybutton.addEventHandler(this, "categorybutton_click");
  selectSubjectA = new GDropList(window1, 10, 172, 90, 80, 3, 10);
  selectSubjectA.setItems(loadStrings("list_321873"), 0);
  selectSubjectA.addEventHandler(this, "selectSubjectA_click");
  selectClueType = new GDropList(window1, 105, 150, 120, 140, 6, 10);
  selectClueType.setItems(loadStrings("list_313781"), 0);
  selectClueType.addEventHandler(this, "selectClueType_click");
  selectSubjectB = new GDropList(window1, 230, 172, 90, 80, 3, 10);
  selectSubjectB.setItems(loadStrings("list_449193"), 0);
  selectSubjectB.addEventHandler(this, "selectSubjectB_click");
  addClue = new GButton(window1, 330, 150, 60, 21);
  addClue.setText("Add clue");
  addClue.addEventHandler(this, "addClue_click1");
  slider1 = new GSlider(window1, 15, 235, 200, 47, 10.0);
  slider1.setShowValue(true);
  slider1.setLimits(5, 1, 10);
  slider1.setNbrTicks(10);
  slider1.setShowTicks(true);
  slider1.setNumberFormat(G4P.INTEGER, 0);
  slider1.setOpaque(false);
  slider1.addEventHandler(this, "slider1_change1");
  label1 = new GLabel(window1, 15, 220, 100, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Animation Speed");
  label1.setOpaque(false);
  toggleSolveMode = new GCheckbox(window1, 10, 6, 120, 20);
  toggleSolveMode.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  toggleSolveMode.setText("Position Matters");
  toggleSolveMode.setOpaque(false);
  toggleSolveMode.addEventHandler(this, "toggleSolveMode_clicked");
  solveButton = new GButton(window1, 310, 259, 80, 30);
  solveButton.setText("Solve");
  solveButton.addEventHandler(this, "solveButton_click");
  checkbox2 = new GCheckbox(window1, 15, 277, 120, 20);
  checkbox2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkbox2.setText("Show Animation");
  checkbox2.setOpaque(false);
  checkbox2.addEventHandler(this, "checkbox2_clicked1");
  categsugg = new GDropList(window1, 140, 38, 90, 80, 3, 10);
  categsugg.setItems(loadStrings("list_954426"), 0);
  categsugg.addEventHandler(this, "categsugg_click");
  optsugg = new GDropList(window1, 140, 107, 90, 80, 3, 10);
  optsugg.setItems(loadStrings("list_668932"), 0);
  optsugg.addEventHandler(this, "optsugg_click");
  subjAfield = new GTextField(window1, 10, 150, 90, 20, G4P.SCROLLBARS_NONE);
  subjAfield.setOpaque(true);
  subjAfield.addEventHandler(this, "subjAfield_change");
  subjBfield = new GTextField(window1, 230, 150, 90, 20, G4P.SCROLLBARS_NONE);
  subjBfield.setOpaque(true);
  subjBfield.addEventHandler(this, "subjBfield_change");
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GTextField optionfield; 
GButton optionbutton; 
GDropList selectCategory; 
GTextField categoryfield; 
GButton categorybutton; 
GDropList selectSubjectA; 
GDropList selectClueType; 
GDropList selectSubjectB; 
GButton addClue; 
GSlider slider1; 
GLabel label1; 
GCheckbox toggleSolveMode; 
GButton solveButton; 
GCheckbox checkbox2; 
GDropList categsugg; 
GDropList optsugg; 
GTextField subjAfield; 
GTextField subjBfield; 
