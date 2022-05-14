class PredictionItem {
  late String trigger;
  late List<String> suggestions;

  PredictionItem({
    required this.trigger,
    required this.suggestions,
  });

  PredictionItem.fromJson(Map<String, dynamic> json) {
    trigger = json['trigger'] as String;
    suggestions = (json['suggestions'] as List).map((dynamic e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['trigger'] = trigger;
    json['suggestions'] = suggestions;
    return json;
  }
}