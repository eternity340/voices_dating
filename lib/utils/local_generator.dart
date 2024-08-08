import 'package:uuid/uuid.dart';

class LocalIdGenerator {
  static final Uuid _uuid = const Uuid();

  static String generate() {
    return _uuid.v4().toString();
  }


}

void main() {
  // 生成标准 UUID
  String localId = LocalIdGenerator.generate();
  print('Generated Local ID: $localId');

}