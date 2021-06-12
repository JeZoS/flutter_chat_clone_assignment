// import 'dart:ffi';

import 'package:chat_app_clone/Authenticate.dart';
import 'package:chat_app_clone/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AllChats(),
      home: LoggedOrNot(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoggedOrNot extends StatefulWidget {
  const LoggedOrNot({Key? key}) : super(key: key);

  @override
  _LoggedOrNotState createState() => _LoggedOrNotState();
}

class _LoggedOrNotState extends State<LoggedOrNot> {
  bool loggedIn = false;

  // String cid = "helloooo";

  void changeLogged() {
    setState(() {
      loggedIn = !loggedIn;
      // cid = id;
    });
  }

  void againChangeLogged() {
    FirebaseAuth.instance.signOut();
    setState(() {
      loggedIn = !loggedIn;
    });
  }

  // var fun =  changeLogged();

  @override
  Widget build(BuildContext context) {
    return loggedIn ? AllChats(againChangeLogged) : Authenticate(changeLogged);
  }
}

class AllChats extends StatefulWidget {
  final Function loggout;

  AllChats(this.loggout);

  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    var email;
    if (currentUser != null) {
      email = currentUser.email;
    }
    var chatId;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 40),
                      child: Text(
                        'Chat with',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 30),
                      child: Text(
                        'your friends',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      widget.loggout();
                    },
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 70,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  List<Widget> usrs = [];
                  if (snapshot.hasData) {
                    var dta = snapshot.data;
                    if (dta != null) {
                      var iid;
                      for (var usr in dta.docs) {
                        if (email == usr['email']) {
                          iid = usr['chatid'];
                          break;
                        }
                      }
                      for (var usr in dta.docs) {
                        if (email == usr['email']) {
                          chatId = usr['chatid'];
                          // print(chatId);
                          continue;
                        }
                        usrs.add(
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(
                                          index: iid,
                                          receiverId: usr['chatid'],
                                          receiverEmail: usr['email']),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgp-QJoDdH1XZruhuEc5hwLOopPLFC9VaTdg&usqp=CAU'),
                                    ),
                                    radius: 25,
                                  ),
                                ),
                                Text(
                                  '${usr['email'].toString().split("@")[0]}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: usrs,
                  );
                },
              ),
            ),
            Expanded(
              child: Messages(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.indigo.shade600,
    );
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String chatId = "null_written";

  void call() async {
    var dta = await FirebaseFirestore.instance.collection('users').get();
    if (dta != null) {
      dta.docs.forEach((element) {
        if (element['email'] == FirebaseAuth.instance.currentUser?.email) {
          // print('chatid');
          // print(element['chatid']);
          setState(() {
            chatId = element['chatid'];
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          // margin: EdgeInsets.only(top:10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('${FirebaseAuth.instance.currentUser?.email}')
                .snapshots(),
            builder: (context, snapshot) {
              List<Widget> lst = [];
              if (snapshot.hasData) {
                var dta = snapshot.data;
                if (dta != null) {
                  if (dta.docs.length == 0) {
                    return ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text('Start chatting with any user'),
                          ),
                        )
                      ],
                    );
                  }
                  for (var mails in dta.docs) {
                    lst.add(
                      Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(
                                      index: chatId,
                                      receiverEmail: mails['email'],
                                      receiverId: mails['id'],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.cyan,
                                  radius: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${mails['email']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text("Yo what's upp"),
                                    ],
                                  ),
                                ),
                                Text("13:09")
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
              }
              return ListView(
                children: lst,
              );
            },
          ),
        ),
      ),
    );
  }
}
