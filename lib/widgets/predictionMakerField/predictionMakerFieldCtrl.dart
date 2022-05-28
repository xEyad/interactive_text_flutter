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
    _canUpdateText = !_canUpdateText;
    print('${titleCtrl.text} set text updates is working to: $_canUpdateText');
  }

  void textListener()
  {
    if(!_canUpdateText) return;
    updateSentence();
    notifyListeners();
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

    // sentence.clear();
    // for (var word in currentText.split(' ')) {
    //   final predictionObj =  getPredictionWordObj(word);
    //   if(predictionObj!=null)
    //     sentence.add(ConcreteTextItem(ConcreteWord(predictionObj))); 
    //   else
    //     sentence.add(NormalTextItem(word));
    // }
    // notifyListeners();
    
    //check if the user is typing or removing
    final bool hasUserTypedNewWord = previousText.trim().split(' ').length < currentText.trim().split(' ').length;
    final bool hasUserRemovedWord = previousText.trim().split(' ').length > currentText.trim().split(' ').length;
    final bool hasUserTypedNewChar = currentText.length > previousText.length;
    final bool hasUserRemovedChar = currentText.length < previousText.length;
    final bool isLastWordATrigger = getPredictionWordObj(currentText.trim().split(' ').last) !=null;
    if(hasUserTypedNewWord || (isLastWordATrigger && hasUserTypedNewChar))
    {
      final newWord = currentText.split(' ').last;
      final predictionObj =  getPredictionWordObj(newWord);
      if(predictionObj!=null)
      {
        sentence.add(ConcreteTextItem(ConcreteWord(predictionObj))); 
        notifyListeners();
      }
    }
    else if(hasUserRemovedWord || hasUserRemovedChar)
    {
      final removedWord = previousText.split(' ').last;
      final predictionObj =  getPredictionWordObj(removedWord);
      if(predictionObj!=null)
      {
        sentence.remove(sentence.last); 
        notifyListeners();
      }
    }

    //update prev text
    previousText = textCtrl.text;
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


