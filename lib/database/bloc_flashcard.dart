import 'dart:async';

import 'package:flashcards_for_everything/database/flashcard_helper.dart';
import 'package:flashcards_for_everything/database/model/flashcard.dart';
import 'package:rxdart/rxdart.dart';


class FlashCardBloc {
  String _cardSetId;

  BehaviorSubject<FlashCard> _subjectCounter = new BehaviorSubject<FlashCard>();

  Observable<FlashCard> get counterObservable => _subjectCounter.stream;

  final _flashCardController = StreamController<List<FlashCard>>.broadcast();
  get flashcards => _flashCardController.stream;

  FlashCardBloc(String cardSetId) {
    _cardSetId = cardSetId;
    getAllFlashCards();
  }

  dispose() {
    _flashCardController.close();
  }

  getAllFlashCards() async {
    _flashCardController.sink.add(
      await FlashCardHelper.db.getFlashCards(_cardSetId),
    );
  }

  getRandom() async{
    _subjectCounter.sink.add(await FlashCardHelper.db.getRandomFlashCard(_cardSetId));
  }

  checkAnswer(int id) {
    FlashCardHelper.db.getFlashCard(id);
  }

  delete(int id) {
    FlashCardHelper.db.deleteFlashCard(id);
    getAllFlashCards();
  }

  Future<void> add(FlashCard flashcard) async {
    FlashCardHelper.db.insertFlashCard(flashcard).then((_) {
      getAllFlashCards();
    });
  }
}
