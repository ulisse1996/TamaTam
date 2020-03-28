import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamatama/model/tama.dart';

import '../../common/common.dart';
import '../../service/tama-service.dart';

class TamaPage extends BasePageWidget {

  @override
  Widget body() {
    return MultiBlocProvider(
      child: _TamaPageBody(),
      providers: [
        BlocProvider<TamaLifeBloc>(
          create: (BuildContext context) => TamaLifeBloc(),
        ),
        BlocProvider<TamaFoodBloc>(
          create: (BuildContext context) => TamaFoodBloc(),
        ),
        BlocProvider<TamaHappyBloc>(
          create: (BuildContext context) => TamaHappyBloc(),
        ),
        BlocProvider<TamaSleepBloc>(
          create: (BuildContext context) => TamaSleepBloc(),
        ),
        BlocProvider<TamaImageBloc>(
          create: (BuildContext context) => TamaImageBloc(),
        ),
        BlocProvider<TamaEmotionBloc>(
          create: (BuildContext context) => TamaEmotionBloc(),
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
    final TamaLifeBloc lifeBloc = BlocProvider.of<TamaLifeBloc>(context);
    final TamaFoodBloc foodBloc = BlocProvider.of<TamaFoodBloc>(context);
    final TamaHappyBloc happyBloc = BlocProvider.of<TamaHappyBloc>(context);
    final TamaSleepBloc sleepBloc = BlocProvider.of<TamaSleepBloc>(context);
    final TamaImageBloc imageBloc = BlocProvider.of<TamaImageBloc>(context);
    final TamaEmotionBloc emotionBloc = BlocProvider.of<TamaEmotionBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStatusBar(lifeBloc, foodBloc, happyBloc, sleepBloc),
        buildTama(imageBloc, emotionBloc),
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

  Padding buildTama(TamaImageBloc imageBloc, TamaEmotionBloc emotionBloc) {
        initImageTimer(imageBloc);
        return Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: Stack(
              children: <Widget>[
                BlocBuilder<TamaImageBloc, String>(
                  builder: (context, val) {
                    return Image(image: AssetImage(val));
                  },
                  bloc: imageBloc,
                ),
                Container(
                    padding: EdgeInsets.only(left: 80),
                    child: BlocBuilder<TamaEmotionBloc, String>(
                      builder: (context, val) {
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
        _tamaTimer.cancel();
        _imageTimer.cancel();
        super.dispose();
      }
    
      Row buildStatusBar(TamaLifeBloc lifeBloc, TamaFoodBloc foodBloc,
          TamaHappyBloc happyBloc, TamaSleepBloc sleepBloc) {
        initTamaTimer(lifeBloc, foodBloc, happyBloc, sleepBloc);
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
                                    child: BlocBuilder<TamaLifeBloc, Decimal>(
                                      builder: (context, value) {
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
                            constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.fastfood),
                                Container(
                                    margin: EdgeInsets.only(left: 6),
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: BlocBuilder<TamaFoodBloc, Decimal>(
                                      builder: (context, value) {
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
                            constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.child_care),
                                Container(
                                    margin: EdgeInsets.only(left: 6),
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: BlocBuilder<TamaHappyBloc, Decimal>(
                                      builder: (context, value) {
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
                            constraints: BoxConstraints(minWidth: 130, maxWidth: 130),
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.airline_seat_individual_suite),
                                Container(
                                    margin: EdgeInsets.only(left: 6),
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: BlocBuilder<TamaSleepBloc, Decimal>(
                                      builder: (context, value) {
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
                return [
                  Stack(alignment: AlignmentDirectional.center, children: [
                    GestureDetector(
                      onTap: () {
                      }, // handle your image tap here
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
            
              void initImageTimer(TamaImageBloc imageBloc) {
                _imageTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
                  final String currImage = imageBloc.state;
                  String nextImage = currImage;
                  while (true) {
                    final int next = Random().nextInt(TamaUtil.getImagesSize());
                    nextImage = TamaUtil.getImages(Tama.fromJson(getTama()).tamaType)[next];
                    if (nextImage != currImage) {
                      imageBloc.add(next);
                      break;
                    }
                  }
                });
              }
        
          void initTamaTimer(TamaLifeBloc lifeBloc, TamaFoodBloc foodBloc, TamaHappyBloc happyBloc, TamaSleepBloc sleepBloc) {
            _tamaTimer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
            final Decimal food = foodBloc.state;
            final Decimal happy = happyBloc.state;
            final Decimal sleep = sleepBloc.state;
            final Decimal life = lifeBloc.state;
            final Decimal dec = Decimal.parse('0.1');
            
            // Get random prop to decrease
            final int prop = Random().nextInt(3);
            switch (prop) {
              case 0:
                // Decrease Food
                final Decimal decFood = food - dec;
                foodBloc.add(TamaFoodEvent(decFood));
                if (decFood == Decimal.zero) {
                  // Remove life too
                  lifeBloc.add(TamaLifeEvent(life - dec));
                }
                break;
              case 1:
                // Decrease Happy
                final Decimal decHappy = happy - dec;
                happyBloc.add(TamaHappyEvent(decHappy));
                if (decHappy == Decimal.zero) {
                  // Remove life too
                  lifeBloc.add(TamaLifeEvent(life - dec));
                }
                break;
              case 2:
                // Decrease Sleep
                final Decimal decSleep = sleep - dec;
                sleepBloc.add(TamaSleepEvent(decSleep));
                if (decSleep == Decimal.zero) {
                  // Remove life too
                  lifeBloc.add(TamaLifeEvent(life - dec));
                }
                break;
            }
            });
          }
}
