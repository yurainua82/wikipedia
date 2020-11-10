import 'package:flutter/material.dart';

import 'gridtable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikipedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }

}
class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Container(
        padding: EdgeInsets.only(left:20,right:20,top:20),
        child:Column(children:[
        Center(child: Text('Choose your wiki page',style: TextStyle(fontWeight: FontWeight.bold),),),
        SizedBox(height:50),
        GridTable()]),
    ));
  }
}
      
