import 'dart:async';

import 'package:flashcards_for_everything/database/flashcard_helper.dart';
import 'package:flashcards_for_everything/database/model/set.dart';
import 'package:flashcards_for_everything/database/set_helper.dart';

class CardSetBloc {
  CardSetBloc() {
    getAllCardSets();
  }

  final _cardController = StreamController<List<CardSet>>.broadcast();
  get cardSets => _cardController.stream;

  dispose() {
    _cardController.close();
  }

  getAllCardSets() async {
    _cardController.sink.add(await CardSetHelper.db.getCardSets());
  }

  delete(int id) {
    CardSetHelper.db.deleteCardSet(id);
    FlashCardHelper.db.deleteAll(id);
    getAllCardSets();
  }

  getLength() {
    return CardSetHelper.db.getCardSetsLength();
  }

  increaseCount(int cardSetId) async {
    CardSet cardSet = await CardSetHelper.db.getCardSet(cardSetId);

    var _increasedCardSet = CardSet(
        id: cardSetId,
        setName: cardSet.setName,
        setCount: cardSet.setCount + 1);

    CardSetHelper.db.updateCardSet(_increasedCardSet);
    getAllCardSets();
  }

  decreaseCount(int cardSetId) async {
    var cardSet = await CardSetHelper.db.getCardSet(cardSetId);
    print(cardSet);
    var _decreasedCardSet = CardSet(
        id: cardSetId,
        setName: cardSet.setName,
        setCount: cardSet.setCount - 1);

    CardSetHelper.db.updateCardSet(_decreasedCardSet);
    getAllCardSets();
  }

  update(CardSet cardSet) {
    CardSetHelper.db.updateCardSet(cardSet);  
    getAllCardSets();
  }

  add(CardSet cardSet) async {
    await CardSetHelper.db.insertCardSet(cardSet);
    getAllCardSets();
  }
}
