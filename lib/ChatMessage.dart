import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:io';
import 'String.dart';

class ChatMessage extends StatelessWidget{
  String? text;
  File? img;
  final AnimationController aController;
  ChatMessage({this.text, this.img, required this.aController}); // modified

  @override
  Widget build(BuildContext context){
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: aController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text(name[0])),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisSize: MainAxisSize.min,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(name, style: Theme.of(context).textTheme.subtitle1),
                        text != null? Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(text!)
                        ): Container(),
                        img != null ? Container(
                          margin: const EdgeInsets.only(top: 6.0),
                          child: Image.file(img!, fit: BoxFit.contain),
                        ): Container(),
                      ]
                  )
              )
            ],
          )
      ),
    );
  }
}