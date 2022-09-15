import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/welcome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
            // bodyText2: TextStyle(color: Colors.black54),
            // bodyText1: TextStyle(color: Colors.black),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(
              fbApp: _fbApp,
            ),
        '/login': (context) => LoginScreen(),
        '/chat': (context) => ChatScreen(),
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
