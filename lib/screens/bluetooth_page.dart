import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth/bluetooth_bloc.dart';
import '../bloc/bluetooth/bluetooth_event.dart';
import '../bloc/bluetooth/bluetooth_state.dart';
import '../bloc/wifi/wiFi_bloc.dart';
import '../bloc/wifi/wiFi_event.dart';
import '../bloc/wifi/wiFi_state.dart';
import '../models/bluetooth_device_model.dart';
import '../models/wifi_network_model.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth & WiFi Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // === Section Bluetooth ===
            const Text('Bluetooth', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            BlocBuilder<BluetoothBloc, BluetoothState>(
              builder: (context, state) {
                bool isScanning = state is BluetoothScanning;
                return ElevatedButton(
                  onPressed: () {
                    if (isScanning) {
                      context.read<BluetoothBloc>().add(StopScan());
                    } else {
                      context.read<BluetoothBloc>().add(StartScan());
                    }
                  },
                  child: Text(isScanning ? 'Arrêter le scan Bluetooth' : 'Démarrer le scan Bluetooth'),
                );
              },
            ),
            Expanded(
              flex: 1,
              child: BlocBuilder<BluetoothBloc, BluetoothState>(
                builder: (context, state) {
                  if (state is BluetoothInitial) {
                    return const Center(child: Text('Appuyez sur démarrer pour scanner Bluetooth'));
                  } else if (state is BluetoothScanning) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BluetoothScanSuccess) {
                    final devices = state.devices;
                    if (devices.isEmpty) {
                      return const Center(child: Text('Aucun appareil Bluetooth trouvé'));
                    }
                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        BluetoothDeviceModel device = devices[index];
                        return ListTile(
                          title: Text(device.name),
                          subtitle: Text(device.id),
                          trailing: Text('RSSI: ${device.rssi}'),
                        );
                      },
                    );
                  } else if (state is BluetoothScanFailure) {
                    return Center(child: Text('Erreur Bluetooth: ${state.error}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            const Divider(height: 30),

            // === Section WiFi ===
            const Text('WiFi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            BlocBuilder<WifiBloc, WifiState>(
              builder: (context, state) {
                bool isScanning = state is WifiScanning;
                return ElevatedButton(
                  onPressed: () {
                    if (isScanning) {
                      context.read<WifiBloc>().add(WifiStopScan());
                    } else {
                      context.read<WifiBloc>().add(WifiStartScan());
                    }
                  },
                  child: Text(isScanning ? 'Arrêter le scan WiFi' : 'Démarrer le scan WiFi'),
                );
              },
            ),
            Expanded(
              flex: 1,
              child: BlocBuilder<WifiBloc, WifiState>(
                builder: (context, state) {
                  if (state is WifiInitial) {
                    return const Center(child: Text('Appuyez sur démarrer pour scanner WiFi'));
                  } else if (state is WifiScanning) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WifiScanSuccess) {
                    final networks = state.networks;
                    if (networks.isEmpty) {
                      return const Center(child: Text('Aucun réseau WiFi trouvé'));
                    }
                    return ListView.builder(
                      itemCount: networks.length,
                      itemBuilder: (context, index) {
                        WifiNetworkModel network = networks[index];
                        return ListTile(
                          title: Text(network.ssid),
                          trailing: Text('Signal: ${network.signalLevel}'),
                          subtitle: Text(network.isSecure ? 'Sécurisé' : 'Ouvert'),
                        );
                      },
                    );
                  } else if (state is WifiScanFailure) {
                    return Center(child: Text('Erreur WiFi: ${state.error}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

