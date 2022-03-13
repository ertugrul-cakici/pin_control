import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialManager {
  static String portString = "";
  static SerialPort? port;

  static bool isConnected = false;
  static bool get isPlugged => SerialPort.availablePorts.isNotEmpty;

  static bool connect() {
    disconnect();
    if (isPlugged) {
      for (String _portString in SerialPort.availablePorts) {
        try {
          port = SerialPort(_portString);
          port?.openReadWrite();
          isConnected = true;
          return true;
        } catch (e) {
          disconnect();
          return false;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  static void disconnect() {
    if (port != null) {
      port!.close();
      port!.dispose();
    }
    port = null;
    isConnected = false;
  }

  static bool sendCMD(String cmd) {
    if (isConnected) {
      Uint8List bytes = Uint8List.fromList(utf8.encode("S" + cmd));
      // print("cmd: $cmd bytearray: $bytes");
      int written = port!.write(bytes, timeout: 50);
      return bytes.length == written;
    } else {
      return false;
    }
  }
}
