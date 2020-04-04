import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamatama/model/tama.dart';

import '../../common/common.dart';
import '../../service/tama-service.dart' as tama_service;

class TamaPage extends BasePageWidget {
  @override
  Widget body() {
    return MultiBlocProvider(
      child: _TamaPageBody(),
      providers: <BlocProvider<dynamic>>[
        BlocProvider<tama_service.TamaLifeBloc>(
          create: (BuildContext context) => tama_service.TamaLifeBloc(),
        ),
        BlocProvider<tama_service.TamaFoodBloc>(
          create: (BuildContext context) => tama_service.TamaFoodBloc(),
        ),
        BlocProvider<tama_service.TamaHappyBloc>(
          create: (BuildContext context) => tama_service.TamaHappyBloc(),
        ),
        BlocProvider<tama_service.TamaSleepBloc>(
          create: (BuildContext context) => tama_service.TamaSleepBloc(),
        ),
        BlocProvider<tama_service.TamaImageBloc>(
          create: (BuildContext context) => tama_service.TamaImageBloc(),
        ),
        BlocProvider<tama_service.TamaEmotionBloc>(
          create: (BuildContext context) => tama_service.TamaEmotionBloc(),
        ),
        BlocProvider<tama_service.TamaEggBloc>(
          create: (BuildContext context) => tama_service.TamaEggBloc(),
        )
      ],
    );
  }
}

class _TamaPageBody extends StatefulWidget {
  @override
  State createState() => _TamaPageBodyState();
}

class _TamaPageBodyState extends State<_TamaPageBody> {
  Timer _imageTimer;
  Timer _tamaTimer;
  Timer _eggTimer;

