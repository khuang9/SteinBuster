// Determines whether a word is alphabetically in front of another word
boolean alphabeticallyInFront(String word, String comparedTo) {
  int minLength = min(word.length(), comparedTo.length());
  
  // Compares ascii values of letters in both words (if at any point a word's char ascii value at a certain index is less than another word's char ascii value at the same index, that word is in front alphabetically)
  for (int letter = 0; letter < minLength; letter++) {
    if (int(word.charAt(letter)) < int(comparedTo.charAt(letter)))
      return true;
    else if (int(word.charAt(letter)) > int(comparedTo.charAt(letter)))
      return false;
  }
  
  return word.length() <= comparedTo.length();  // If both words are exactly the same up to minLength, the one in front is the shorter one
}

// Finds the index where a given word should go in a sorted list
int binarySearch(String[] arr, String word, int start, int end) {
  word = trim(word).toLowerCase();  // Trims off spaces and converts to entirely lowercase to prevent unwanted errors in alphabetical order
  
  // Base Case
  if (start >= end) {
    if (end == -1)
      return 0;
    else if (alphabeticallyInFront(word, realWord(arr[end])))
      return end;
    else
      return end + 1;
  }
  
  
  int mid = (start + end)/2;
  
  if (word.equals(realWord(arr[mid])))
    return mid;
  else if (alphabeticallyInFront(word, realWord(arr[mid])))
    return binarySearch(arr, word, start, mid - 1);  // Recersive call
  else
    return binarySearch(arr, word, mid + 1, end);  // Recursive call
}


// Sorts suggestions based on their selection frequencies (from largest to smallest)
void insertionSort(int[] arr, String[] linkedArr) {
  for (int i = 1; i < arr.length; i++) {  // Loop through list values starting from second
    int c = i;
    
    while (c > 0 && arr[c] > arr[c-1]) {  // Swap value with one before as long as it is larger
      swap(arr, c, c-1);
      swap(linkedArr, c, c-1);
      c -= 1;
    }
  }
}

// Swaps values at provided indices in int[] array
void swap(int[] arr, int i1, int i2) {
  int temp = arr[i1];
  arr[i1] = arr[i2];
  arr[i2] = temp;
}

// Same function but for String[] array
void swap(String[] arr, int i1, int i2) {
  String temp = arr[i1];
  arr[i1] = arr[i2];
  arr[i2] = temp;
}
