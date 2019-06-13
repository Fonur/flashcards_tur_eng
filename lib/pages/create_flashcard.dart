import 'package:flashcards_for_everything/database/bloc_flashcard.dart';
import 'package:flashcards_for_everything/database/bloc_set.dart';
import 'package:flashcards_for_everything/database/model/flashcard.dart';
import 'package:flutter/material.dart';

class CreateFlashCard extends StatefulWidget {
  final String cardSetId;

  CreateFlashCard(this.cardSetId);

  @override
  _CreateFlashCardState createState() => _CreateFlashCardState();
}

class _CreateFlashCardState extends State<CreateFlashCard> {
  var _blocFlashCard;
  final _blocSet = CardSetBloc();
  final _flashCardKeyName = TextEditingController();
  final _flashCardValueName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _flashCardKeyName.dispose();
    _blocFlashCard.dispose();
    _blocSet.dispose();
    _flashCardValueName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _blocFlashCard = FlashCardBloc(widget.cardSetId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kelime Kartı"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/SetPage/${widget.cardSetId}'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          editableFlashCardWordWidget(),
          StreamBuilder(
            stream: _blocFlashCard.flashcards,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return flashCardWordWidget(snapshot.data[index].keyName,
                        snapshot.data[index].valueName);
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget editableFlashCardWordWidget() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(30),
          alignment: Alignment.center,
          height: 230,
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration:
                        InputDecoration(labelText: 'Türkçe', hintText: 'Kelime'),
                    controller: _flashCardKeyName,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'İngilizce', hintText: 'Word'),
                    controller: _flashCardValueName,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 170.0,
          right: 10.0,
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: UniqueKey(),
              onPressed: () {
                var flashcard = FlashCard(
                  keyName: _flashCardKeyName.text.toString(),
                  valueName: _flashCardValueName.text.toString(),
                  cardSetId: int.parse(widget.cardSetId),
                );
                _blocSet.increaseCount(int.parse(widget.cardSetId));
                _blocFlashCard.add(flashcard);
                _flashCardKeyName.text = "";
                _flashCardValueName.text = "";
              },
            ),
          ),
        )
      ],
    );
  }

  Widget flashCardWordWidget(String wordKeyName, String wordValueName) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: new BoxDecoration(
        border: new Border.all(),
        color: Color.fromRGBO(250, 250, 250, 0.5),
      ),
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  "Türkçe:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("$wordKeyName")
              ],
            ),
          ),
          VerticalDivider(
            width: 20,
            color: Colors.black,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  "İngilizce:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("$wordValueName")
              ],
            ),
          )
        ],
      ),
    );
  }
}
