import 'package:interactive_text/model/predictionItem.dart';

///a predictionItem with it's associated selection
class ConcreteWord
{
  ConcreteWord(this.predictionItem,[this.selection]);
  PredictionItem predictionItem;
  String? selection;

  bool equals(ConcreteWord other)
  {
    return predictionItem.suggestions == other.predictionItem.suggestions && 
      predictionItem.trigger == other.predictionItem.trigger &&
      selection == other.selection;
  }
}