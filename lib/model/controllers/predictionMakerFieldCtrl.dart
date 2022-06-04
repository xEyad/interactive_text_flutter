// ignore_for_file: curly_braces_in_flow_control_structures

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
    if(!_canUpdateText) return;

    final currentText = textCtrl.text;    
    //check if the user is typing or removing
    final bool hasUserTypedNewWord = previousText.trim().split(' ').length < currentText.trim().split(' ').length;
    final bool hasUserRemovedWord = previousText.trim().split(' ').length > currentText.trim().split(' ').length;
    final bool hasUserTypedNewChar = currentText.length > previousText.length;
    final bool hasUserRemovedChar = currentText.length < previousText.length;
    final bool isLastWordATrigger = getPredictionWordObj(currentText.trim().split(' ').last) !=null;

    final newSentence = currentText.trim().split(' ');
    //generate new concrete sentence
    final List<ConcreteWord> newConcreteSentence = [];
    for (var element in newSentence) {
      final predictionObj =  getPredictionWordObj(element);
      if(predictionObj!=null)
        newConcreteSentence.add(ConcreteWord(predictionObj)); 
    }

    final curSentence = sentence;
    
    //changing in this case is wrong, cause it will be detected as replacement
    if(newConcreteSentence.length == curSentence.length) return;

    //compare it with current sentence to determine changed item
    int? changeIndex;
    for (var i = 0; i < newConcreteSentence.length; i++) 
    {
      if(i>=curSentence.length)
      {
        changeIndex = i;
        break;
      }

      final newWord = newConcreteSentence[i];
      final curWord = (curSentence[i] as ConcreteTextItem).word;
      if(curWord.predictionItem.trigger != newWord.predictionItem.trigger)
      {
        changeIndex = i;
        break;
      }      
    }
    
    if(hasUserRemovedChar && newConcreteSentence.length < curSentence.length && changeIndex == null)
      changeIndex = curSentence.length - 1;
    


    //act on changed index whether it is insertion removal
    if(newConcreteSentence.isEmpty && curSentence.isNotEmpty)
    {
      curSentence.clear();
      notifyListeners();
    }
    else if(newConcreteSentence.length > curSentence.length)
    {
      curSentence.insert(changeIndex!, ConcreteTextItem(newConcreteSentence[changeIndex]));
      notifyListeners();
    }
    else if(newConcreteSentence.length < curSentence.length)
    {
      curSentence.removeAt(changeIndex!);
      notifyListeners();
    }

    /*
    test cases:
    add to end
    remove from end
    add (space) to start
    add item to staret
    remove space from center
    remove item from center
     */
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
  
  String get text;
}

class ConcreteTextItem extends TextItem
{
  ConcreteWord word;
  ConcreteTextItem(this.word);
  @override
  String get text => word.predictionItem.trigger;
}

class NormalTextItem extends TextItem
{
  String word;
  NormalTextItem(this.word);

  @override
  String get text => word;
}


