import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String newMessage = '';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscribeToMessageStream();
    getCurrentUser();
  }

  void getCurrentUser() {
    var user = _auth.currentUser;

    if (user != null) {
      currentUser = user.email!;
    }
  }

  void subscribeToMessageStream() async {
    await for (var message in _firestore.collection('messages').snapshots()) {
      for (var doc in message.docs) {
        print(doc.data());
      }
    }
  }

  Future<void> getMessages() async {
    QuerySnapshot querySnapshot = await _firestore.collection('messages').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var message in allData) {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (builder, snapshot) {
                  List<Widget> texts = [];

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  var orderedList = snapshot.data!.docs.reversed;
                  for (DocumentSnapshot document in orderedList) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    texts.add(
                      MessageBubble(
                        text: data['text'],
                        sender: data['sender'] ?? '',
                        isMe: data['sender'] == currentUser,
                      ),
                    );
                  }

                  if (texts.isEmpty) {
                    texts.add(
                      Text(
                        'No messages',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      children: texts,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        newMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (newMessage.isNotEmpty) {
                        try {
                          var response = await _firestore.collection('messages').add({
                            "sender": currentUser,
                            "text": newMessage,
                          });

                          if (response != null) {
                            print(response);
                          }
                        } catch (e) {
                          print(' send message error $e');
                        }
                        _controller.clear();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry messageAlightment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    BorderRadius _sharpCorderRight = const BorderRadius.only(
      topLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
      bottomLeft: Radius.circular(30),
    );
    BorderRadius _sharpCorderLeft = const BorderRadius.only(
      topRight: Radius.circular(30),
      bottomRight: Radius.circular(30),
      bottomLeft: Radius.circular(30),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: messageAlightment,
            child: Text(
              '$sender',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Align(
            alignment: messageAlightment,
            child: Material(
              elevation: 5,
              borderRadius: isMe ? _sharpCorderRight : _sharpCorderLeft,
              color: isMe ? Colors.white : Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                    color: isMe ? Colors.black54 : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
