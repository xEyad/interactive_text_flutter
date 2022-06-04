// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_text/model/util.dart';


void main() {
   group('[get word starting location]',(){

    test('text: "sayed cat" ; get "cat"', (){
      final words = 'sayed cat'.split(' ');
      final startingIdx = Util.getStartingIndex(words,1);
      expect(startingIdx, 6);
    });

    test('text: "word dad television cat" ; get "cat"', (){
      final words = 'word dad television cat'.split(' ');
      final startingIdx = Util.getStartingIndex(words,3);
      expect(startingIdx, 20);
    });

    test('text: "word dad television cat" ; get "word"', (){
      final words = 'word dad television cat'.split(' ');
      final startingIdx = Util.getStartingIndex(words,0);
      expect(startingIdx, 0);
    });

    test('text: "word dad television cat" ; get "dad"', (){
      final words = 'word dad television cat'.split(' ');
      final startingIdx = Util.getStartingIndex(words,1);
      expect(startingIdx, 5);
    });

    test('text: "how can I change this method without ruining the whole functionality ?" ; get "?"', (){
      final words = 'how can I change this method without ruining the whole functionality ?'.split(' ');
      final startingIdx = Util.getStartingIndex(words,11);
      expect(startingIdx, 69);
    });

    test('text: "how can I change this method without ruining the whole functionality ?" ; get "I"', (){
      final words = 'how can I change this method without ruining the whole functionality ?'.split(' ');
      final startingIdx = Util.getStartingIndex(words,2);
      expect(startingIdx, 8);
    });

  });
}
