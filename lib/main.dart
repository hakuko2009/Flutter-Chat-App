import 'package:flutter/material.dart';
import 'ChatScreen.dart';

class chatApp extends StatelessWidget{
  const chatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: "Flutter Chat App",
      home: ChatScreen(),
    ); //Stateless vi chi hien thi title cua app
  }
}
void main() => runApp(const chatApp());