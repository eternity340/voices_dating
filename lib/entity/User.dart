// user.dart
class User {
  String? email;
  String? gender;
  String? country;
  String? state;
  String? city;
  DateTime? birthday;
  int? age;
  String? username;
  String? password;
  String? height;

  User({
    this.email,
    this.gender,
    this.country,
    this.state,
    this.city,
    this.birthday,
    this.age,
    this.username,
    this.password,
    this.height,
  });

// 将对象转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'user[email]': email,
      'user[gender]': gender,
      'user[country]': country,
      'user[state]': state,
      'user[city]': city,
      'user[birthday]': birthday?.toIso8601String(),
      'user[age]': age,
      'user[username]': username,
      'user[password]': password,
      'user[height]': height,
    };
  }

}

