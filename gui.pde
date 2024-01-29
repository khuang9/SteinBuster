/* =========================================================
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

public void optionfield_change1(GTextField source, GEvent event) { //_CODE_:optionfield:899112:
  println("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
  
  int start = binarySearch(optSuggestions, optionfield.getText(), 0, optSuggestions.length - 1);
  int end = binarySearch(optSuggestions, optionfield.getText() + "{", 0, optSuggestions.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    optsugg.setItems(filler, 0);
  else
    optsugg.setItems(subset(optSuggestions, start, end-start), 0);
} //_CODE_:optionfield:899112:

public void optionbutton_click1(GButton source, GEvent event) { //_CODE_:optionbutton:609713:
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  int categIndex = int(selectCategory.getSelectedText().substring(0, selectCategory.getSelectedText().indexOf(")"))) - 1;
  println(selectCategory.getSelectedText(), categIndex);
  int categOptions = subjects.get(categIndex).size();
  if (categOptions > m) {
    m = categOptions;
    positions.add(str(m));
  }
    
  subjects.get(categIndex).add(optionfield.getText());
  //options.add(categIndex + 1 + "." + categOptions + ") " + optionfield.getText());
  options = addString(options, categIndex + 1 + "." + categOptions + ") " + optionfield.getText());
  optSuggestions = addString(optSuggestions, optionfield.getText());
  
  

  int start = binarySearch(options, subjAfield.getText(), 0, options.length - 1);
  int end = binarySearch(options, subjAfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    selectSubjectA.setItems(filler, 0);
  else
    selectSubjectA.setItems(subset(options, start, end-start), 0);

  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    selectSubjectB.setItems(positions, 0);
  else {
    start = binarySearch(options, subjBfield.getText(), 0, options.length - 1);
    end = binarySearch(options, subjBfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
    
    if (start == end)
      selectSubjectB.setItems(filler, 0);
    else
      selectSubjectB.setItems(subset(options, start, end-start), 0);
    
  }
    
  optionfield.setText("");
} //_CODE_:optionbutton:609713:

public void categories_click(GDropList source, GEvent event) { //_CODE_:selectCategory:866543:
  println("categories - GDropList >> GEvent." + event + " @ " + millis());
} //_CODE_:selectCategory:866543:

public void categoryfield_change1(GTextField source, GEvent event) { //_CODE_:categoryfield:602102:
  println("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
  
  int start = binarySearch(categSuggestions, categoryfield.getText(), 0, categSuggestions.length - 1);
  int end = binarySearch(categSuggestions, categoryfield.getText() + "{", 0, categSuggestions.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    categsugg.setItems(filler, 0);
  else
    categsugg.setItems(subset(categSuggestions, start, end-start), 0);
} //_CODE_:categoryfield:602102:

public void categorybutton_click1(GButton source, GEvent event) { //_CODE_:categorybutton:627222:
  println("button2 - GButton >> GEvent." + event + " @ " + millis());
  n += 1;
  
  subjects.add(new ArrayList<String>());
  subjects.get(n-1).add(categoryfield.getText() + ":");
  
  categories.add(n + ") " + categoryfield.getText());
  categSuggestions = addString(categSuggestions, categoryfield.getText());
  selectCategory.setItems(categories, 0);
  
  categoryfield.setText("");
} //_CODE_:categorybutton:627222:

public void selectSubjectA_click(GDropList source, GEvent event) { //_CODE_:selectSubjectA:321873:
  println("selectSubjectA - GDropList >> GEvent." + event + " @ " + millis());
  
  subjAfield.setText(realWord(selectSubjectA.getSelectedText()));
} //_CODE_:selectSubjectA:321873:

public void selectClueType_click(GDropList source, GEvent event) { //_CODE_:selectClueType:313781:
  println("selectClueType - GDropList >> GEvent." + event + " @ " + millis());
  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    selectSubjectB.setItems(positions, 0);
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
  println("selectSubjectB - GDropList >> GEvent." + event + " @ " + millis());
  
  subjBfield.setText(realWord(selectSubjectB.getSelectedText()));
} //_CODE_:selectSubjectB:449193:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:480002:
  println("button3 - GButton >> GEvent." + event + " @ " + millis());
  String A = selectSubjectA.getSelectedText();
  String B = selectSubjectB.getSelectedText();
  
  int brackIndexA = A.indexOf(")");
  int dotIndexA = A.indexOf(".");
  int brackIndexB = B.indexOf(")");
  int dotIndexB = B.indexOf(".");
  
  int[] subjA = new int[]{int(A.substring(0, dotIndexA)) - 1, int(A.substring(dotIndexA + 1, brackIndexA)) - 1};
  int[] subjB;
  
  if (selectClueType.getSelectedText().equals("at position") || selectClueType.getSelectedText().equals("not at position"))
    subjB = new int[]{int(B) - 1, -1};
  else
    subjB = new int[]{int(B.substring(0, dotIndexB)) - 1, int(B.substring(dotIndexB + 1, brackIndexB)) - 1};
    
  initClues.add(new Clue(subjA, selectClueType.getSelectedText(), subjB));
  
  subjAfield.setText("");
  subjBfield.setText("");
} //_CODE_:button3:480002:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:slider1:696747:
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:slider1:696747:

public void checkbox1_clicked1(GCheckbox source, GEvent event) { //_CODE_:checkbox1:598382:
  println("checkbox1 - GCheckbox >> GEvent." + event + " @ " + millis());
  positionMatters = !positionMatters;
} //_CODE_:checkbox1:598382:

public void button4_click1(GButton source, GEvent event) { //_CODE_:button4:982509:
  println("button4 - GButton >> GEvent." + event + " @ " + millis());
  showClues = false;
  
  initialize();
  
  checks = 0;
  guesses = 0;
  
  if (!positionMatters) {
    for (int col = 0; col < m; col++)
      setOption(0, col, col);
  }
  //keyCode = ENTER;
  //keyPressed();
  //solve();
  loop();
  //printResult();
  
} //_CODE_:button4:982509:

public void checkbox2_clicked1(GCheckbox source, GEvent event) { //_CODE_:checkbox2:596463:
  println("checkbox2 - GCheckbox >> GEvent." + event + " @ " + millis());
} //_CODE_:checkbox2:596463:

public void gridupdate_click1(GButton source, GEvent event) { //_CODE_:gridupdate:652888:
  println("gridupdate - GButton >> GEvent." + event + " @ " + millis());
  initialize();
} //_CODE_:gridupdate:652888:

public void categsugg_click3(GDropList source, GEvent event) { //_CODE_:categsugg:954426:
  println("categsugg - GDropList >> GEvent." + event + " @ " + millis());
  
  categoryfield.setText(categsugg.getSelectedText());
  println("A");
} //_CODE_:categsugg:954426:

public void optsugg_click3(GDropList source, GEvent event) { //_CODE_:optsugg:668932:
  println("optsugg - GDropList >> GEvent." + event + " @ " + millis());
  
  optionfield.setText(optsugg.getSelectedText());
} //_CODE_:optsugg:668932:

public void subjAfield_change1(GTextField source, GEvent event) { //_CODE_:subjAfield:305438:
  println("subjAfield - GTextField >> GEvent." + event + " @ " + millis());

  int start = binarySearch(options, subjAfield.getText(), 0, options.length - 1);
  int end = binarySearch(options, subjAfield.getText() + "{", 0, options.length - 1);  // '{' has ascii 123 vs 'z' ascii 122
  
  if (start == end)
    selectSubjectA.setItems(filler, 0);
  else
    selectSubjectA.setItems(subset(options, start, end-start), 0);
} //_CODE_:subjAfield:305438:

public void subjBfield_change1(GTextField source, GEvent event) { //_CODE_:subjBfield:531472:
  println("subjBfield - GTextField >> GEvent." + event + " @ " + millis());

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
  optionfield.addEventHandler(this, "optionfield_change1");
  optionbutton = new GButton(window1, 270, 75, 44, 21);
  optionbutton.setText("Enter");
  optionbutton.addEventHandler(this, "optionbutton_click1");
  selectCategory = new GDropList(window1, 10, 75, 90, 80, 3, 10);
  selectCategory.setItems(loadStrings("list_866543"), 0);
  selectCategory.addEventHandler(this, "categories_click");
  categoryfield = new GTextField(window1, 140, 6, 120, 30, G4P.SCROLLBARS_HORIZONTAL_ONLY);
  categoryfield.setPromptText("Enter category");
  categoryfield.setOpaque(true);
  categoryfield.addEventHandler(this, "categoryfield_change1");
  categorybutton = new GButton(window1, 270, 6, 44, 21);
  categorybutton.setText("Enter");
  categorybutton.addEventHandler(this, "categorybutton_click1");
  selectSubjectA = new GDropList(window1, 10, 172, 90, 80, 3, 10);
  selectSubjectA.setItems(loadStrings("list_321873"), 0);
  selectSubjectA.addEventHandler(this, "selectSubjectA_click");
  selectClueType = new GDropList(window1, 105, 150, 120, 140, 6, 10);
  selectClueType.setItems(loadStrings("list_313781"), 0);
  selectClueType.addEventHandler(this, "selectClueType_click");
  selectSubjectB = new GDropList(window1, 230, 172, 90, 80, 3, 10);
  selectSubjectB.setItems(loadStrings("list_449193"), 0);
  selectSubjectB.addEventHandler(this, "selectSubjectB_click");
  button3 = new GButton(window1, 330, 150, 60, 21);
  button3.setText("Add clue");
  button3.addEventHandler(this, "button3_click1");
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
  checkbox1 = new GCheckbox(window1, 10, 6, 120, 20);
  checkbox1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkbox1.setText("Position Matters");
  checkbox1.setOpaque(false);
  checkbox1.addEventHandler(this, "checkbox1_clicked1");
  button4 = new GButton(window1, 310, 259, 80, 30);
  button4.setText("Solve");
  button4.addEventHandler(this, "button4_click1");
  checkbox2 = new GCheckbox(window1, 15, 277, 120, 20);
  checkbox2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkbox2.setText("Show Animation");
  checkbox2.setOpaque(false);
  checkbox2.addEventHandler(this, "checkbox2_clicked1");
  gridupdate = new GButton(window1, 310, 219, 80, 30);
  gridupdate.setText("Update Puzzle");
  gridupdate.addEventHandler(this, "gridupdate_click1");
  categsugg = new GDropList(window1, 140, 38, 90, 80, 3, 10);
  categsugg.setItems(loadStrings("list_954426"), 0);
  categsugg.addEventHandler(this, "categsugg_click3");
  optsugg = new GDropList(window1, 140, 107, 90, 80, 3, 10);
  optsugg.setItems(loadStrings("list_668932"), 0);
  optsugg.addEventHandler(this, "optsugg_click3");
  subjAfield = new GTextField(window1, 10, 150, 90, 20, G4P.SCROLLBARS_NONE);
  subjAfield.setOpaque(true);
  subjAfield.addEventHandler(this, "subjAfield_change1");
  subjBfield = new GTextField(window1, 230, 150, 90, 20, G4P.SCROLLBARS_NONE);
  subjBfield.setOpaque(true);
  subjBfield.addEventHandler(this, "subjBfield_change1");
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
GButton button3; 
GSlider slider1; 
GLabel label1; 
GCheckbox checkbox1; 
GButton button4; 
GCheckbox checkbox2; 
GButton gridupdate; 
GDropList categsugg; 
GDropList optsugg; 
GTextField subjAfield; 
GTextField subjBfield; 
