import 'package:flashcards_for_everything/database/bloc_flashcard.dart';
import 'package:flashcards_for_everything/database/bloc_set.dart';
import 'package:flutter/material.dart';

class SetPage extends StatefulWidget {
  final String cardSetId;
  SetPage(this.cardSetId);

  @override
  _SetPageState createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  var _blocFlashCard;
  var _blocCardSet = CardSetBloc();

  @override
  void dispose() {
    _blocFlashCard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _blocFlashCard = FlashCardBloc(widget.cardSetId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bilgi Kartı Listesi"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              FloatingActionButton(
                heroTag: "play_button",
                child: Icon(Icons.play_arrow),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, "/PlayFlashCard/${widget.cardSetId}");
                },
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: "add_button",
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, "/CreateFlashCard/${widget.cardSetId}");
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: _blocFlashCard.flashcards,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        _blocFlashCard.delete(snapshot.data[index].id);
                        _blocCardSet.decreaseCount(int.parse(widget.cardSetId));
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("${snapshot.data[index].keyName} silindi"),
                          ),
                        );
                      },
                      child: definitionFlashCardWidget(
                          snapshot.data[index].keyName,
                          snapshot.data[index].valueName),
                    );
                  },
                );
              } else
                return Text("");
            },
          ),
        ],
      ),
    );
  }
}

Widget definitionFlashCardWidget(String keyName, String valueName) {
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
              Text(keyName)
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
              Text(valueName)
            ],
          ),
        )
      ],
    ),
  );
}
