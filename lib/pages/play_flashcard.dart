import 'package:flashcards_for_everything/bloc_play_flashcard.dart';
import 'package:flashcards_for_everything/database/bloc_flashcard.dart';
import 'package:flashcards_for_everything/database/model/flashcard.dart';
import 'package:flutter/material.dart';

class PlayFlashCardPage extends StatefulWidget {
  final String cardSetId;

  PlayFlashCardPage(this.cardSetId);

  @override
  _PlayFlashCardPageState createState() => _PlayFlashCardPageState();
}

class _PlayFlashCardPageState extends State<PlayFlashCardPage> {
  final _valueName = TextEditingController();
  String _oldValue = "";
  final _blocPlayFlashCard =
      PlayFlashCardBloc(correctAnswers: 0, inCorrectAnswers: 0);
  var _blocFlashCard;

  @override
  void dispose() {
    _blocFlashCard.dispose();
    _blocPlayFlashCard.dispose();
    _valueName.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _blocFlashCard = FlashCardBloc(widget.cardSetId);
    _blocFlashCard.getRandom();
  }

  Widget _flashCardWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(75, 40, 75, 100),
      decoration: BoxDecoration(
        border: new Border.all(width: 2.0, color: Colors.black12),
      ),
      child: StreamBuilder(
        stream: _blocFlashCard.counterObservable,
        builder: (context, AsyncSnapshot<FlashCard> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.keyName == _oldValue) {
              _blocFlashCard.getRandom();
            }
            return Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: Text(
                      snapshot.data.keyName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Cevap'),
                        controller: _valueName,
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Kontrol Et"),
                  onPressed: () {
                    if (equalsIgnoreCase(
                        snapshot.data.valueName, _valueName.text.toString())) {
                      _blocPlayFlashCard.incrementCorrect();
                      _blocFlashCard.getRandom();
                    } else {
                      _blocPlayFlashCard.incrementIncorrect();
                    }

                    setState(() {
                      _valueName.text = "";
                      _oldValue = snapshot.data.keyName;
                    });
                    _blocFlashCard.getRandom();
                  },
                )
              ],
            );
          } else {
            return Text("Henüz ekleme yapılmamış.");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              _showDialog();
            }),
        title: Text("Bilgi Kartları"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/CreateFlashCard');
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                    stream: _blocPlayFlashCard.correctCounterObservable,
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        avatar: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        label: Text(
                          '${snapshot.data} Doğru',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: _blocPlayFlashCard.incorrectCounterObservable,
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        avatar: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                        label: Text(
                          '${snapshot.data} Yanlış',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            _flashCardWidget(),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Sonuç"),
        content: Text("${_blocPlayFlashCard.exit()}"),
        actions: [
          new FlatButton(
            child: const Text("Tamam"),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
