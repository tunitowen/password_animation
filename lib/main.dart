import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'validation_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();

  AnimationController _controller;
  Animation<double> _fabScale;

  bool eightChars = false;
  bool specialChar = false;
  bool upperCaseChar = false;
  bool number = false;

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {
        eightChars = textController.text.length >= 8;
        number = textController.text.contains(RegExp(r'\d'), 0);
        upperCaseChar = textController.text.contains(new RegExp(r'[A-Z]'), 0);
        specialChar = textController.text.isNotEmpty &&
            !textController.text.contains(RegExp(r'^[\w&.-]+$'), 0);
      });

      if (_allValid()) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _controller = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 500));

    _fabScale = Tween<double>(begin: 0, end: 1)
    .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _fabScale.addListener((){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(32.0), child: _validationStack()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: textController,
                style: TextStyle(fontSize: 20, color: Colors.black87),
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Set a password",
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(width: 0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(width: 0))),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                padding: EdgeInsets.all(16),
                color: Colors.yellow.shade700,
                child: Text("SAVE",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18)),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _separator() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.blue.withAlpha(100)),
    );
  }

  Stack _validationStack() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Card(
          shape: CircleBorder(),
          color: Colors.black12,
          child: Container(height: 150, width: 150,),),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0, left: 10),
          child: Transform.rotate(
            angle: -math.pi/20,
            child: Icon(
              Icons.lock,
              color: Colors.pink,
              size: 60,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 60),
          child: Transform.rotate(
            angle: -math.pi / -60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 4,
              color: Colors.yellow.shade800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: Colors.deepPurple,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: Colors.deepPurple,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: Colors.deepPurple,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_1, color: Colors.deepPurple,)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 74),
          child: Transform.rotate(
            angle: math.pi / -45,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IntrinsicWidth(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ValidationItem("8 characters", eightChars),
                          _separator(),
                          FittedBox(
                            child: ValidationItem("1 special character", specialChar),
                          ),
                          _separator(),
                          ValidationItem("1 upper case", upperCaseChar),
                          _separator(),
                          ValidationItem("1 number", number)
                        ],
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: _fabScale.value,
                      child: Card(
                        shape: CircleBorder(),
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  bool _allValid() {
    return eightChars && number && specialChar && upperCaseChar;
  }
}
