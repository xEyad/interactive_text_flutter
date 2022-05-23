// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionMakerField.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final textCtrl = TextEditingController();
  final sentencesControllers = <PredictionMakerFieldController>[];
  final predictionList = [
  {
    "trigger" : "cat",
    "suggestions": ["tuna", "mice"]
  },
  {
    "trigger" : "dog",
    "suggestions": ["bones", "carrots"]
  },
  {
    "trigger" : "mouse",
    "suggestions": ["cheese", "apple"]
  }
  ].map((e) => PredictionItem.fromJson(e)).toList();
  final scrollCtrl = ScrollController();
  
  void onAddSentence(String initialTitle)
  {    
    if(sentencesControllers.isNotEmpty)
    {      
      sentencesControllers.last.freezeTextUpdates();
    }

    sentencesControllers.add(
      PredictionMakerFieldController(textCtrl: textCtrl,predictionList: predictionList,initialTitle: initialTitle,)
    );     

    setState(() {  
      if(sentencesControllers.length > 1)
        textCtrl.clear();      
    });
    Future.delayed(
      Duration(milliseconds: 100),
      () => scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.linear),
      );
  }

  Future<void> openGithubSource() async{
    try{
      launchUrl(Uri.parse("https://github.com/xEyad/interactive_text_flutter"));
    }catch(e)
    {
      print('Could not launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("interactive text"),actions: [
        IconButton(onPressed: openGithubSource, icon: Image.asset("assets/github.png"),tooltip: "Show source in github",)
      ]),      
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // instructions(),
            // SizedBox(height: 10,),
            textInput(),
            SizedBox(height: 10,),
            addSentenceBtn(),
            SizedBox(height: 10,),
            Expanded(child: sentencesList()),
            SizedBox(height: 10,),
          ],
        )
      ),
    );
  }

  Widget instructions() {
    return Text(
"""Start typing words in the Text area and the preview widget will render all words typed.
however, if it found any of these words: -- cat,dog,mouse -- it will render them differently cause these words gives you suggestions.
click on the words, to open and pick a suggestion. """);
  }

  Widget textInput()
  {
    return TextField(        
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      maxLines: 5,
      controller: textCtrl,
    );
  }

  Widget addSentenceBtn() {
    return Row(
      children: [
        Spacer(),
        ElevatedButton(onPressed: ()=>onAddSentence("Variable ${sentencesControllers.length+1}"), child: Text('Add sentence +'),style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(20))),),
      ],
    );
  }

  Widget sentencesList()
  {
    return ListView(
      controller: scrollCtrl,
      reverse: true,
      children: sentencesControllers.map(
        (e) => Container(
          key: UniqueKey(),
          margin: EdgeInsets.only(bottom: 10),
          child: PredictionMakerField(
            controller:e,
            onDelete: (){
              setState(() {
                sentencesControllers.remove(e);
              });
            }))
      ).toList(),      
    );
  }
}