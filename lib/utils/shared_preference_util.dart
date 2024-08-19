import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil{

 factory SharedPreferenceUtil() => _getInstance();

 static SharedPreferenceUtil get instance => _getInstance();

 static SharedPreferenceUtil? _instance;

 static SharedPreferenceUtil _getInstance(){
   _instance ??= SharedPreferenceUtil._internal();
   return _instance!;
 }

 late GetStorage _preferences;

 SharedPreferenceUtil._internal(){
    init();
 }

 init() async{
   _preferences = GetStorage();
 }

   setValue({required String key,required value}) async{
    // SharedPreferences pres = await SharedPreferences.getInstance();
     print(key);
     print(value);
     _preferences.write(key, value);

    // if(value is int) {
    //   _preferences.setInt(key, value);
    // }else if(value is String){
    //   _preferences.setString(key, value);
    // }else if(value is List<String>){
    //   _preferences.setStringList(key, value);
    // }else if(value is double){
    //   _preferences.setDouble(key, value);
    // }else if(value is bool){
    //   _preferences.setBool(key, value);
    // }
  }

  getValue({required String key}){
   print(key);
    return _preferences.read(key);
  }

}