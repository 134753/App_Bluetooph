class BluetoothDeviceModel {
  final String id;
  final String name;
  final int rssi;

  BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
  });

  factory BluetoothDeviceModel.fromBluetoothDeviceScanResult(dynamic scanResult) {
    return BluetoothDeviceModel(
      id: scanResult.device.id.id,
      name: scanResult.device.name.isEmpty ? 'Appareil inconnu' : scanResult.device.name,
      rssi: scanResult.rssi,
    );
  }
}

class WifiNetworkModel {
  final String ssid;
  final int signalLevel;
  final bool isSecure;

  WifiNetworkModel({
    required this.ssid,
    required this.signalLevel,
    required this.isSecure,
  });
}

