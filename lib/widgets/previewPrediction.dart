// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/model/concreteWord.dart';
import 'package:interactive_text/widgets/predictionMakerField/predictionMakerField.dart';
import 'package:interactive_text/widgets/predictionWord.dart';

class PreviewPrediction extends StatefulWidget {
  ///this function runs whenever user selects option from prediction item
  final PredictionMakerFieldController controller;
  const PreviewPrediction({Key? key, required this.controller}) : super(key: key);

  @override
  State<PreviewPrediction> createState() => _PreviewPredictionState();
}

class _PreviewPredictionState extends State<PreviewPrediction> {
  
  List<PredictionItem> get predictionList => widget.controller.predictionList;

  void onWordUpdated(ConcreteWord newWord,int indexInSentence)
  {
    widget.controller.partiallyUpdateSentence(ConcreteTextItem(newWord),indexInSentence);    
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(controllerListener);
  }
  
  
  void controllerListener() { 
    setState(() {});    
  }

  @override
  void dispose() {
    widget.controller.removeListener(controllerListener);
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
    return widget.controller.textCtrl.text.split(' ').map(
      (e)
      {
        final predictionObj =  getPredictionWordObj(e);
        if(predictionObj==null)
          return Text(e+' ');
        else
        {
          wordsFound++;
          return concreteWord((widget.controller.sentence[wordsFound-1] as ConcreteTextItem).word,wordsFound-1);
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