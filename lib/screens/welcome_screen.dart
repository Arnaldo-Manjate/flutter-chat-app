import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final Future<FirebaseApp> fbApp;

  const WelcomeScreen({Key? key, required this.fbApp}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('A kidly Occoured');
          } else if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset('images/logo.png'),
                          height: 60.0,
                        ),
                        Text(
                          'Flash Chat',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Log In',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Register',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
