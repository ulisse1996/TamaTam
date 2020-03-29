
import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart' as common;
import '../model/tama.dart';
import '../repository/tama-repository.dart' as tama_repository;

// Get Tama from Firebase Collection
Future<Tama> getTama(String tamaId) {
  return tama_repository.findTamaById(tamaId);
}

// Save updated Tama in Firebase Collection
Future<void> saveTama(Tama tama) {
  return tama_repository.saveTama(tama);
}

/// Decrease a random prop in Tama's props like food , happy , sleep
/// and add event in the appropriate bloc
/// If prop is less than 0 after decrease , bloc is not update and 
/// instead life decrease 
void decreaseProp(TamaLifeBloc lifeBloc, TamaFoodBloc foodBloc,
    TamaHappyBloc happyBloc, TamaSleepBloc sleepBloc) {
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
        if (decFood >= Decimal.zero) {
          foodBloc.add(TamaFoodEvent(decFood));
        }
        if (decFood <= Decimal.zero) {
          // Remove life too
          lifeBloc.add(TamaLifeEvent(life - dec));
        }
        break;
      case 1:
        // Decrease Happy
        final Decimal decHappy = happy - dec;
        if (decHappy >= Decimal.zero) {
          happyBloc.add(TamaHappyEvent(decHappy));
        }
        if (decHappy == Decimal.zero) {
          // Remove life too
          lifeBloc.add(TamaLifeEvent(life - dec));
        }
        break;
      case 2:
        // Decrease Sleep
        final Decimal decSleep = sleep - dec;
        if (decSleep >= Decimal.zero) {
          sleepBloc.add(TamaSleepEvent(decSleep));
        }
        if (decSleep == Decimal.zero) {
          // Remove life too
          lifeBloc.add(TamaLifeEvent(life - dec));
        }
        break;
    }
}

// Base class for any TamaEvent which update a Tama entity
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
  final List<String> _images = getTamaImages(Tama.fromJson(common.getTama()).tamaType);

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
  final Map<EmotionType,String> _emotions = getEmotions();

  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(EmotionType event) async* {
    yield _emotions[event];
  }

}

String _append(String s, String s2) {
  return s + s2;
}

List<String> getTamaImages(TamaType tamaType) {
  final String name = describeEnum(tamaType).toLowerCase();
  final String camel = _camelCase(describeEnum(tamaType));
  return List<String>.of(<String>[
    _append('assets/animals/$name/$camel','_Down.png'),
    _append('assets/animals/$name/$camel','_Left.png'),
    _append('assets/animals/$name/$camel','_Right.png'),
    _append('assets/animals/$name/$camel','_Up.png')
  ]);
}

String _camelCase(String s) {
  final String sLow = s.toLowerCase();
  return sLow[0].toUpperCase() + sLow.substring(1);
}

String getTamaDeadImage(TamaType tamaType) {
  final String name = describeEnum(tamaType).toLowerCase();
  final String camel = _camelCase(describeEnum(tamaType));
  return _append('assets/animals/$name/$camel','_Dead.png');
}

String getAvatar(TamaType tamaType) {
  final String name = describeEnum(tamaType).toLowerCase();
  final String camel = _camelCase(describeEnum(tamaType));
  return _append('assets/animals/$name/$camel','_Avatar_Circle.png');
}

String getEggImage(TamaType tamaType) {
  switch (tamaType) {
    case TamaType.CAT:
      return 'assets/eggs/egg_blue';
    case TamaType.CHICK:
      return 'assets/eggs/egg_yellow';
    case TamaType.PIG:
    case TamaType.RABBIT:
      return 'assets/eggs/egg_pink';
    case TamaType.FOX:
    case TamaType.MOUSE:
      return 'assets/eggs/egg_red';
  }
  return ''; //Never Happen
}

Map<EmotionType, String> getEmotions() {
  final Map<EmotionType,String> vals = <EmotionType,String>{};
  for (final EmotionType em in EmotionType.values) {
    final String camel = _camelCase(describeEnum(em));
    vals[em] = 'assets/emotions/Status_$camel.png';
  }
  return vals;
}

int getTamaImagesSize() {
  return 4;
}