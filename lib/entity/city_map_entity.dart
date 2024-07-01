class CityMapEntity{
  Map<String,dynamic> cityMap = {};
  CityMapEntity();

  toEncodable(){
    Map<String,dynamic> map = {};
    map["cityMap"] = cityMap;
    return map;
  }

  CityMapEntity.fromJson(Map<String, dynamic> json){
    cityMap = json["cityMap"];
  }


}