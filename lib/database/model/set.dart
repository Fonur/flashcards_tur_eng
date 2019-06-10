import 'dart:convert';

CardSet cardSetFromJson(String str) => CardSet.fromMap(json.decode(str));

String cardSetToJson(CardSet data) => json.encode(data.toMap());

class CardSet {
  int id;
  int setCount;
  String setName;

  CardSet({
    this.id,
    this.setName,
    this.setCount
  });

  factory CardSet.fromMap(Map<String, dynamic> json) => new CardSet(
        id: json["id"],
        setName: json["setName"],
        setCount: json["setCount"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "setName": setName,
        "setCount": setCount,
      };

  @override
  String toString() {
    return 'cardset{id: $id, setName: $setName, setCount: $setCount}';
  }
}
