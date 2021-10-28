import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ChatMessage.dart';
import 'String.dart';

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposing = false;
  late ScrollController _controller;

  @override
  void dispose(){
    for(ChatMessage msg in _messages){
      msg.aController.dispose();
    }
    super.dispose();
  }

  void _scrollListener(){
    if(_controller.offset >= _controller.position.maxScrollExtent
        && !_controller.position.outOfRange) {
      // scroll to the bottom
      setState(() {});
    }
    if(_controller.offset <= _controller.position.minScrollExtent
        && !_controller.position.outOfRange){
      // scroll to the top
      setState(() {
      });
    }
  }

  @override
  void initState(){
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  BoxDecoration boxDecoration(){
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Widget _buildTextInput() => Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8.0),
      decoration: boxDecoration(),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textEditingController,
              onChanged: (String text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              minLines: 1,
              decoration: const InputDecoration.collapsed(hintText: "Type message here"),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isComposing ? () => _handleTextSubmitted(_textEditingController.text)
                  : null
          )
        ],
      )
  );

  Widget _buildTextComposer(){
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 6.0),
                child: IconButton(
                  icon: const Icon(Icons.photo_camera),
                  onPressed: () => _handleTouchOnCamera(),
                )
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 6.0),
                child: IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _handleTouchOnGalleryPhoto(),
                )
            ),
            Expanded(
              child: _buildTextInput(),
            )
          ],
        )
    );
  }
  // code yourself ^^
  void _handleTouchOnCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    String str = "This is an image captured by camera";
    File? file = File(image!.path);
    _handleImageSubmitted(str, file);
  }
  // code yourself ^^
  void _handleTouchOnGalleryPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    String str = "This is an image selected from gallery";
    File? file = File(image!.path);
    _handleImageSubmitted(str, file);
  }

  void _handleImageSubmitted(String str, File? file){
    if(file != null){
      print("Not null");
      ChatMessage msg = ChatMessage(
          text: str,
          img: file,
          aController: AnimationController(
            duration: const Duration(milliseconds: 500),
            vsync: this,
          )
      );
      setState(() {
        _messages.insert(0, msg);
      });
      msg.aController.forward();
    }
  }

  void _handleTextSubmitted(String text){
    _textEditingController.clear(); // xoa text trong khung input
    setState(() {
      _isComposing = false; // cho biet hien tai dang khong nhap text
    });
    if(text.isNotEmpty){
      ChatMessage msg = ChatMessage(text: text,
          aController: AnimationController(
            duration: const Duration(milliseconds: 600),
            vsync: this,
          )
      );
      setState(() {
        _messages.insert(0, msg);
      });
      msg.aController.forward();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with $name")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              controller: _controller,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: SafeArea(
              bottom: true,
              child: _buildTextComposer(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget{
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State createState() => ChatScreenState();
}