class Util
{
  ///-1 means no change
  ///this function detects change based only in difference of 1, which means adding or removing 1 char only
  static int getChangeIndex(String oldStr, String newStr)
  {
    // assert((oldStr.length-newStr.length).abs() == 1);
    if(newStr.length > oldStr.length) //insertion
    {
      if(oldStr.isEmpty) return 0;

      for (var i = oldStr.length-1; i >= 0; i--) 
      {
        final oldChar = oldStr[i];
        final newChar = newStr[i+1];
        final isOldCharShifted = oldChar == newChar;
        if(!isOldCharShifted)      
          return i+1; //change detected

        if(isOldCharShifted && i==0) //this means insertion is the first character
          return 0;
      }
    }
    else if(newStr.length < oldStr.length) //deletion
    {
      for (var i = oldStr.length-1; i >= 0; i--) 
      {      
        if(i==0)
          return 0; //this means that first character is deleted
        final oldChar = oldStr[i];
        final newChar = newStr[i-1];
        final isOldCharShifted = oldChar == newChar;
        if(!isOldCharShifted)      
          return i; //change detected
      }
    }
    else //same
    {
      return -1;
    }

    throw 'Unexpected error!';
  }

  ///assumes you are giving this function a [split] text and a wordIndex inside it
  ///Example: final words = text.split(' ');
  static int getStartingIndex(List<String> words,int wordIndex)
  {
    assert(wordIndex < words.length);

    int charsCounted = 0;
    if(wordIndex == 0) return charsCounted;


    for (var i = 0; i < wordIndex; i++) 
    {
      final word = words[i];
      charsCounted += word.length;
      charsCounted += 1; //every word means a space (separator char)
    }
    // charsCounted += 1; //last zspace (separator char)

    return charsCounted;
  }
}