  @override
  Widget build(BuildContext context) {
    final tama_service.TamaLifeBloc lifeBloc =
        BlocProvider.of<tama_service.TamaLifeBloc>(context);
    final tama_service.TamaFoodBloc foodBloc =
        BlocProvider.of<tama_service.TamaFoodBloc>(context);
    final tama_service.TamaHappyBloc happyBloc =
        BlocProvider.of<tama_service.TamaHappyBloc>(context);
    final tama_service.TamaSleepBloc sleepBloc =
        BlocProvider.of<tama_service.TamaSleepBloc>(context);
    final tama_service.TamaImageBloc imageBloc =
        BlocProvider.of<tama_service.TamaImageBloc>(context);
    final tama_service.TamaEmotionBloc emotionBloc =
        BlocProvider.of<tama_service.TamaEmotionBloc>(context);
    final tama_service.TamaEggBloc eggBloc =
        BlocProvider.of<tama_service.TamaEggBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ...buildPage(lifeBloc, foodBloc, happyBloc, sleepBloc, imageBloc,
            emotionBloc, eggBloc)
      ],
    );
  }

  Padding buildTama(tama_service.TamaImageBloc imageBloc,
      tama_service.TamaEmotionBloc emotionBloc) {
    initImageTimer(imageBloc);
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Stack(
          children: <Widget>[
            BlocBuilder<tama_service.TamaImageBloc, String>(
              builder: (BuildContext context, String val) {
                return Image(image: AssetImage(val));
              },
              bloc: imageBloc,
            ),
            Container(
                padding: const EdgeInsets.only(left: 80),
                child: BlocBuilder<tama_service.TamaEmotionBloc, String>(
                  builder: (BuildContext context, String val) {
                    if (val.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      return Image(image: AssetImage(val));
                    }
                  },
                  bloc: emotionBloc,
                ))
          ],
        ));
  }

  @override
  void dispose() {
    print('Calling dispose for kill timers');
    _tamaTimer?.cancel();
    _imageTimer?.cancel();
    _eggTimer?.cancel();

    super.dispose();
  }

  Row buildStatusBar(
      tama_service.TamaLifeBloc lifeBloc,
      tama_service.TamaFoodBloc foodBloc,
      tama_service.TamaHappyBloc happyBloc,
      tama_service.TamaSleepBloc sleepBloc) {
    initTamaTimer(lifeBloc, foodBloc, happyBloc, sleepBloc);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: BlocBuilder<tama_service.TamaLifeBloc, Decimal>(
                          builder: (BuildContext context, Decimal value) {
                            return LinearProgressIndicator(
                              value: value.toDouble(),
                              backgroundColor: Colors.red,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            );
                          },
                          bloc: lifeBloc,
                        ))
                  ],
                )),
            Container(
                constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.fastfood),
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: BlocBuilder<tama_service.TamaFoodBloc, Decimal>(
                          builder: (BuildContext context, Decimal value) {
                            return LinearProgressIndicator(
                              value: value.toDouble(),
                              backgroundColor: Colors.red,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            );
                          },
                          bloc: foodBloc,
                        ))
                  ],
                )),
            Container(
                constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.child_care),
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: BlocBuilder<tama_service.TamaHappyBloc, Decimal>(
                          builder: (BuildContext context, Decimal value) {
                            return LinearProgressIndicator(
                              value: value.toDouble(),
                              backgroundColor: Colors.red,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            );
                          },
                          bloc: happyBloc,
                        ))
                  ],
                )),
            Container(
                constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.airline_seat_individual_suite),
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: BlocBuilder<tama_service.TamaSleepBloc, Decimal>(
                          builder: (BuildContext context, Decimal value) {
                            return LinearProgressIndicator(
                              value: value.toDouble(),
                              backgroundColor: Colors.red,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            );
                          },
                          bloc: sleepBloc,
                        ))
                  ],
                )),
          ],
        )
      ],
    );
  }

  List<Widget> buttons() {
    return <Widget>[
      Stack(alignment: AlignmentDirectional.center, children: <Widget>[
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
      Stack(alignment: AlignmentDirectional.center, children: <Widget>[
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
      Stack(alignment: AlignmentDirectional.center, children: <Widget>[
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

  void initImageTimer(tama_service.TamaImageBloc imageBloc) {
    _imageTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      final String currImage = imageBloc.state;
      String nextImage = currImage;
      while (true) {
        final int next = Random().nextInt(tama_service.getTamaImagesSize());
        nextImage =
            tama_service.getTamaImages(Tama.fromJson(getTama()).tamaType)[next];
        if (nextImage != currImage) {
          imageBloc.add(next);
          break;
        }
      }
    });
  }

  void initTamaTimer(
      tama_service.TamaLifeBloc lifeBloc,
      tama_service.TamaFoodBloc foodBloc,
      tama_service.TamaHappyBloc happyBloc,
      tama_service.TamaSleepBloc sleepBloc) {
    _tamaTimer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      final Decimal life = tama_service.decreaseProp(lifeBloc, foodBloc, happyBloc, sleepBloc);
      if (life <= Decimal.zero) {
        setState(() {
          _tamaTimer?.cancel();
          _imageTimer?.cancel();
        });
      }
    });
  }

  List<Widget> buildPage(
      tama_service.TamaLifeBloc lifeBloc,
      tama_service.TamaFoodBloc foodBloc,
      tama_service.TamaHappyBloc happyBloc,
      tama_service.TamaSleepBloc sleepBloc,
      tama_service.TamaImageBloc imageBloc,
      tama_service.TamaEmotionBloc emotionBloc,
      tama_service.TamaEggBloc eggBloc) {
    if (isEggTime()) {
      _eggTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (eggBloc.state > 0) {
          eggBloc.add(tama_service.TamaEggEvent.REMOVE_TIME);
        } else {
          setState(() {
            _eggTimer.cancel();
          });
        }
      });
      return <Widget>[buildEgg(), ...buildEggTimer(eggBloc)];
    } else if (isDead()) {
      return <Widget>[
        ...buildDeadTama()
      ];
    } else {
      return <Widget>[
        buildStatusBar(lifeBloc, foodBloc, happyBloc, sleepBloc),
        buildTama(imageBloc, emotionBloc),
        ...buildButtons()
      ];
    }
  }

  bool isDead() {
    final Tama tama = Tama.fromJson(getTama());
    return tama.life <= Decimal.zero;
  }

  bool isEggTime() {
    final Tama tama = Tama.fromJson(getTama());
    final Duration diff = differenceFromNow(tama.lifeTime);
    return diff.inMinutes < 2;
  }

  List<Widget> buildDeadTama() {
    final Tama tama = Tama.fromJson(getTama());
    return <Widget>[
      Center(
        child:
            Image(image: AssetImage(tama_service.getTamaDeadImage(tama.tamaType)))),
      const Padding(
          padding: EdgeInsets.only(bottom: 20, top: 40),
          child: Center(
              child: Text(
            'Your tama is Dead',
            style: TextStyle(fontFamily: 'Mango Drink', fontSize: 60),
          ))),
      RaisedButton(
        child: 
          const Text('Create new Tama')
        ,
        onPressed: () async {
          await tama_service.createNewTama();
          setState(() {
            // Reload state
          });
        }
      )
    ];
  }

  Widget buildEgg() {
    final Tama tama = Tama.fromJson(getTama());
    return Center(
        child:
            Image(image: AssetImage(tama_service.getEggImage(tama.tamaType))));
  }

  List<Widget> buildEggTimer(tama_service.TamaEggBloc eggBloc) {
    return <Widget>[
      const Padding(
          padding: EdgeInsets.only(bottom: 20, top: 40),
          child: Center(
              child: Text(
            'Egg Hatch',
            style: TextStyle(fontFamily: 'Mango Drink', fontSize: 60),
          ))),
      BlocBuilder<tama_service.TamaEggBloc, int>(
        builder: (BuildContext context, int value) {
          final Duration time = Duration(milliseconds: value);
          return Center(
              child: Text('${_printDuration(time)}',
                  style: const TextStyle(
                      fontFamily: 'Mango Drink', fontSize: 60)));
        },
        bloc: eggBloc,
      )
    ];
  }

  String _printDuration(Duration duration) {
    String twoDigits(num n) {
      if (n >= 10) {
        return '$n';
      }
      return '0$n';
    }

    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes : $twoDigitSeconds';
  }

  List<Widget> buildButtons() {
    return <Widget>[
      Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 40),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons())),
      Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons()))
    ];
  }
}
