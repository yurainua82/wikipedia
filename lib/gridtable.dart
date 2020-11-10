import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'dart:math';
import 'package:html/dom.dart' as dom;
import 'package:wikipedia/service/web.dart';

class GridTable extends StatefulWidget {
  final int rows;
  final int cols;

  const GridTable({Key key, this.rows: 6, this.cols: 3}) : super(key: key);

  get max => rows * cols;

  @override
  _GridTableState createState() => _GridTableState();
}

class _GridTableState extends State<GridTable> {
  List<int> pressedNumbers;
  List<int> initialNumbers;

  @override
  void initState() {
    super.initState();
    pressedNumbers = [];

    restart();
  }

  void restart() {
    var rng = new Random();

    initialNumbers = List.generate(widget.max, (_) => rng.nextInt(1000));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        new Table(
          border: TableBorder.all(),
          children: buildButtons(),
        ),
        SizedBox(height: 20),
        Center(
          child: FlatButton(
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  restart();
                });
              },
              child: Text("Reset")),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '1) On press to grid you will receive full information about wiki page'),
                  Text('2) On reset you will receive other random numbers')
                ],
              ),
            ))
      ],
    ));
  }

  isInitial(int id) {
    return initialNumbers.contains(id);
  }

  isPressed(int id) {
    return pressedNumbers.contains(id);
  }

  List<TableRow> buildButtons() {
    List<TableRow> rows = [];

    for (var i = 0; i < widget.rows; i++) {
      List<Widget> rowChildren = [];

      for (var y = 0; y < widget.cols; y++) {
        // fill row with buttons
        rowChildren.add(
          FlatButton(
            color: !isPressed(initialNumbers[i * 3 + y])
                ? Colors.white
                : Colors.yellow,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                        future:
                            WebService().url('${initialNumbers[i * 3 + y]}'),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null)
                            return Scaffold(
                                appBar: AppBar(
                                  leading: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.black),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                body: SingleChildScrollView(
                                    child: SafeArea(
                                  child: Html(
                                      padding:
                                          EdgeInsets.all(20),
                                      data: snapshot.data,
                                      customRender: (node, children) {
                                        if (node is dom.Element) {
                                          switch (node.localName) {
                                            case "custom_tag":
                                              return Column(children: children);
                                          }
                                        }
                                        return null;
                                      }),
                                )));
                          else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        });
                  });

              setState(() {
                if (isInitial(initialNumbers[i * 3 + y])) {
                  pressedNumbers.add(initialNumbers[i * 3 + y]);
                }
              });
            },
            child: Stack(
              children: <Widget>[
                Text(
                  "${initialNumbers[i * 3 + y]}",
                  style: TextStyle(
                    color: isPressed(initialNumbers[i * 3 + y])
                        ? Colors.green
                        : Colors.black,
                    fontWeight: isPressed(initialNumbers[i * 3 + y])
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
        );
      }
      rows.add(new TableRow(children: rowChildren));
    }

    return rows;
  }
}
