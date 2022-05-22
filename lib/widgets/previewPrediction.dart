// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionWord.dart';

class PreviewPrediction extends StatefulWidget {
  final List<PredictionItem> predictionList;
  ///this function runs whenever user selects option from prediction item
  final void Function(PredictionItem,String)? onItemSelectionUpdated;
  ///Sentence data will be read from that controller
  final TextEditingController sentenceCtrl;
  const PreviewPrediction({Key? key, required this.predictionList, required this.sentenceCtrl, this.onItemSelectionUpdated}) : super(key: key);

  @override
  State<PreviewPrediction> createState() => _PreviewPredictionState();
}

class _PreviewPredictionState extends State<PreviewPrediction> {
  
  List<PredictionItem> get predictionList => widget.predictionList;
  //TODO: maintain this list and update it whenever item changes or gets deleted!
  //TODO: maintain selection state
  List<Map<PredictionItem,String>> itemsAndSelections = [];

  void controllerListener() { 
    setState(() {});
  }

  void onItemSelectionUpdated(PredictionItem item,String selection)
  {
    if(widget.onItemSelectionUpdated==null)
      return;
    widget.onItemSelectionUpdated!(item,selection);
  }

  @override
  void initState() {
    super.initState();
    widget.sentenceCtrl.addListener(controllerListener);
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
    return widget.sentenceCtrl.text.split(' ').map(
      (e)
      {
        final predictionObj =  getPredictionWordObj(e);
        return predictionObj==null ? Text(e+' ') : predictionWord(predictionObj);
      }
    ).toList();
  }

  Widget predictionWord(PredictionItem? predictionObj)
  {
    return Container(
      child: PredictionWord(predictionObj!,onSelectionChanged: (String selection)=>onItemSelectionUpdated(predictionObj,selection),),
      margin: EdgeInsets.only(right: 10),);
  }
  
}