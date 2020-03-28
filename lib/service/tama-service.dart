
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';
import '../model/tama.dart';
import '../repository/tama-repository.dart' as tama_repository;

class TamaService {

  static Future<Tama> getTama(String tamaId) {
    return tama_repository.findTamaById(tamaId);
  }

  static Future<void> saveTama(Tama tama) {
    return tama_repository.saveTama(tama);
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
  Decimal get initialState => Tama.fromJson(getTama()).life;

  @override
  Stream<Decimal> mapEventToState(TamaLifeEvent event) async* {
    final Tama tama = Tama.fromJson(getTama());
    yield event._val;
    tama.life = event._val;
    await TamaService.saveTama(tama);
    saveTama(tama.toJson());
  }

}

class TamaSleepBloc extends Bloc<TamaSleepEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(getTama()).life;

  @override
  Stream<Decimal> mapEventToState(TamaSleepEvent event) async* {
    final Tama tama = Tama.fromJson(getTama());
    yield event._val;
    tama.sleep = event._val;
    await TamaService.saveTama(tama);
    saveTama(tama.toJson());
  }

}

class TamaFoodBloc extends Bloc<TamaFoodEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(getTama()).life;

  @override
  Stream<Decimal> mapEventToState(TamaFoodEvent event) async* {
    final Tama tama = Tama.fromJson(getTama());
    yield event._val;
    tama.food = event._val;
    await TamaService.saveTama(tama);
    saveTama(tama.toJson());
  }

}

class TamaHappyBloc extends Bloc<TamaHappyEvent, Decimal> {

  @override
  Decimal get initialState => Tama.fromJson(getTama()).life;

  @override
  Stream<Decimal> mapEventToState(TamaHappyEvent event) async* {
    final Tama tama = Tama.fromJson(getTama());
    yield event._val;
    tama.happy = event._val;
    await TamaService.saveTama(tama);
    saveTama(tama.toJson());
  }

}

class TamaImageBloc extends Bloc<int, String> {
  final List<String> _images = TamaUtil.getImages(Tama.fromJson(getTama()).tamaType);

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
  final Map<EmotionType,String> _emotions = TamaUtil.getEmotions();

  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(EmotionType event) async* {
    yield _emotions[event];
  }

}