import 'dart:io';

class IpUtil {
  static Future<List<String>> getAllIpAddresses() async {
    List<String> addresses = [];
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      for (var interface in interfaces) {
        print('Interface: ${interface.name}');
        for (var addr in interface.addresses) {
          print('Address: ${addr.address}');
          addresses.add(addr.address);
        }
      }
    } catch (e) {
      print('Error getting IP addresses: $e');
    }
    return addresses;
  }
}

void main() async {
  List<String> ipAddresses = await IpUtil.getAllIpAddresses();
  print('All IP Addresses:');
  for (var ip in ipAddresses) {
    print(ip);
  }
}
