import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/textwidget.dart';
import 'package:url_launcher/url_launcher.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
        child: TextWidget(predictionList: predictionList)
      ),
    );
  }
}