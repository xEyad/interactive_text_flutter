
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/model/concreteWord.dart';

class PredictionWord extends StatefulWidget {
  final PredictionItem predictionItem;
  final void Function(ConcreteWord)? onSelectionChanged;
  final ConcreteWord? initialValue;
  const PredictionWord(this.predictionItem ,{ Key? key, this.onSelectionChanged, this.initialValue }) : super(key: key);

  @override
  State<PredictionWord> createState() => _PredictionWordState();
}

class _PredictionWordState extends State<PredictionWord> {
  ConcreteWord get word => ConcreteWord(predictionItem,selection);
  String? selection;
  PredictionItem get predictionItem =>  widget.predictionItem;
  String get species => predictionItem.trigger;
  List <String> get predictionItems => predictionItem.suggestions;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue!=null )
      selection = widget.initialValue?.selection;
  }

  void onSelectionChanged(String selectedOption)
  {
    selection = selectedOption;
    if(widget.onSelectionChanged!=null)
      widget.onSelectionChanged!(word);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "Show suggestions",
      child: content(),
      itemBuilder: (context)=>predictionItems.map((e) => PopupMenuItem(child:Text(e),value: e,onTap: (){
        onSelectionChanged(e);
      },)).toList(),
    );
  }

  Widget content() {
    final clr = Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(species,style: TextStyle(color: clr),),
            selection==null ? SizedBox() : Text(selection!,style: TextStyle(color: clr))
          ]),
        ],
      ),
    );
  }
}