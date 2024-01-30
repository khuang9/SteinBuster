boolean alphabeticallyInFront(String word, String comparedTo) {
  int minLength = min(word.length(), comparedTo.length());
  for (int letter = 0; letter < minLength; letter++) {
    if (int(word.charAt(letter)) < int(comparedTo.charAt(letter)))
      return true;
    else if (int(word.charAt(letter)) > int(comparedTo.charAt(letter)))
      return false;
  }
  
  return word.length() <= comparedTo.length();
}


int binarySearch(String[] arr, String word, int start, int end) {
  word = trim(word);
  
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
    return binarySearch(arr, word, start, mid - 1);
  else
    return binarySearch(arr, word, mid + 1, end);
}


void insertionSort(int[] arr, String[] linkedArr) {
  for (int i = 1; i < arr.length; i++) {
    int c = i;
    
    while (c > 0 && arr[c] > arr[c-1]) {
      swap(arr, c, c-1);
      swap(linkedArr, c, c-1);
      c -= 1;
    }
  }
}

void swap(int[] arr, int i1, int i2) {
  int temp = arr[i1];
  arr[i1] = arr[i2];
  arr[i2] = temp;
}

void swap(String[] arr, int i1, int i2) {
  String temp = arr[i1];
  arr[i1] = arr[i2];
  arr[i2] = temp;
}
