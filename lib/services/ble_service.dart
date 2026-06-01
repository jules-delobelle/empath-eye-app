import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

class BLEService {

  static const String serviceUUID = "948c621a-6017-443d-8f75-fd00cf7af340";
  static const String transferUUID = "fbd3e679-420f-4027-86ac-528d8251ae94";
  static const String commandUUID = "5ef1754d-6049-4a93-a80e-9f162316b6ae";

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
          if (characteristic.uuid.toString() == transferUUID){
            return await characteristic.read();
          }
        }
      } 
    }
    return null;
  }

  static Future<void> sendCommand(BluetoothDevice device, String command) async{
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services){
      if (service.uuid.toString() == serviceUUID){
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var characteristic in characteristics){
          if (characteristic.uuid.toString() == commandUUID){
            List<int> bytes = utf8.encode(command);
            await characteristic.write(bytes);
            return;
          }
        }
      }
    }
  }

  static Stream<List<int>> listenTransfer(BluetoothDevice device) async*{
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services){
      if(service.uuid.toString() == serviceUUID){
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var characteristic in characteristics){
          if (characteristic.uuid.toString() == transferUUID){
            await characteristic.setNotifyValue(true);

            yield* characteristic.onValueReceived;

            return;
          }
        }
      }
    }
  }

  static Map<String, dynamic> parseData(List<int> bytes){
    String decode = utf8.decode(bytes);
    return jsonDecode(decode);
  }
}