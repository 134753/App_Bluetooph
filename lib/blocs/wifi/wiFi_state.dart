import 'package:equatable/equatable.dart';
import '../models/bluetooth_device_model.dart';

abstract class WifiState extends Equatable {
  const WifiState();

  @override
  List<Object?> get props => [];
}

class WifiInitial extends WifiState {}

class WifiScanning extends WifiState {}

class WifiScanSuccess extends WifiState {
  final List<WifiNetworkModel> networks;

  const WifiScanSuccess(this.networks);

  @override
  List<Object?> get props => [networks];
}

class WifiScanFailure extends WifiState {
  final String error;

  const WifiScanFailure(this.error);

  @override
  List<Object?> get props => [error];
}
