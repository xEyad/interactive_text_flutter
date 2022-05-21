import 'package:flutter/material.dart';
import 'package:interactive_text/widgets/textwidget.dart';

class PredictionMakerField extends StatefulWidget {
  PredictionMakerField({Key? key}) : super(key: key);

  @override
  State<PredictionMakerField> createState() => _PredictionMakerFieldState();
}

class _PredictionMakerFieldState extends State<PredictionMakerField> {
  List<Widget> previewItems = [];
  final borderRadiusValue = 10.0;

  void onDelete() {
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
    return Text("title",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey[200]),);
  }

  Widget deleteBtn()
  {
    return IconButton(onPressed: onDelete, icon: Icon(Icons.delete),color: Colors.grey[200]);
  }

  Widget previewArea()
  {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(horizontal:10,vertical: 30),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: previewItems,
      ),
    );
  }


}