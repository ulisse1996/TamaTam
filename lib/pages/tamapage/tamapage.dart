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

  @override
  Widget build(BuildContext context) {
    final tama_service.TamaLifeBloc lifeBloc = BlocProvider.of<tama_service.TamaLifeBloc>(context);
    final tama_service.TamaFoodBloc foodBloc = BlocProvider.of<tama_service.TamaFoodBloc>(context);
    final tama_service.TamaHappyBloc happyBloc = BlocProvider.of<tama_service.TamaHappyBloc>(context);
    final tama_service.TamaSleepBloc sleepBloc = BlocProvider.of<tama_service.TamaSleepBloc>(context);
    final tama_service.TamaImageBloc imageBloc = BlocProvider.of<tama_service.TamaImageBloc>(context);
    final tama_service.TamaEmotionBloc emotionBloc =
        BlocProvider.of<tama_service.TamaEmotionBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildStatusBar(lifeBloc, foodBloc, happyBloc, sleepBloc),
        buildTama(imageBloc, emotionBloc),
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
      ],
    );
  }

  Padding buildTama(tama_service.TamaImageBloc imageBloc, tama_service.TamaEmotionBloc emotionBloc) {
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
    _tamaTimer.cancel();
    _imageTimer.cancel();
    super.dispose();
  }

  Row buildStatusBar(tama_service.TamaLifeBloc lifeBloc, tama_service.TamaFoodBloc foodBloc,
      tama_service.TamaHappyBloc happyBloc, tama_service.TamaSleepBloc sleepBloc) {
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
        nextImage = tama_service.getTamaImages(Tama.fromJson(getTama()).tamaType)[next];
        if (nextImage != currImage) {
          imageBloc.add(next);
          break;
        }
      }
    });
  }

  void initTamaTimer(tama_service.TamaLifeBloc lifeBloc, tama_service.TamaFoodBloc foodBloc,
      tama_service.TamaHappyBloc happyBloc, tama_service.TamaSleepBloc sleepBloc) {
    _tamaTimer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      tama_service.decreaseProp(lifeBloc, foodBloc, happyBloc, sleepBloc);
    });
  }
}
