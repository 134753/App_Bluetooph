import 'package:equatable/equatable.dart';
import '../models/bluetooth_device_model.dart';

abstract class BluetoothState extends Equatable {
  const BluetoothState();

  @override
  List<Object?> get props => [];
}

class BluetoothInitial extends BluetoothState {}

class BluetoothScanning extends BluetoothState {}

class BluetoothScanSuccess extends BluetoothState {
  final List<BluetoothDeviceModel> devices;

  const BluetoothScanSuccess(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BluetoothScanFailure extends BluetoothState {
  final String error;

  const BluetoothScanFailure(this.error);

  @override
  List<Object?> get props => [error];
}
