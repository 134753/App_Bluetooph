import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/bluetooth_device_model.dart';
import 'bluetooth_event.dart';
import 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  StreamSubscription? _scanSubscription;

  BluetoothBloc() : super(BluetoothInitial()) {
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
  }

  Future<bool> _checkPermissions() async {
    final List<Permission> permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ];

    for (var permission in permissions) {
      if (!await permission.isGranted) {
        final status = await permission.request();
        if (!status.isGranted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _onStartScan(StartScan event, Emitter<BluetoothState> emit) async {
    emit(BluetoothScanning());

    final granted = await _checkPermissions();

    if (!granted) {
      emit(const BluetoothScanFailure('Permissions Bluetooth et localisation refusées'));
      return;
    }

    _scanSubscription?.cancel();

    try {
      List<BluetoothDeviceModel> devices = [];

      _scanSubscription = _flutterBlue.scan(timeout: const Duration(seconds: 5)).listen(
        (scanResult) {
          final deviceModel = BluetoothDeviceModel.fromBluetoothDeviceScanResult(scanResult);
          if (!devices.any((d) => d.id == deviceModel.id)) {
            devices.add(deviceModel);
            emit(BluetoothScanSuccess(List.from(devices)));
          }
        },
        onError: (error) {
          emit(BluetoothScanFailure(error.toString()));
        },
        onDone: () {
          emit(BluetoothInitial());
        },
      );
    } catch (e) {
      emit(BluetoothScanFailure(e.toString()));
    }
  }

  Future<void> _onStopScan(StopScan event, Emitter<BluetoothState> emit) async {
    await _scanSubscription?.cancel();
    emit(BluetoothInitial());
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    return super.close();
  }
}

