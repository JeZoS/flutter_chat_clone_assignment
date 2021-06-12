import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  final Function changeLogged;

  Authenticate(this.changeLogged);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  var email;
  var password;
  var confirm_password;
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                        color: Colors.lightBlue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      confirm_password = val;
                    });
                  },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                        color: Colors.lightBlue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              !login
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextField(
                        onChanged: (pass) {
                          setState(() {
                            password = pass;
                          });
                        },
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
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
                              color: Colors.lightBlue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              login
                  ? ElevatedButton(
                      onPressed: () async {

                        try {
                          UserCredential user =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: confirm_password);
                          widget.changeLogged();
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Invalid info'),
                            ),
                          );
                        }
                      },
                      child: Text('Login'),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (confirm_password != password) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password\'s not matching...'),
                            ),
                          );
                          return;
                        }
                        try {
                          UserCredential user =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          User? uuser = user.user;
                          // var id;
                          if (uuser != null) {
                            DocumentReference needId =
                                await _store.collection('chats').add({});
                            // id = needId.id;
                            _store.collection('users').add({
                              "email": uuser.email,
                              "id": uuser.uid,
                              "chatid": needId.id,
                              "chats": []
                            });
                          }
                          widget.changeLogged();
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Invalid cred\'s or user exists with this email.'),
                            ),
                          );
                        }
                      },
                      child: Text('Signup'),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(login ? 'Register Instead.' : 'Already have an account ?'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          login = !login;
                        });
                      },
                      child: Text(login ? 'Signup' : 'Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
