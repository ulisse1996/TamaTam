import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common.dart';

class TamaPage extends BasePageWidget {
  @override
  Widget body() {
    return _TamaPageBody();
  }
}

class _TamaPageBody extends StatefulWidget {
  createState() => _TamaPageBodyState();
}

class _TamaPageBodyState extends State<_TamaPageBody> {
  String _currentImage = "assets/animals/cat/Cat_Down.png";
  double _currentLife = 0.3;
  double _currentFood = 0.7;
  double _currentHappy = 0.5;
  double _currentSleep = 0.9;
  String _currentEmotion = "assets/emotions/Status_Happy.png";
  final _images = [
    "assets/animals/cat/Cat_Down.png",
    "assets/animals/cat/Cat_Left.png",
    "assets/animals/cat/Cat_Right.png",
    "assets/animals/cat/Cat_Up.png"
  ];
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStatusBar(),
        Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: Stack(
              children: <Widget>[
                Image(image: AssetImage(_currentImage)),
                Container(
                    padding: EdgeInsets.only(left: 80),
                    child: Image(image: AssetImage(_currentEmotion)))
              ],
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 20, top: 40),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons())),
        Padding(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons()))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _currentImage = _images[Random().nextInt(_images.length - 1)];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Row buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        constraints: BoxConstraints(maxWidth: 100),
                        child: LinearProgressIndicator(
                          value: _currentLife,
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ))
                  ],
                )),
            Container(
                constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.fastfood),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        constraints: BoxConstraints(maxWidth: 100),
                        child: LinearProgressIndicator(
                          value: _currentFood,
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ))
                  ],
                )),
            Container(
                constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.child_care),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        constraints: BoxConstraints(maxWidth: 100),
                        child: LinearProgressIndicator(
                          value: _currentHappy,
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ))
                  ],
                )),
            Container(
                constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.airline_seat_individual_suite),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        constraints: BoxConstraints(maxWidth: 100),
                        child: LinearProgressIndicator(
                          value: _currentSleep,
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ))
                  ],
                )),
          ],
        )
      ],
    );
  }

  List<Widget> buttons() {
    return [
      Stack(alignment: AlignmentDirectional.center, children: [
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Image.asset(
            'assets/ui/CircledFrame.png',
            width: 80,
            height: 80,
          ),
        ),
        Icon(Icons.android, size: 40)
      ]),
      Stack(alignment: AlignmentDirectional.center, children: [
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Image.asset(
            'assets/ui/CircledFrame.png',
            width: 80,
            height: 80,
          ),
        ),
        Icon(Icons.android, size: 40)
      ]),
      Stack(alignment: AlignmentDirectional.center, children: [
        GestureDetector(
          onTap: () {}, // handle your image tap here
          child: Image.asset(
            'assets/ui/CircledFrame.png',
            width: 80,
            height: 80,
          ),
        ),
        Icon(Icons.android, size: 40)
      ])
    ];
  }
}
