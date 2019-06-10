import 'dart:convert';

FlashCard flashCardFromJson(String str) => FlashCard.fromMap(json.decode(str));

String flashCardToJson(FlashCard data) => json.encode(data.toMap());

class FlashCard {
  int id;
  String keyName;
  String valueName;
  int cardSetId;

  FlashCard({
    this.id,
    this.keyName,
    this.valueName,
    this.cardSetId
  });

  factory FlashCard.fromMap(Map<String, dynamic> json) => new FlashCard(
        id: json["id"],
        keyName: json["keyName"],
        valueName: json["valueName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "keyName": keyName,
        "valueName": valueName,
        "cardSetId": cardSetId
      };

  @override
  String toString() {
    return 'flashcard{id: $id, keyName: $keyName, valueName: $valueName}';
  }
}
