import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/textwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  final predictionList = [
  {
    "species" : "cat",
    "foods": ["tuna", "mice"]
  },
  {
    "species" : "dog",
    "foods": ["bones", "carrots"]
  },
  {
    "species" : "mouse",
    "foods": ["cheese", "apple"]
  }
  ].map((e) => PredictionItem.fromJson(e)).toList();

  return MaterialApp(
      title: 'interactive text',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TextWidget(predictionList: predictionList,),
    );
  }
}
