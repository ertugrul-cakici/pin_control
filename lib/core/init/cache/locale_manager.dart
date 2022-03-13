import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_control/core/constants/enums/locale_constants.dart';
import 'package:pin_control/core/constants/locale_setup.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();
  SharedPreferences? _preferences;

  static get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static Future preferencesInit() async {
    instance._preferences = await SharedPreferences.getInstance();
    await LocaleManager.setup();
  }

  static Future setup() async {
    if (instance._preferences!.getBool(LocaleEnums.setup.name) != true) {
      instance._preferences!.setBool(LocaleEnums.setup.name, true);
      instance._preferences!.setBool(LocaleEnums.alwaysOn.name,
          LocaleConstants.setupValues[LocaleEnums.alwaysOn.name]);
      instance._preferences!.setInt(LocaleEnums.delayTime.name,
          LocaleConstants.setupValues[LocaleEnums.delayTime.name]);
      instance._preferences!.setInt(LocaleEnums.activeTime.name,
          LocaleConstants.setupValues[LocaleEnums.activeTime.name]);
    }
  }

  bool getBool(String key) => _preferences!.getBool(key) ?? false;
  String getString(String key) => _preferences!.getString(key) ?? "";
  int getInt(String key) => _preferences!.getInt(key) ?? 0;

  Future setBool(String key, bool value) => _preferences!.setBool(key, value);
  Future setString(String key, String value) =>
      _preferences!.setString(key, value);
  Future setInt(String key, int value) => _preferences!.setInt(key, value);
}
