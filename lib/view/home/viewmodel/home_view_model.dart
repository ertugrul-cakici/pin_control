import 'package:flutter/cupertino.dart';
import 'package:pin_control/core/constants/enums/locale_constants.dart';
import 'package:pin_control/core/constants/locale_setup.dart';
import 'package:pin_control/core/init/cache/locale_manager.dart';
import 'package:pin_control/product/model/pin_model.dart';
import 'package:window_manager/window_manager.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel();

  bool get screenState =>
      LocaleManager.instance.getBool(LocaleEnums.alwaysOn.name);
  int get delayTime =>
      LocaleManager.instance.getInt(LocaleEnums.delayTime.name);
  int get activeTime =>
      LocaleManager.instance.getInt(LocaleEnums.activeTime.name);

  List<PinModel> pinModels = [];
  List<PinModel> selectedPins = [];
  static List<PinModel> activePins = [];

  void changeScreenState(bool? value) {
    LocaleManager.instance.setBool(LocaleEnums.alwaysOn.name, value ?? false);
    windowManager.setAlwaysOnTop(value ?? false);
    notifyListeners();
  }

  void generatePinModels() {
    pinModels.addAll(List.generate(
        12, (index) => PinModel(pin: index + 2, text: "Pin : ${index + 1}")));
  }

  void setDelayTime(String value) {
    int? _value;
    try {
      _value = int.parse(value);
    } catch (e) {
      _value = LocaleConstants.setupValues[LocaleEnums.delayTime.name];
    }
    LocaleManager.instance.setInt(LocaleEnums.delayTime.name, _value);
  }

  void setActiveTime(String value) {
    int? _value;
    try {
      _value = int.parse(value);
    } catch (e) {
      _value = LocaleConstants.setupValues[LocaleEnums.activeTime.name];
    }
    LocaleManager.instance.setInt(LocaleEnums.activeTime.name, _value);
  }

  void addPinToQueue(int pin) {
    selectedPins.add(pinModels.firstWhere((element) => element.pin == pin));
    notifyListeners();
  }

  void removePinFromQueue(int pin) {
    selectedPins.remove(pinModels.firstWhere((element) => element.pin == pin));
    notifyListeners();
  }

  Future<void> activeQueue() async {
    for (PinModel _pin in selectedPins) {
      await _pin.active();
      await Future.delayed(Duration(milliseconds: delayTime));
    }
  }

  Future<void> activeMultiple() async {
    if (selectedPins.length < 2) {
      for (PinModel _pin in selectedPins) {
        _pin.active();
      }
    }
  }
}
