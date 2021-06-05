import 'dart:io';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImplementation implements NetworkInfo {

  @override
  Future<bool> isConnected() async {
    try {
      final response = await InternetAddress.lookup('https://www.google.com');
      return response.isNotEmpty;
    } on SocketException {
      return false;
    } catch (error) {
      return false;
    }
  }
}