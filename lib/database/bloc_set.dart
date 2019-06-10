import 'dart:async';

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

  decreaseCount(int cardSetId) {
    var cardSet = CardSetHelper.db.getCardSet(cardSetId);

    var _increasedCardSet = CardSet(
        id: cardSetId,
        setName: cardSet.setName,
        setCount: cardSets.setCount - 1);

    CardSetHelper.db.updateCardSet(_increasedCardSet);
    getAllCardSets();
  }

  update(CardSet cardSet) {
    CardSetHelper.db.updateCardSet(cardSet);
    getAllCardSets();
  }

  add(CardSet cardSet) {
    CardSetHelper.db.insertCardSet(cardSet);
    getAllCardSets();
  }
}
