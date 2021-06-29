import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp;
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Map data;

  void addData() {
    Map<String, dynamic> demodata = {
      'Name': 'Sourabh Rai',
      'Motto': 'Hello Motto'
    };
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('data');
    collectionReference.add(demodata);
  }
  //
  // void fetchData() async {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('data');
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   final user = await _auth.currentUser;
  //   String uid = user.uid.toString();
  //   QuerySnapshot ds = await collectionReference.get();
  //   Map mapdata = db.collection('data').document(uid);
  // }

  Future<void> getCurrentUserData() async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');
      //FirebaseAuth _auth = FirebaseAuth.instance;
      final user = await _auth.currentUser;

      // String uid = user.uid.toString();
      DocumentSnapshot ds = await collectionReference.doc(user.uid).get();
      String email = ds.get('email');
      print(email);
    } catch (e) {
      print(e.toString());
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
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Profile'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User Details:',
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: MaterialButton(
                elevation: 0.0,
                minWidth: double.maxFinite,
                height: 50.0,
                color: Colors.green,
                onPressed: () {
                  addData();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Add Data',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: MaterialButton(
                elevation: 0.0,
                minWidth: double.maxFinite,
                height: 50.0,
                color: Colors.yellow,
                onPressed: () {
                  getCurrentUserData();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Fetch Data',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Text(
            //   email,
            //   style: TextStyle(fontSize: 30.0),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
