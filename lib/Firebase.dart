// firebase connection class

import 'dart:convert';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import "ChatMessage.dart";
import 'String.dart';
import 'package:intl/intl.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class UploadMessage{

  void _authentication() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "nguyenlethiennhu1303@gmail.com",
          password: "thiennhu13032000"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void uploadImage(ChatMessage msg) async{
    Firebase.initializeApp().whenComplete(() async {
      _authentication();

      String fileName = basename(msg.img!.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("/Images/$fileName"); //string (name)
      UploadTask uploadTask = ref.putFile(msg.img!); //file (file)

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() =>
          print("Upload image Successfully"));
      taskSnapshot.ref.getDownloadURL().then((value) =>
          print("Done uploading image: $value"));
    });
  }

  void uploadText(ChatMessage msg) async {
    Firebase.initializeApp().whenComplete(() async {
      _authentication();

      var json = {'name': name,
        'text': msg.text};

      var jsonString = jsonEncode(json);
      var bytes = utf8.encode(jsonString);
      var base64str = base64.encode(bytes);
      var arr = base64.decode(base64str);

      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      String fileName = dateFormat.format(DateTime.now()) + ".json";

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("/Texts/$fileName");
      UploadTask uploadTask = ref.putData(arr);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() =>
          print("Upload text Successfully"));
      taskSnapshot.ref.getDownloadURL().then((value) =>
          print("Done uploading text: $value"));
    });
  }
}


