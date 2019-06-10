import 'package:rxdart/rxdart.dart';

class PlayFlashCardBloc {
  int correctAnswers = 0;
  int inCorrectAnswers = 0;
  BehaviorSubject<int> _correctAnswerCounter;
  BehaviorSubject<int> _incorrectAnswerCounter;

  PlayFlashCardBloc({this.correctAnswers, this.inCorrectAnswers}) {
    _correctAnswerCounter =
        new BehaviorSubject<int>.seeded(this.correctAnswers);
    _incorrectAnswerCounter =
        new BehaviorSubject<int>.seeded(this.inCorrectAnswers);
  }

  Observable<int> get correctCounterObservable => _correctAnswerCounter.stream;
  Observable<int> get incorrectCounterObservable =>
      _incorrectAnswerCounter.stream;

  void incrementCorrect() {
    correctAnswers++;
    _correctAnswerCounter.sink.add(correctAnswers);
  }

  void incrementIncorrect() {
    inCorrectAnswers++;
    _incorrectAnswerCounter.sink.add(inCorrectAnswers);
  }

  void dispose() {
    _correctAnswerCounter.close();
    _incorrectAnswerCounter.close();
  }
}
