import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/previewPrediction.dart';

class PredictionMakerField extends StatefulWidget {
  final PredictionMakerFieldController controller;
  PredictionMakerField({Key? key,required this.controller }) : super(key: key);

  @override
  State<PredictionMakerField> createState() => _PredictionMakerFieldState();
}

class _PredictionMakerFieldState extends State<PredictionMakerField> {
  final borderRadiusValue = 10.0;
  late TextEditingController titleCtrl;
  PredictionMakerFieldController get controller => widget.controller;

  void controllerListener() { 
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: controller.initialTitle);
    controller.addListener(controllerListener);
  }

  @override
  void dispose() {
    controller.removeListener(controllerListener);
    titleCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
      titleBar(),
      previewArea()
    ]),
    width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadiusValue),border: Border.all()),);
  }

  Widget titleBar()
  {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusValue),topRight: Radius.circular(borderRadiusValue)),
        color: Color(0xFF717C89)
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
      controller: titleCtrl,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18,color: Colors.grey[200]),
    );
  }

  Widget deleteBtn()
  {
    return IconButton(onPressed: controller.onDelete, icon: Icon(Icons.delete),color: Colors.grey[200],tooltip: "Delete Item",);
  }

  Widget previewArea()
  {
    return PreviewPrediction(predictionList: controller.predictionList, sentenceCtrl: controller.textCtrl ,);   
  }

}


class PredictionMakerFieldController extends ChangeNotifier 
{
  ///Sentence data will be read from that controller
  TextEditingController _textCtrl;
  TextEditingController get textCtrl => _textCtrl;
  final VoidCallback? onDelete;
  final String? initialTitle;
  final List<PredictionItem> predictionList;
  PredictionMakerFieldController({this.predictionList = const [],required TextEditingController textCtrl, this.initialTitle, this.onDelete })
  :
  _textCtrl = textCtrl
  ;
  
  ///Non reversible
  void freezeTextUpdates()
  {
    _textCtrl = TextEditingController(text: _textCtrl.text);
    notifyListeners();
  }
}