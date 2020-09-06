import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/model/data_models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> _bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 10),
    Band(id: '3', name: 'Héroes del silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Platform.isIOS
          ? null
          : FloatingActionButton(
              onPressed: addNewBandDialog,
              child: Icon(Icons.add),
              elevation: 1.0,
            ),
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: Platform.isIOS ? 0.0 : 4.0,
        title: Text(
          'Band Names',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        backgroundColor: Colors.white,
        actions: Platform.isIOS
            ? [
                CupertinoButton(
                  child: Icon(
                    CupertinoIcons.add,
                    size: 30,
                  ),
                  onPressed: addNewBandDialog,
                )
              ]
            : null,
      ),
      body: ListView.builder(
        itemCount: _bands.length,
        itemBuilder: (context, index) => bandTile(_bands[index], index),
      ),
    );
  }

  Widget bandTile(Band band, int index) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 15.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        print(direction);
        //llamar al backend para borrar el item
      },
      confirmDismiss: (direction) async {
        print('confirm dismiss');
        return true;
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            band.name.substring(0, 2),
          ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => print(band.name),
      ),
    );
  }

//muestra un dialogo para agregar nueva banda
  addNewBandDialog() {
    final _textController = TextEditingController();
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: _textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Add'),
                isDefaultAction: true,
                onPressed: () => addBandToList(_textController.text),
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New band name'),
          content: TextField(
            controller: _textController,
          ),
          actions: [
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(_textController.text),
            ),
          ],
        );
      },
    );
  }

//agrega una banda a la lista
  void addBandToList(String name) {
    if (name.length > 1) {
      this._bands.add(
            Band(
              id: DateTime.now().toString(),
              name: name,
              votes: 0,
            ),
          );
      setState(() {});
    }
    Navigator.pop(context);
  }
}
