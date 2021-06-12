import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final String index;
  final String receiverId;
  final String receiverEmail;

  const ChatScreen(
      {this.index = "h", this.receiverId = "h", this.receiverEmail = "email"});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var input;

  void calculate() async {
    var data = FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.index}')
        .get();
    // data.then((value) => print(value.data()));
    // print(widget.index);
    // Stream<QuerySnapshot<Map<String,dynamic>>> dta = await FirebaseFirestore.instance
    //     .collection('chats')
    //     .doc('${widget.index}')
    //     .collection('${widget.receiverEmail}').snapshots();
    // dta.forEach((element) {
    //   print(element.docs.);
    // });
    // var d = await FirebaseFirestore.instance
    //     .collection('/chats')
    //     .doc('${widget.index}')
    //     .collection('${widget.receiverEmail}')
    //     .snapshots();
    //
    // d.forEach((element) {
    //   element.docs.forEach((element) {
    //     print(element['message']);
    //   });
    // });
    // .then((value) =>
    // {
    //   value.docs.forEach((element) {
    //     print(element['message']);
    //   })
    // });
  }

  @override
  void initState() {
    super.initState();
    calculate();
  }

  bool ad = false;

  void sendUser() {
    ad = true;
  }

  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade600,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.receiverEmail.split('@')[0]}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Awesome",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.phone_android_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.video_call,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('/chats')
                                .doc('${widget.index}')
                                .collection('${widget.receiverEmail}')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Widget> lst = [];
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                var dta;
                                if (data != null) {
                                  dta = data.docs.reversed;
                                  if (dta.length == 0) {
                                    sendUser();
                                  }
                                  for (var msgs in dta) {
                                    lst.add(
                                      MessageBubble(
                                          message: msgs['message'],
                                          email: msgs['email']),
                                    );
                                  }
                                }
                              }
                              return ListView(
                                reverse: true,
                                children: lst,
                              );
                            }
                            // itemCount: 19,
                            ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: TextField(
                                  // controller: ctrl,
                                  onChanged: (dta) {
                                    setState(() {
                                      input = dta;
                                    });
                                  },
                                  minLines: 1,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText: "Whats on your mind?",
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  controller: ctrl,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                ctrl.clear();
                                var dta = await FirebaseFirestore.instance
                                    .collection('/chats')
                                    .doc('${widget.index}')
                                    .collection('${widget.receiverEmail}')
                                    .add({
                                  'message': input,
                                  'email':
                                      FirebaseAuth.instance.currentUser?.email,
                                });
                                await FirebaseFirestore.instance
                                    .collection('/chats')
                                    .doc('${widget.receiverId}')
                                    .collection(
                                        '${FirebaseAuth.instance.currentUser?.email}')
                                    .add(
                                  {
                                    'message': input,
                                    'email': FirebaseAuth
                                        .instance.currentUser?.email,
                                  },
                                );
                                // ctrl.clear();
                                if (ad) {
                                  await FirebaseFirestore.instance
                                      .collection(
                                          '${FirebaseAuth.instance.currentUser?.email}')
                                      .add({
                                    "email": widget.receiverEmail,
                                    'id': widget.receiverId
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('${widget.receiverEmail}')
                                      .add({
                                    "email": FirebaseAuth
                                        .instance.currentUser?.email,
                                    'id': widget.index
                                  });
                                }
                              },
                              child: Icon(Icons.send_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  // const MessageBubble({Key? key}) : super(key: key);
  final message;
  final email;

  MessageBubble({this.message, this.email});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.email == FirebaseAuth.instance.currentUser?.email
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 7, right: 7, top: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: widget.email == FirebaseAuth.instance.currentUser?.email ? Radius.circular(15) : Radius.circular(0) ,
              topRight: widget.email != FirebaseAuth.instance.currentUser?.email ? Radius.circular(15) : Radius.circular(0) ,
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 14,
          ),
          child: Text(
            "${widget.message}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
