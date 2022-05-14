class PredictionItem {
  String? trigger;
  List<String>? suggestions;

  PredictionItem({
    this.trigger,
    this.suggestions,
  });

  PredictionItem.fromJson(Map<String, dynamic> json) {
    trigger = json['trigger'] as String?;
    suggestions = (json['suggestions'] as List?)?.map((dynamic e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['trigger'] = trigger;
    json['suggestions'] = suggestions;
    return json;
  }
}