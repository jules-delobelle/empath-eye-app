import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

class BLEService {

  static const String serviceUUID = "948c621a-6017-443d-8f75-fd00cf7af340";
  static const String detectionsUUID = "fbd3e679-420f-4027-86ac-528d8251ae94";
  static const String statutUUID = "5ef1754d-6049-4a93-a80e-9f162316b6ae";
  static const String batterieUUID = "24a0b8cc-dec8-430f-9202-400e319daa8b";

  static Stream<List<ScanResult>> scanDevices() {
      FlutterBluePlus.startScan(
      timeout: Duration(seconds: 5)
     );
     return FlutterBluePlus.scanResults;
  }

  static void stopScan() async{
    FlutterBluePlus.stopScan();
  }

  static void connect(BluetoothDevice device) async{
    device.connect();
  }

  static void disconnect(BluetoothDevice device) async{
    device.disconnect();
  }

  static Future<List<int>?> readDetections(BluetoothDevice device) async{
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services){
      if (service.uuid.toString() == serviceUUID){
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var characteristic in characteristics){
          if (characteristic.uuid.toString() == detectionsUUID)
            return await characteristic.read();
        }
      }
    }
    return null;
  }

  static Map<String, dynamic> parseData(List<int> bytes){
    String decode = utf8.decode(bytes);
    return jsonDecode(decode);
  }
}