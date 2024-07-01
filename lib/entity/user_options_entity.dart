import 'dart:convert';
import 'dart:developer';

import 'json_format/json_format.dart';

class UserOptionsEntity {
  UserOptionsEntity({
    this.body,
    this.distance,
    this.drink,this.education,
    this.ethnicity,
    this.eyes,
    this.favoriteMusic,
    this.gender,
    this.hair,
    this.haveChildren,
    this.height,
    this.hobby,
    this.income,
    this.language,
    this.marital,
    this.occupation,
    this.paymentType,
    this.personality,
    this.pet,
    this.politicalBelief,
    this.relation,
    this.relationship,
    this.religion,
    this.sign,
    this.smoke,
    this.wantChildren,
  });

  factory UserOptionsEntity.fromJson(Map<String, dynamic> jsonRes) {
    final List<OptionItem>? body = jsonRes['body'] is List ? <OptionItem>[] : null;
    if (body != null) {
      for (final dynamic item in jsonRes['body']!) {
        if (item != null) {
          tryCatch(() {
            body.add(OptionItem.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? distance =
    jsonRes['distance'] is List
        ? <OptionItem>[]
        : null;
    if (distance != null) {
      for (final dynamic item in jsonRes['distance']!) {
        if (item != null) {
          tryCatch(() {
            distance.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? drink =
    jsonRes['drink'] is List
        ? <OptionItem>[]
        : null;
    if (drink != null) {
      for (final dynamic item in jsonRes['drink']!) {
        if (item != null) {
          tryCatch(() {
            drink.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? education =
    jsonRes['education'] is List
        ? <OptionItem>[]
        : null;
    if (education != null) {
      for (final dynamic item in jsonRes['education']!) {
        if (item != null) {
          tryCatch(() {
            education.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? ethnicity =
    jsonRes['ethnicity'] is List
        ? <OptionItem>[]
        : null;
    if (ethnicity != null) {
      for (final dynamic item in jsonRes['ethnicity']!) {
        if (item != null) {
          tryCatch(() {
            ethnicity.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? eyes =
    jsonRes['eyes'] is List
        ? <OptionItem>[]
        : null;
    if (eyes != null) {
      for (final dynamic item in jsonRes['eyes']!) {
        if (item != null) {
          tryCatch(() {
            eyes.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? favoriteMusic =
    jsonRes['favoriteMusic'] is List
        ? <OptionItem>[]
        : null;
    if (favoriteMusic != null) {
      for (final dynamic item in jsonRes['favoriteMusic']!) {
        if (item != null) {
          tryCatch(() {
            favoriteMusic.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? gender =
    jsonRes['gender'] is List
        ? <OptionItem>[]
        : null;
    if (gender != null) {
      for (final dynamic item in jsonRes['gender']!) {
        if (item != null) {
          tryCatch(() {
            gender.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? hair =
    jsonRes['hair'] is List
        ? <OptionItem>[]
        : null;
    if (hair != null) {
      for (final dynamic item in jsonRes['hair']!) {
        if (item != null) {
          tryCatch(() {
            hair.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? haveChildren =
    jsonRes['haveChildren'] is List
        ? <OptionItem>[]
        : null;
    if (haveChildren != null) {
      for (final dynamic item in jsonRes['haveChildren']!) {
        if (item != null) {
          tryCatch(() {
            haveChildren.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? height =
    jsonRes['height'] is List
        ? <OptionItem>[]
        : null;
    if (height != null) {
      for (final dynamic item in jsonRes['height']!) {
        if (item != null) {
          tryCatch(() {
            height.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? hobby =
    jsonRes['hobby'] is List
        ? <OptionItem>[]
        : null;
    if (hobby != null) {
      for (final dynamic item in jsonRes['hobby']!) {
        if (item != null) {
          tryCatch(() {
            hobby.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? income =
    jsonRes['income'] is List
        ? <OptionItem>[]
        : null;
    if (income != null) {
      for (final dynamic item in jsonRes['income']!) {
        if (item != null) {
          tryCatch(() {
            income.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? language =
    jsonRes['language'] is List
        ? <OptionItem>[]
        : null;
    if (language != null) {
      for (final dynamic item in jsonRes['language']!) {
        if (item != null) {
          tryCatch(() {
            language.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? marital =
    jsonRes['marital'] is List
        ? <OptionItem>[]
        : null;
    if (marital != null) {
      for (final dynamic item in jsonRes['marital']!) {
        if (item != null) {
          tryCatch(() {
            marital.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? occupation =
    jsonRes['occupation'] is List
        ? <OptionItem>[]
        : null;
    if (occupation != null) {
      for (final dynamic item in jsonRes['occupation']!) {
        if (item != null) {
          tryCatch(() {
            occupation.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? paymentType =
    jsonRes['paymentType'] is List
        ? <OptionItem>[]
        : null;
    if (paymentType != null) {
      for (final dynamic item in jsonRes['paymentType']!) {
        if (item != null) {
          tryCatch(() {
            paymentType.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? personality =
    jsonRes['personality'] is List
        ? <OptionItem>[]
        : null;
    if (personality != null) {
      for (final dynamic item in jsonRes['personality']!) {
        if (item != null) {
          tryCatch(() {
            personality.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? pet =
    jsonRes['pet'] is List
        ? <OptionItem>[]
        : null;
    if (pet != null) {
      for (final dynamic item in jsonRes['pet']!) {
        if (item != null) {
          tryCatch(() {
            pet.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? politicalBelief =
    jsonRes['politicalBelief'] is List
        ? <OptionItem>[]
        : null;
    if (politicalBelief != null) {
      for (final dynamic item in jsonRes['politicalBelief']!) {
        if (item != null) {
          tryCatch(() {
            politicalBelief.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? relation =
    jsonRes['relation'] is List
        ? <OptionItem>[]
        : null;
    if (relation != null) {
      for (final dynamic item in jsonRes['relation']!) {
        if (item != null) {
          tryCatch(() {
            relation.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? relationship =
    jsonRes['relationship'] is List
        ? <OptionItem>[]
        : null;
    if (relationship != null) {
      for (final dynamic item in jsonRes['relationship']!) {
        if (item != null) {
          tryCatch(() {
            relationship.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? religion =
    jsonRes['religion'] is List
        ? <OptionItem>[]
        : null;
    if (religion != null) {
      for (final dynamic item in jsonRes['religion']!) {
        if (item != null) {
          tryCatch(() {
            religion.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? sign =
    jsonRes['sign'] is List
        ? <OptionItem>[]
        : null;
    if (sign != null) {
      for (final dynamic item in jsonRes['sign']!) {
        if (item != null) {
          tryCatch(() {
            sign.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? smoke =
    jsonRes['smoke'] is List
        ? <OptionItem>[]
        : null;
    if (smoke != null) {
      for (final dynamic item in jsonRes['smoke']!) {
        if (item != null) {
          tryCatch(() {
            smoke.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<OptionItem>? wantChildren =
    jsonRes['wantChildren'] is List
        ? <OptionItem>[]
        : null;
    if (wantChildren != null) {
      for (final dynamic item in jsonRes['wantChildren']!) {
        if (item != null) {
          tryCatch(() {
            wantChildren.add(OptionItem.fromJson(
                asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }



    return UserOptionsEntity(
      body: body,
      distance: distance,
      drink: drink,
      education: education,
      ethnicity: ethnicity,
      eyes: eyes,
      favoriteMusic: favoriteMusic,
      gender: gender,
      hair: hair,
      haveChildren: haveChildren,
      height: height,
      hobby: hobby,
      income: income,
      language: language,
      marital: marital,
      occupation: occupation,
      paymentType: paymentType,
      personality: personality,
      pet: pet,
      politicalBelief: politicalBelief,
      relation: relation,
      relationship: relationship,
      religion: religion,
      sign: sign,
      smoke: smoke,
      wantChildren: wantChildren
    );
  }

  List<OptionItem>? body;
  List<OptionItem>? distance;
  List<OptionItem>? drink;
  List<OptionItem>? education;
  List<OptionItem>? ethnicity;
  List<OptionItem>? eyes;
  List<OptionItem>? favoriteMusic;
  List<OptionItem>? gender;
  List<OptionItem>? hair;
  List<OptionItem>? haveChildren;
  List<OptionItem>? height;
  List<OptionItem>? hobby;
  List<OptionItem>? income;
  List<OptionItem>? language;
  List<OptionItem>? marital;
  List<OptionItem>? occupation;
  List<OptionItem>? paymentType;
  List<OptionItem>? personality;
  List<OptionItem>? pet;
  List<OptionItem>? politicalBelief;
  List<OptionItem>? relation;
  List<OptionItem>? relationship;
  List<OptionItem>? religion;
  List<OptionItem>? sign;
  List<OptionItem>? smoke;
  List<OptionItem>? wantChildren;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'body': body,
    'distance': distance,
    'drink':drink,
    'education':education,
    'ethnicity':ethnicity,
    'eyes':eyes,
    'favoriteMusic':favoriteMusic,
    'gender':gender,
    'hair':hair,
    'haveChildren':haveChildren,
    'height':height,
    'hobby':hobby,
    'income':income,
    'language':language,
    'marital':marital,
    'occupation':occupation,
    'paymentType':paymentType,
    'personality':personality,
    'pet':pet,
    'politicalBelief':politicalBelief,
    'relation':relation,
    'relationship':relationship,
    'religion':religion,
    'sign':sign,
    'smoke':smoke,
    'wantChildren':wantChildren
  };

  UserOptionsEntity clone() => UserOptionsEntity
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}


class OptionItem {
  OptionItem({
    this.id,
    this.label,
    this.ord,
  });

  factory OptionItem.fromJson(Map<String, dynamic> jsonRes) =>
      OptionItem(
        id: asT<String?>(jsonRes['id']),
        label: asT<String?>(jsonRes['label']),
        ord: asT<String?>(jsonRes['ord']),
      );

  String? id;
  String? label;
  String? ord;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'labe': label,
    'ord': ord,
  };

  OptionItem clone() => OptionItem.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
