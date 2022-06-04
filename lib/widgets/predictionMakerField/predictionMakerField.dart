// ignore_for_file: avoid_print
library prediction_maker_field;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:interactive_text/model/concreteWord.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/model/util.dart';
import 'package:interactive_text/widgets/previewPrediction.dart';
part 'predictionMakerFieldCtrl.dart';

class PredictionMakerField extends StatefulWidget {
  final VoidCallback? onDelete;
  final PredictionMakerFieldController controller;
  final Color? highlightColor;
  PredictionMakerField({Key? key,required this.controller,this.onDelete, this.highlightColor }) : super(key: key);

  @override
  State<PredictionMakerField> createState() => _PredictionMakerFieldState();
}

class _PredictionMakerFieldState extends State<PredictionMakerField> {
  final borderRadiusValue = 10.0;
  PredictionMakerFieldController get controller => widget.controller;

  void controllerListener()
  {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // controller.addListener(controllerListener);
  }

  @override
  void dispose() {
    // controller.removeListener(controllerListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          titleBar(),
          previewArea()
        ]),
    width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadiusValue),border: Border.all(color: widget.highlightColor??Colors.black)),);
  }

  Widget titleBar()
  {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusValue),topRight: Radius.circular(borderRadiusValue)),
        color: widget.highlightColor??Color(0xFF717C89)
      ),
      child: Row(children: [
        Expanded(child: Center(child: titleField()),),
        deleteBtn()
      ],),
    );
  }

  Widget titleField()
  {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none,),
      controller: controller.titleCtrl,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18,color: Colors.grey[200]),
    );
  }

  Widget deleteBtn()
  {
    return IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete),color: Colors.grey[200],tooltip: "Delete Item",);
  }

  Widget previewArea()
  {
    return PreviewPrediction(
      key: UniqueKey(),
      controller: controller,
    );   
  }

}

