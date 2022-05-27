// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/model/concreteWord.dart';
import 'package:interactive_text/widgets/predictionWord.dart';

class PreviewPrediction extends StatefulWidget {
  final List<PredictionItem> predictionList;
  ///this function runs whenever user selects option from prediction item
  final void Function(List<ConcreteWord> word)? onSentenceUpdated;
  ///Sentence data will be read from that controller
  final TextEditingController sentenceCtrl;
  final List<ConcreteWord>? initialSentence;
  const PreviewPrediction({Key? key, required this.predictionList, required this.sentenceCtrl, this.onSentenceUpdated, this.initialSentence}) : super(key: key);

  @override
  State<PreviewPrediction> createState() => _PreviewPredictionState();
}

class _PreviewPredictionState extends State<PreviewPrediction> {
  
  List<PredictionItem> get predictionList => widget.predictionList;
  List<ConcreteWord> sentence = [];
  String previousText = "";



  void onWordUpdated(ConcreteWord newWord,int indexInSentence)
  {
    sentence[indexInSentence] = newWord;
    onSentenceUpdated();
  }

  void onSentenceUpdated()
  {
    setState(() {});
    if(widget.onSentenceUpdated==null)
      return;
    widget.onSentenceUpdated!(sentence);
  }

  @override
  void initState() {
    super.initState();
    if(widget.initialSentence!=null && widget.initialSentence!.isNotEmpty)
      sentence = widget.initialSentence!;
    else
      initSentence();
    widget.sentenceCtrl.addListener(controllerListener);
  }
  
  void initSentence()
  {
    final currentText = widget.sentenceCtrl.text.trim().split(' ');
    bool isUpdateHappen = false;
    for (var word in currentText) {
      final predictionObj =  getPredictionWordObj(word);
      if(predictionObj!=null)
      {
        sentence.add(ConcreteWord(predictionObj)); 
        isUpdateHappen = true;
       
      }
    }

    if(isUpdateHappen)
      onSentenceUpdated();
  }
  
  void generateSentence()
  {
    final currentText = widget.sentenceCtrl.text;
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
        sentence.add(ConcreteWord(predictionObj)); 
        onSentenceUpdated();
      }
    }
    else if(hasUserRemovedWord || hasUserRemovedChar)
    {
      final removedWord = previousText.split(' ').last;
      final predictionObj =  getPredictionWordObj(removedWord);
      if(predictionObj!=null)
      {
        sentence.remove(sentence.last); 
        onSentenceUpdated();
      }
    }

    //update prev text
    previousText = widget.sentenceCtrl.text;
  }
  
  void controllerListener() { 
    generateSentence();
    setState(() {});    
  }

  @override
  void dispose() {
    widget.sentenceCtrl.removeListener(controllerListener);
    super.dispose();
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


  @override
  Widget build(BuildContext context) {
    return previewWidget();
  }

  Widget previewWidget()
  {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgetList,
      ),
    );
  }

  List<Widget> get widgetList
  {
    var wordsFound = 0;
    return widget.sentenceCtrl.text.split(' ').map(
      (e)
      {
        final predictionObj =  getPredictionWordObj(e);
        if(predictionObj==null)
          return Text(e+' ');
        else
        {
          wordsFound++;
          //TODO: fix error here! run on android not web
          return concreteWord(sentence[wordsFound-1],wordsFound-1);
        }
      }
    ).toList();
  }

  Widget concreteWord(ConcreteWord word,int indexInSentence)
  {
    return Container(
      child: PredictionWord(
        word.predictionItem,
        initialValue: word,
        onSelectionChanged: (newWord)=>onWordUpdated(newWord, indexInSentence),
      ),
      margin: EdgeInsets.only(right: 10),);
  }
  
}