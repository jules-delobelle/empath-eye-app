import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

class BLEService {

  static const String serviceUUID = "948c621a-6017-443d-8f75-fd00cf7af340";
  static const String transferUUID = "fbd3e679-420f-4027-86ac-528d8251ae94";
  static const String commandUUID = "5ef1754d-6049-4a93-a80e-9f162316b6ae";

  static Future<List<ScanResult>> scanDevices() async {
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    await FlutterBluePlus.isScanning.where((scanning) => scanning == false).first;
    return FlutterBluePlus.lastScanResults;
  } 

  static void stopScan() async{
    FlutterBluePlus.stopScan();
  }

  static Future<void> connect(BluetoothDevice device) async{
    await device.connect();
  }

  static Future<void> disconnect(BluetoothDevice device) async{
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
  print("listenTransfer démarré");
  List<BluetoothService> services = await device.discoverServices();
  print("Services découverts: ${services.length}");
  for (var service in services){
    if(service.uuid.toString() == serviceUUID){
      print("Service trouvé !");
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      for (var characteristic in characteristics){
        if (characteristic.uuid.toString() == transferUUID){
          print("Caractéristique trouvée, abonnement aux notifications...");
          await characteristic.setNotifyValue(true);
          print("Abonné ! En attente de données...");
          yield* characteristic.onValueReceived;
          print("Stream terminé"); 
          return;
        }
      }
    }
  }
  print(" Aucune caractéristique trouvée !");
}

  static Map<String, dynamic> parseData(List<int> bytes){
    String decode = utf8.decode(bytes);
    return jsonDecode(decode);
  }
}