
import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart' as common;
import '../model/tama.dart';
import '../repository/tama-repository.dart' as tama_repository;

Future<Tama> getTama(String tamaId) {
  return tama_repository.findTamaById(tamaId);
}

Future<void> saveTama(Tama tama) {
  return tama_repository.saveTama(tama);
}

void decreaseProp(TamaLifeBloc lifeBloc, TamaFoodBloc foodBloc,
    TamaHappyBloc happyBloc, TamaSleepBloc sleepBloc) {
  final Decimal food = foodBloc.state;
    final Decimal happy = happyBloc.state;
    final Decimal sleep = sleepBloc.state;
    final Decimal life = lifeBloc.state;
    final Decimal dec = Decimal.parse('0.1');

    //TODO check for value <= 0

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
}

abstract class TamaEvent<T> {
  TamaEvent(this._val);

  final T _val;

  T get val => _val;
}

class TamaLifeEvent extends TamaEvent<Decimal> { TamaLifeEvent(Decimal val) : super(val);}
class TamaFoodEvent extends TamaEvent<Decimal> { TamaFoodEvent(Decimal val) : super(val);}
class TamaHappyEvent extends TamaEvent<Decimal> { TamaHappyEvent(Decimal val) : super(val);}
class TamaSleepEvent extends TamaEvent<Decimal> { TamaSleepEvent(Decimal val) : super(val);}


class TamaLifeBloc extends Bloc<TamaLifeEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(common.getTama()).life;

  @override
  Stream<Decimal> mapEventToState(TamaLifeEvent event) async* {
    final Tama tama = Tama.fromJson(common.getTama());
    yield event._val;
    tama.life = event._val;
    await saveTama(tama);
    common.saveTama(tama.toJson());
  }

}

class TamaSleepBloc extends Bloc<TamaSleepEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(common.getTama()).sleep;

  @override
  Stream<Decimal> mapEventToState(TamaSleepEvent event) async* {
    final Tama tama = Tama.fromJson(common.getTama());
    yield event._val;
    tama.sleep = event._val;
    await saveTama(tama);
    common.saveTama(tama.toJson());
  }

}

class TamaFoodBloc extends Bloc<TamaFoodEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(common.getTama()).food;

  @override
  Stream<Decimal> mapEventToState(TamaFoodEvent event) async* {
    final Tama tama = Tama.fromJson(common.getTama());
    yield event._val;
    tama.food = event._val;
    await saveTama(tama);
    common.saveTama(tama.toJson());
  }

}

class TamaHappyBloc extends Bloc<TamaHappyEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(common.getTama()).happy;

  @override
  Stream<Decimal> mapEventToState(TamaHappyEvent event) async* {
    final Tama tama = Tama.fromJson(common.getTama());
    yield event._val;
    tama.happy = event._val;
    await saveTama(tama);
    common.saveTama(tama.toJson());
  }

}

class TamaImageBloc extends Bloc<int, String> {
  final List<String> _images = common.TamaUtil.getImages(Tama.fromJson(common.getTama()).tamaType);

  @override
  String get initialState => _images[0];

  @override
  Stream<String> mapEventToState(int event) async* {
    yield _images[event];
  }

}

enum EmotionType {
  ANGRY,
  EXCLAMATION,
  HAPPY,
  LOVE,
  STARVING,
  THRISTY
}

class TamaEmotionBloc extends Bloc<EmotionType, String> {
  final Map<EmotionType,String> _emotions = common.TamaUtil.getEmotions();

  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(EmotionType event) async* {
    yield _emotions[event];
  }

}