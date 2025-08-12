import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../models/bluetooth_device_model.dart';
import 'wiFi_event.dart';
import 'wiFi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  StreamSubscription? _scanSubscription;

  WifiBloc() : super(WifiInitial()) {
    on<WifiStartScan>(_onStartScan);
    on<WifiStopScan>(_onStopScan);
  }

  Future<void> _onStartScan(WifiStartScan event, Emitter<WifiState> emit) async {
    emit(WifiScanning());

    try {
      bool canScan = await WiFiForIoTPlugin.isEnabled();

      if (!canScan) {
        emit(const WifiScanFailure('Le WiFi est désactivé'));
        return;
      }

      final List<WifiNetwork>? networks = await WiFiForIoTPlugin.loadWifiList();

      if (networks == null || networks.isEmpty) {
        emit(const WifiScanFailure('Aucun réseau WiFi trouvé'));
        return;
      }

      final wifiModels = networks.map((wifi) => WifiNetworkModel(
            ssid: wifi.ssid ?? "Inconnu",
            signalLevel: wifi.level ?? 0,
            isSecure: wifi.capabilities?.contains('WEP') == true ||
                wifi.capabilities?.contains('WPA') == true,
          )).toList();

      emit(WifiScanSuccess(wifiModels));
    } catch (e) {
      emit(WifiScanFailure(e.toString()));
    }
  }

  Future<void> _onStopScan(WifiStopScan event, Emitter<WifiState> emit) async {
    emit(WifiInitial());
  }
}
