
// ignore_for_file: avoid_function_literals_in_foreach_calls

part of prediction_maker_field;

class PredictionMakerFieldController extends ChangeNotifier 
{
  ///Sentence data will be read from that controller
  final TextEditingController _textCtrl = TextEditingController();
  TextEditingController get textCtrl => _textCtrl;
  final String? initialTitle;
  final List<PredictionItem> predictionList;
  final int id;
  late final TextEditingController titleCtrl;
  List<TextItem> get sentence => _sentence;
  final List<TextItem> _sentence = [];
  bool _canUpdateText = true;
  String previousText = "";

  PredictionMakerFieldController({this.predictionList = const [], this.initialTitle,  })
  :
  id = DateTime.now().microsecondsSinceEpoch  
  {
    titleCtrl = TextEditingController(text: initialTitle);
    textCtrl.addListener(textListener);
  }
  
  PredictionItem predictionItem()
  {
    return PredictionItem(suggestions: [], trigger: titleCtrl.text);
  }


  void toggleTextUpdates()
  {
    // _canUpdateText = !_canUpdateText;
    print('${titleCtrl.text} set text updates is working to: $_canUpdateText');
  }

  void textListener()
  {
    if(!_canUpdateText) return;

    if(previousText==textCtrl.text) return;
    updateSentence();
    notifyListeners();
    previousText = textCtrl.text;
  }

  ///if null is returned, then it means no match found
  PredictionItem? getPredictionWordObj(String word)
  {
    for (var item in predictionList) 
    {
      if(item.trigger == word)
      {
        return item;
      }
    }
    return null;
  }

  void partiallyUpdateSentence(TextItem newWord,int indexInSentence)
  {
    if(!_canUpdateText) return;
    sentence[indexInSentence] = newWord;
    notifyListeners();
  }

  void updateSentence()
  {
    final currentText = textCtrl.text;  
      
    if(!_canUpdateText) return;
    if((previousText.length-currentText.length).abs() != 1) return;

    int changeIndex = Util.getChangeIndex(previousText, currentText);
    bool isInsertion = currentText.length > previousText.length;
    bool isDeletion = currentText.length < previousText.length;

    //check if this affects existing words, basically if the new char is inserted/removed directly inside an existing word
    final affectedWord = findWordAt(changeIndex);
    if(affectedWord!=null) sentence.remove(affectedWord);

    //update location of existing words
    if(isInsertion)
    {
      //shift all words to right after the change location    
      final wordsAfterIndex = sentence.where((txtItem) => txtItem.startIndex >= changeIndex).toList();
      wordsAfterIndex.forEach((txtItem) => txtItem.startIndex++);
    }
    else if(isDeletion)
    {
      //shift all words to left after the change location    
      final wordsAfterIndex = sentence.where((txtItem) => txtItem.startIndex >= changeIndex).toList();
      wordsAfterIndex.forEach((txtItem) => txtItem.startIndex--);
    }

    if(isDeletion || isInsertion)
      registerNewWords(currentText.trim());

    notifyListeners();
  }
  
  ///ONLY adds new words to the sentence
  void registerNewWords(String text)
  {
    final newSentence = text.split(' ');
    for (var i = 0; i < newSentence.length; i++) 
    {
      final word = newSentence[i];
      final predictionObj = getPredictionWordObj(word);
      if(predictionObj!=null)
      {
        final locationInCurrentText = Util.getStartingIndex(newSentence, i);
        final isWordAlreadyExists = findWordAt(locationInCurrentText)!=null;
        if(isWordAlreadyExists) continue;

        final newTxtItem = ConcreteTextItem(ConcreteWord(predictionObj),location: locationInCurrentText);
        sentence.add(newTxtItem);//INSERT AT CORRECT location, sort by start index
        sentence.sort((t1,t2)=>t1.startIndex-t2.startIndex);
      }
    }
  }

  ///index inside previousString
  TextItem? findWordAt(int index)
  {
    try{
      return sentence.firstWhere((txtItem) => txtItem.isInside(index));
    }
    catch(e) {return null;}
  }
    
  @override
  void dispose()
  {
    textCtrl.removeListener(textListener);
    super.dispose();
  }
  
  @override
  bool operator ==(Object other) =>
      other is PredictionMakerFieldController &&
      other.runtimeType == runtimeType &&
      other.id == id;

  @override
  int get hashCode => id;

}

abstract class TextItem
{
  ///location of first char in this word INSIDE the string it was in
  int startIndex;
  ///location of last char in this word INSIDE the string it was in
  int get endIndex => startIndex + (length-1);
  String get text;
  int get length => text.length;
  bool isInside(int index) => index>=startIndex && index <= endIndex;
  TextItem({required this.startIndex});

  @override
  bool operator ==(Object other) =>
      other is TextItem &&
      other.runtimeType == runtimeType &&
      other.startIndex == startIndex && 
      other.endIndex == endIndex && 
      other.text == text && 
      other.length == length 
      ;

  @override
  int get hashCode => startIndex+endIndex+text.length;
}

class ConcreteTextItem extends TextItem
{
  ConcreteWord word;

  ///[location] in text string 
  ConcreteTextItem(this.word,{required int location}):super(startIndex: location);
  @override
  String get text => word.predictionItem.trigger;
}

class NormalTextItem extends TextItem
{
  String word;
  NormalTextItem(this.word,{required int location}):super(startIndex: location);

  @override
  String get text => word;
}


