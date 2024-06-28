import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class LocationDataDB {
  static final LocationDataDB db = LocationDataDB._();
  static Database? _database;
  static  List<Country> countries = [];

  LocationDataDB._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "countries.db");
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets', 'countries.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    return await openDatabase(path);
  }

  Future<List<Country>> get getCountries async {
    if (countries.isEmpty) {
      final db = await database;
      var res = await db.query("countries");
      var d = res.map((p) => Country.fromMap(p));

      countries = (res.isNotEmpty ? d.toList() : <Country>[]);
      late Country us;
      late Country ca;
      late Country uk;
      for(Country country in countries){
        if(country.couId==236){
          uk = country;
        }else if(country.couId==237){
          us = country;
        }else if(country.couId==42){
          ca = country;
        }
      }
      countries.removeAt(0);
      countries.remove(us);
      countries.remove(ca);
      countries.remove(uk);
      countries.insert(0, us);
      countries.insert(1, ca);
      countries.insert(2, uk);
    }
    return countries;
  }

  Future<List<Province>> getStatesList(Country country) async {
    final db = await database;
    final couId = country.couId;
    var res =
    await db.query("states", where: ("cou_id = ?"), whereArgs: [couId]);
    var d = res.map((p) => Province.fromMap(p));
    return res.isNotEmpty ? d.toList() : <Province>[];
  }

  Future<List<City>> getCitiesList(Province province) async {
    final db = await database;
    final sttId = province.sttId;
    var res = await db
        .query("cities", where: ("stt_id" + " = ?"), whereArgs: [sttId]);
    var d = res.map((p) => City.fromMap(p));
    return res.isNotEmpty ? d.toList() : <City>[];
  }

  Future<List<City>> getCitiesListById(int sttId,int couId) async {
    final db = await database;
    var res = await db
        .query("cities", where: ("stt_id" + " = ?"), whereArgs: [sttId]);
    var d = res.map((p) => City.fromMap(p));
    return res.isNotEmpty ? d.toList() : <City>[];
  }

  Future<int?> getStateIdByName(String stateName) async{
    final db  = await database;
    var stateResult = await db.query("states",where: ("stt_name"+" = ?"),whereArgs:[stateName]);
    Province province = Province.fromMap(stateResult[0]);
    return province.sttId;
  }

  Future<int?> getCountryIdByName(String countryName) async{
    final db  = await database;
    var stateResult = await db.query("countries",where: ("cou_name"+" = ?"),whereArgs:[countryName]);
    Country country = Country.fromMap(stateResult[0]);
    return country.couId;
  }

  Future<int?> getCityIdByName(String cityName) async{
    final db  = await database;
    var stateResult = await db.query("cities",where: ("cit_name"+" = ?"),whereArgs:[cityName]);
    City city = City.fromMap(stateResult[0]);
    return city.cityId;
  }

  Future<List<Province>> getStatesListById(int couId) async {
    final db = await database;
    var res =
    await db.query("states", where: ("cou_id = ?"), whereArgs: [couId]);
    var d = res.map((p) => Province.fromMap(p));
    return res.isNotEmpty ? d.toList() : <Province>[];
  }

}

class Country {
  int? couId;
  String? couName;
  Country();

  Country.fromMap(Map<String, dynamic> json) {
    couId = int.tryParse(json['cou_id']);
    couName = json['cou_name'];
  }

  @override
  String toString() {
    return 'Country{cou_id: $couId, cou_name: $couName}';
  }
}

class Province {
  int? couId;
  String? sttName;
  int? sttId;

  Province();
  Province.fromMap(Map<String, dynamic> json) {
    couId = int.tryParse(json['cou_id']);
    sttName = json['stt_name'];
    sttId = int.tryParse(json['stt_id']);
  }

  @override
  String toString() {
    return 'Province{cou_id: $couId, stt_name: $sttName, stt_id: $sttId}';
  }
}

class City {
  int? cityId;
  int? sttId;
  String? cityName;

  City();
  City.fromMap(Map<String, dynamic> json) {
    cityId = int.tryParse(json['cit_id']);
    sttId = int.tryParse(json['stt_id']);
    cityName = json['cit_name'];
  }

  @override
  String toString() {
    return 'City{cit_id: $cityId, stt_id: $sttId, cit_name: $cityName}';
  }
}