import 'package:flashcards_for_everything/database/bloc_set.dart';
import 'package:flashcards_for_everything/database/model/set.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _blocCardSet = CardSetBloc();
  final _setName = TextEditingController();

  @override
  void dispose() {
    _blocCardSet.dispose();
    _setName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bilgi Kartı Setleri'),
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _showDialog),
      body: StreamBuilder(
        stream: _blocCardSet.cardSets,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  background: Container(color: Colors.red),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _blocCardSet.delete(snapshot.data[index].id);

                    Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${snapshot.data[index].setName} silindi")));
                  },
                  child: setCardWidget(
                      context,
                      snapshot.data[index].setName.toString(),
                      snapshot.data[index].id.toString(),
                      snapshot.data[index].setCount.toString()),
                );
              },
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                controller: _setName,
                decoration: new InputDecoration(
                    labelText: 'Yeni Setin İsmini Girin:',
                    hintText: 'Yeni Set'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            child: const Text('İptal'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          new FlatButton(
            child: const Text('Oluştur'),
            onPressed: () {
              var _cardSet =
                  CardSet(setName: _setName.text.toString(), setCount: 0);
              _blocCardSet.add(_cardSet);
              _blocCardSet.getLength().then(
                (dik) {
                  if (dik != null) {
                    print("Dik:" + dik.toString());

                    Navigator.pushReplacementNamed(
                        context, "/CreateFlashCard/$dik");
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}

Widget setCardWidget(BuildContext context, String cardSetName, String cardSetId,
    String cardSetCount) {
  return Container(
    height: 100,
    width: double.infinity,
    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/SetPage/$cardSetId');
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  cardSetName,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, "/PlayFlashCard/$cardSetId");
                    },
                    icon: Icon(Icons.play_circle_outline),
                  ),
                  Text("$cardSetCount kart")
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
